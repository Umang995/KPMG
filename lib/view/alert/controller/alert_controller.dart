import 'dart:async';
import 'package:dreamcast/api_repository/app_url.dart';
import 'package:dreamcast/view/alert/model/notification_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/pref_utils.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../dashboard/dashboard_controller.dart';

class AlertController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AuthenticationManager _authManager;

  AuthenticationManager get authManager => _authManager;

  final DashboardController dashboardController = Get.find();

  late StreamSubscription<DatabaseEvent> _onChildAddedListener;

  var personalAlertList = <NotificationModel>[].obs;
  var personalAlertTepList = <NotificationModel>[].obs;

  var broadcastAlertList = <NotificationModel>[].obs;
  var broadcastAlertTempList = <NotificationModel>[].obs;

  late TabController _tabController;
  TabController get tabController => _tabController;
  var isFirstLoading = false.obs;
  var loading = false.obs;
  var titleAllMessage = "All Messages".obs;

  var notification = [].obs;
  var tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      tabIndex.value = Get.arguments["tabIndex"] ?? 0;
    }
    _authManager = Get.find();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.index = tabIndex.value;
    initNotificationRef();
  }

  initNotificationRef() {
    isFirstLoading(true);
    personalAlertList.clear();
    broadcastAlertList.clear();
    personalAlertTepList.clear();
    broadcastAlertTempList.clear();

    _onChildAddedListener = authManager.firebaseDatabase
        .ref(AppUrl.defaultFirebaseNode)
        .child("notifications")
        .child("personal")
        .child(PrefUtils.getUserId() ?? "")
        .onChildAdded
        .listen((event) async {
      if (event.snapshot.value != null) {
        final json = event.snapshot.value as Map<dynamic, dynamic>;
        final message = NotificationModel.fromJson(json);
        message.key = event.snapshot.key;
        personalAlertTepList.add(message);
      }
    });
    Future.delayed(const Duration(seconds: 1), () {
      //isFirstLoading(false);
      personalAlertList(personalAlertTepList.reversed.toList());
      personalAlertList.refresh();
      titleAllMessage.value = "All Messages";
    });

    _onChildAddedListener = authManager.firebaseDatabase
        .ref(AppUrl.defaultFirebaseNode)
        .child("notifications")
        .child("broadcast")
        .onChildAdded
        .listen(
      (event) async {
        if (event.snapshot.value != null) {
          final json = event.snapshot.value as Map<dynamic, dynamic>;
          final message = NotificationModel.fromJson(json);
          message.key = event.snapshot.key;
          broadcastAlertTempList.add(message);
          broadcastAlertList.refresh();
          broadcastAlertTempList.refresh();
        }
      },
    );

    Future.delayed(const Duration(seconds: 3), () {
      isFirstLoading(false);
      broadcastAlertList(broadcastAlertTempList.reversed.toList());
    });
  }

  updateAllReadStatus({isPersonal}) async {
    if (isPersonal) {
      for (var i = 0; i < personalAlertList.length; i++) {
        final notificationId = personalAlertList[i].key;
        await authManager.firebaseDatabase
            .ref(
                "${AppUrl.defaultFirebaseNode}/notifications/personal/${PrefUtils.getUserId()}/$notificationId")
            .update({
          "read": true,
        });
        personalAlertList[i].read = true;
      }
      personalAlertList.refresh();
      dashboardController.getNotificationCount();
    }
  }

  Future<void> getAllMessages({isPersonal}) async {
    personalAlertTepList.clear();
    if (isPersonal) {
      authManager.firebaseDatabase
          .ref(AppUrl.defaultFirebaseNode)
          .child("notifications")
          .child("personal")
          .child(PrefUtils.getUserId() ?? "")
          .onChildAdded
          .listen((event) async {
        if (event.snapshot.value != null) {
          final json = event.snapshot.value as Map<dynamic, dynamic>;
          final message = NotificationModel.fromJson(json);
          message.key = event.snapshot.key;
          personalAlertTepList.add(message);
        }
      });
      Future.delayed(const Duration(seconds: 1), () {
        //isFirstLoading(false);
        personalAlertList.clear();
        personalAlertList(personalAlertTepList.reversed.toList());
        personalAlertList.refresh();
      });
      dashboardController.getNotificationCount();
    }
  }

  Future<void> getUnreadMessages({isPersonal}) async {
    if (isPersonal) {
      final snapshot = await authManager.firebaseDatabase
          .ref(
              "${AppUrl.defaultFirebaseNode}/notifications/personal/${PrefUtils.getUserId()}")
          .orderByChild("read")
          .equalTo(false) // Filter for unread messages only
          .get();
      if (snapshot.exists) {
        personalAlertList.clear();
        snapshot.children.forEach((data) {
          final json = data.value as Map<dynamic, dynamic>;
          final message = NotificationModel.fromJson(json);
          message.key = data.key;
          personalAlertList.add(message);
          personalAlertList.refresh();
        });
        personalAlertList.refresh();
        dashboardController.getNotificationCount();
      } else {
        personalAlertList.clear();
      }
    }
  }

  updateReadStatus({notificationId, index, isPersonal}) async {
    if (isPersonal) {
      await authManager.firebaseDatabase
          .ref(
              "${AppUrl.defaultFirebaseNode}/notifications/personal/${PrefUtils.getUserId()}/$notificationId")
          .update({
        "read": true,
      });
      personalAlertList[index].read = true;
      personalAlertList.refresh();
      dashboardController.getNotificationCount();
    }
  }

  reverseTheList(index) {
    if (index == 0) {
      Future.delayed(const Duration(seconds: 0), () {
        isFirstLoading(false);
        broadcastAlertList(broadcastAlertTempList.reversed.toList());
      });
    } else {
      Future.delayed(const Duration(seconds: 0), () {
        isFirstLoading(false);
        personalAlertList(personalAlertTepList.reversed.toList());
      });
    }
  }

  @override
  void onClose() {
    super.onClose();
    _onChildAddedListener.cancel();
  }
}
