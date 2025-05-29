import 'dart:async';
import 'package:dreamcast/view/account/controller/account_controller.dart';
import 'package:dreamcast/view/dashboard/deep_linking_controller.dart';
import 'package:dreamcast/view/home/controller/for_you_controller.dart';
import 'package:dreamcast/view/home/controller/home_controller.dart';
import 'package:dreamcast/view/myFavourites/controller/favourite_controller.dart';
import 'package:dreamcast/view/myFavourites/controller/favourite_user_controller.dart';
import 'package:dreamcast/view/representatives/controller/networkingController.dart';
import 'package:dreamcast/widgets/dialog/custom_animated_dialog_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api_repository/app_url.dart';
import '../../utils/dialog_constant.dart';
import '../../utils/pref_utils.dart';
import '../alert/controller/alert_controller.dart';
import '../alert/pages/alert_dashboard.dart';
import '../alert/model/notification_model.dart';
import '../beforeLogin/globalController/authentication_manager.dart';
import '../menu/controller/menuController.dart';
import '../schedule/controller/session_controller.dart';

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var dashboardTabIndex = 0; //manage the dashboard tab index
  var selectedAiMatchIndex = 0.obs; //manage the Ai match tab index
  var chatTabIndex = 0.obs; //manage the chat dashboard tab index

  var chatCount = 0.obs;
  var notificationCount = 0.obs;

  var personalCount = 0.obs;
  var broadcastCount = 0.obs;

  var showPopup = false.obs; // manage the popup welcome dialog.
  final AuthenticationManager _authManager = Get.find();
  var loading = false.obs;
  var _currAppVersion = "";

  late TabController _tabController;
  TabController get tabController => _tabController;

  get currAppVersion => _currAppVersion;

  late SharedPreferences preferences;

  void changeTabIndex(int index) {
    if (index == 4) {
      if (!_authManager.isLogin()) {
        DialogConstantHelper.showLoginDialog(Get.context!, _authManager);
        return;
      }
    }
    dashboardTabIndex = index;
    showPopup(false);
    _authManager.checkUpdate();
    if (index == 2) {
      checkCurrentVersion();
    }
    apiCallAccordingIndex();
    loading(false);
    update();
  }

  ///fina code merge
  ///call the api on tab click
  apiCallAccordingIndex() {
    switch (dashboardTabIndex) {
      case 0:
        if (Get.isRegistered<HomeController>()) {
          HomeController homeController = Get.find();
          homeController.initApiCall();
        }
        break;
      case 1:
        if (Get.isRegistered<SessionController>()) {
          SessionController controller = Get.find();
          controller.loading(false);
          controller.initApiCall();
        }
        break;
      case 3:
        if (Get.isRegistered<NetworkingController>()) {
          NetworkingController controller = Get.find();
          controller.isLoading(false);

          controller.clearFilterOnTab();
          controller.initApiCall();
        }
        break;
      case 4:
        if (Get.isRegistered<AccountController>()) {
          AccountController controller = Get.find();
          controller.getProfileData(isFromDashboard: true);
        }
        break;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _tabController = TabController(vsync: this, length: 2);
    apiCallAccordingIndex();
    getNotificationCount();
    getChatCount();
    _authManager.adFcmDeviceToken(PrefUtils.getFcmToken() ?? "");
    _authManager.checkUpdate();
    if (PrefUtils.getAuthToken() != null &&
        PrefUtils.getAuthToken()!.isNotEmpty) {
      _authManager.signInFirebaseByCustomToken(PrefUtils.getAuthToken() ?? "");
    }
  }

  checkCurrentVersion() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.buildNumber.trim().replaceAll(".", ""));
    if (double.parse(_authManager.configModel.body?.flutter?.version ?? "0") <
        currentVersion) {
      _authManager.getConfigDetail();
    }
    return;
  }

  getNotificationCount() async {
    preferences = await SharedPreferences.getInstance();
    personalCount(0);
    broadcastCount(0);
    _authManager.firebaseDatabase
        .ref(
            "${AppUrl.defaultFirebaseNode}/notifications/personal/${PrefUtils.getUserId()}")
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        final json = event.snapshot.value as Map<dynamic, dynamic>;
        var message = json['read'];
        if (message == false) {
          personalCount((personalCount.value + 1));
        }
      }
    });

    _authManager.firebaseDatabase
        .ref("${AppUrl.defaultFirebaseNode}/notifications/broadcast")
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        broadcastCount((broadcastCount.value + 1));
        manageAlertBadge();
      }
    });
  }

  ///manage the alert badge count as well broad cast count received from firebase
  manageAlertBadge() {
    Future.delayed(const Duration(seconds: 5), () async {
      if ((broadcastCount.value >
          (preferences.getInt("broadcast_count") ?? 0))) {
        _authManager.showBadge(true);
      } else {
        _authManager.showBadge(false);
      }
    });
  }

  ///get the chat count from the firebase
  getChatCount() {
    _authManager.firebaseDatabase
        .ref(
            "${AppUrl.defaultFirebaseNode}/${AppUrl.chatUsers}/${PrefUtils.getUserId()}")
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        final json = event.snapshot.value as Map<dynamic, dynamic>;
        int count = json['count'] ?? 0;
        if (count > 0) {
          chatCount((chatCount.value + count));
        } else {
          chatCount(0);
        }
      }
    });
    _authManager.firebaseDatabase
        .ref(
            "${AppUrl.defaultFirebaseNode}/${AppUrl.chatUsers}/${PrefUtils.getUserId()}")
        .onChildChanged
        .listen((event) {
      if (event.snapshot.value != null) {
        final json = event.snapshot.value as Map<dynamic, dynamic>;
        int count = json['count'];
        if (count > 0) {
          chatCount.value = 0;
          chatCount.value = count;
        } else {
          chatCount(0);
        }
      }
    });
  }

  ///open the alert page
  openAlertPage() async {
    if (!_authManager.isLogin()) {
      DialogConstantHelper.showLoginDialog(Get.context!, _authManager);
      return;
    }
    preferences?.setInt("broadcast_count", broadcastCount.value);
    _authManager.showBadge(false);
    showPopup(false);
    if (Get.isRegistered<AlertController>()) {
      Get.delete<AlertController>();
    }
    Get.toNamed(AlertDashboard.routeName);
  }

  ///refresh the session when live and update the session status
  refreshTheSession() {
    if (Get.isRegistered<HomeController>()) {
      HomeController controller = Get.find();
      controller.getTodaySession(isRefresh: true);
    }
  }
}
