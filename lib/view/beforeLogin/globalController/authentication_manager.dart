import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dreamcast/model/common_model.dart';
import 'package:dreamcast/theme/controller/theme_controller.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/view/eventFeed/controller/eventFeedController.dart';
import 'package:dreamcast/view/reportUser/userReportController.dart';
import 'package:dreamcast/widgets/dialog/custom_dialog_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signin_with_linkedin/signin_with_linkedin.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../api_repository/app_url.dart';
import '../../../fcm/push_notification_service.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/pref_utils.dart';
import '../../dashboard/dashboard_page.dart';
import '../splash/model/config_model.dart';
import '../../../api_repository/api_service.dart';
import 'package:path_provider/path_provider.dart';

class AuthenticationManager extends GetxController {
  var iosAppVersion = 28;
  var _currAppVersion = "";
  get currAppVersion => _currAppVersion;
  var isAiFeature = false.obs;
  var isGuestLogin = false;

  final isLogged = false.obs;
  final loading = false.obs;
  final isRemember = false.obs;
  ConfigModel _configModel = ConfigModel();
  late String _osName;
  late FirebaseMessaging _firebaseMessaging;
  var tokenExpired = false;
  FirebaseMessaging get firebaseMessaging => _firebaseMessaging;
  late final FirebaseDatabase _firebaseDatabase;
  FirebaseDatabase get firebaseDatabase => _firebaseDatabase;
  var showBadge = false.obs;
  var isMuteNotification = false.obs;
  late final SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;

  String _platformVersion = "";
  late String _dc_device = "tablet";

  String get dc_device => _dc_device;

  String get platformVersion => _platformVersion;

  String get osName => _osName;
  ConfigModel get configModel => _configModel;
  String pageRouteName = "";
  String pageRouteId = "";
  String? pageRouteTitle;
  String role = "";

  var notificationNode = {};
  var showWelcomeDialog = false;
  var showForceUpdateDialog = false.obs;

  LinkedInConfig? _linkedInConfig;
  LinkedInConfig? get linkedInConfig => _linkedInConfig;

  var localBadgePath = "";

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  String deeplinkUrl = "https://applinks.evnts.info/3b9aca01";

  set configModel(ConfigModel value) {
    _configModel = value;
    update();
  }

  ThemeController themeController = Get.find<ThemeController>();
  @override
  onInit() async {
    super.onInit();
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseDatabase = FirebaseDatabase.instance;
    fcmSubscribe();
    getInitialInfo();
    final pushNotificationService = PushNotificationService(_firebaseMessaging);
    pushNotificationService.initialise();
  }

  @override
  void onReady() {
    super.onReady();
    getFcmTokenFrom();
    initSharedPref();
    checkTheInternet();
  }

  Future<void> clearAppStorage() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
      }
    } catch (e) {
      print("Error clearing app storage: $e");
    }
  }

  linkedinSetupDynamic() {
    _linkedInConfig = LinkedInConfig(
        clientId: configModel.body?.linkedInDetail?.clientId ?? "",
        clientSecret: configModel.body?.linkedInDetail?.clientSecret ?? "",
        redirectUrl: configModel.body?.linkedInDetail?.redirectUrl ?? "",
        scope: ['openid', 'profile', 'email', 'r_basicprofile']);
  }

  void checkUpdate() {
    Future.delayed(const Duration(seconds: 2), () {
      if (Platform.isAndroid) {
        versionCheck();
      } else {
        versionCheckIos();
      }
    });
  }

  final userReportController = Get.put(UserReportController());

  Future<void> getConfigDetail() async {
    final model = ConfigModel.fromJson(json.decode(
      await apiService.dynamicGetRequest(
          url: AppUrl.getConfig, defaultHeader: true),
    ));

    try {
      if (model?.status == true && model?.code == 200) {
        configModel = model;
        userReportController.selectedReportOption.value = 0;
        userReportController.commentResign =
            model.body?.reportOptions?.networking ?? [];
        PrefUtils.setGuestLoginId(model?.body?.guestId ?? "");
        final firebase = model?.body?.config?.firebase;
        final meta = model?.body?.meta;
        PrefUtils.saveTimezone(model.body?.defaultTimezone ?? "");
        AppUrl.setDefaultFirebaseNode = firebase?.name?.toLowerCase() ?? "";
        AppUrl.setTopicName = firebase?.topics?.all?.toString() ?? "";
        AppUrl.setDataBaseUrl = firebase?.configs?.databaseURL ?? "";
        AppUrl.appName = meta?.title ?? "";
        PrefUtils.setAiFeature(model.body?.themeSetting?.aiFeature ?? false);
        PrefUtils.setGuestLogin(
            model.body?.themeSetting?.isGuestLogin ?? false);
        if (model.body?.themeSetting?.primaryColor != null &&
            model.body?.themeSetting?.secondaryColor != null) {
          themeController.updateColor(
            primaryColor: UiHelper.getColorByHexCode(
                model.body?.themeSetting?.primaryColor ?? ""),
            secondaryColor: UiHelper.getColorByHexCode(
                model.body?.themeSetting?.secondaryColor ?? ""),
          );
        }
        linkedinSetupDynamic();
        print("===>${AppUrl.defaultFirebaseNode}");
        print(AppUrl.topicName);
        print(AppUrl.dataBaseUrl);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      loading(false);
      update();
    }
  }

  Future<void> deleteYourAccount() async {
    loading(true);
    final model = CommonModel.fromJson(json.decode(
      await apiService.dynamicGetRequest(url: AppUrl.deleteAccount),
    ));
    loading(false);
    if (model.status! && model.code == 200) {
      UiHelper.showSuccessMsg(null, model?.message ?? "");
      PrefUtils.clearPreferencesData();
      PrefUtils.saveTimezone(configModel.body?.defaultTimezone ?? "");
      Get.offNamedUntil(Routes.LOGIN, (route) => false);
    }
  }

  //used for the logout the session from the server
  Future<void> logoutTheUserAPi() async {
    loading(true);
    final model = CommonModel.fromJson(json.decode(
      await apiService.dynamicGetRequest(url: AppUrl.logoutApi),
    ));
    loading(false);
    if (model.status! && model.code == 200) {
      await FirebaseAuth.instance.signOut();
      if (PrefUtils.getGuestLogin()) {
        PrefUtils.clearPreferencesData();
        PrefUtils.setGuestLogin(true);
        PrefUtils.saveTimezone(configModel.body?.defaultTimezone ?? "");
        Get.offNamedUntil(DashboardPage.routeName, (route) => false);
      } else {
        PrefUtils.clearPreferencesData();
        PrefUtils.setGuestLogin(false);
        PrefUtils.saveTimezone(configModel.body?.defaultTimezone ?? "");
        Get.offNamedUntil(Routes.LOGIN, (route) => false);
      }
    } else {
      Get.offNamedUntil(Routes.LOGIN, (route) => false);
    }
  }

  void fcmSubscribe() {
    print("fcmSubscribe");
    _firebaseDatabase.databaseURL = AppUrl.dataBaseUrl;
    print("fcmSubscribe ${_firebaseDatabase.databaseURL}");

    try {
      firebaseDatabase
          .ref("${AppUrl.eventAppNode}/${AppUrl.defaultNodeName}")
          .onValue
          .listen((event) {
        if (event.snapshot.value != null) {
          final json = event.snapshot.value as Map<dynamic, dynamic>;
          if (json["endPointv4"] != null &&
              json["endPointv4"].toString().isNotEmpty) {
            AppUrl.baseURLV1 = json["endPointv4"];
            print("AppUrl.baseURLV1 ${AppUrl.baseURLV1}");
          }
        }
      });
      if (PrefUtils.getAuthToken() != null &&
          PrefUtils.getAuthToken()!.isNotEmpty) {
        signInFirebaseByCustomToken(PrefUtils.getAuthToken() ?? "");
      }
    } catch (e) {
      print("fcmSubscribe error: $e");
    }
  }

  initSharedPref() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /*get device token from firebase service*/
  void getFcmTokenFrom() async {
    _firebaseMessaging.getToken().then((token) {
      PrefUtils.saveFcmToken(token);
      print('token: $token');
    }).catchError((err) {
      print("This is bug from FCM${err.message.toString()}");
    });
  }

  bool isLogin() {
    print("isLogin ${PrefUtils.getToken()}");
    if (PrefUtils.getToken() != null && PrefUtils.getToken().isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  getInitialInfo() {
    final data = MediaQueryData.fromView(WidgetsBinding.instance.window);
    _dc_device = data.size.shortestSide < 600 ? 'mobile' : 'tablet';

    print("_dc_device$_dc_device");

    _osName = Platform.isAndroid ? "android" : "ios";
  }

  Future<void> adFcmDeviceToken(String token) async {
    if (!isLogin()) {
      return;
    }

    if (token == null || token.isEmpty) {
      await _firebaseMessaging.getToken().then((newToken) {
        PrefUtils.saveFcmToken(newToken);
        token = newToken ?? "";
      }).catchError((err) {
        print("This is bug from FCM${err.message.toString()}");
      });
    }

    var loginRequest = {
      //"device_id": Platform.isAndroid ? "android" : "ios",
      "registration_token": token ?? ""
    };
    debugPrint("token added: $token");
    CommonModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          url: AppUrl.updateFcm, body: loginRequest),
    ));
  }

  signInFirebaseByCustomToken(customToken) async {
    try {
      UserCredential user =
          await FirebaseAuth.instance.signInWithCustomToken(customToken);
      refreshTheFirebaseToken();
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      switch (e.code) {
        case "invalid-custom-token":
          print("501 The supplied token is not a Firebase custom auth token.");
          break;
        case "custom-token-mismatch":
          print("501  The supplied token is for a different Firebase project.");
          break;
        default:
          print("501  Unkown error.");
      }
    }
  }

  //force update..
  versionCheck() async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.buildNumber.trim().replaceAll(".", ""));
    _currAppVersion = info.version.toString();
    try {
      if (double.parse(configModel.body?.flutter?.version ?? "0") >
          currentVersion) {
        await Get.dialog(
            barrierDismissible: false,
            WillPopScope(
              onWillPop: () async => false,
              child: CustomDialogWidget(
                title: "force_update_title".tr,
                logo: "",
                description: configModel.body?.flutter?.updateMessage ??
                    "force_update_msg".tr,
                buttonAction: "update_now".tr,
                buttonCancel: "cancel".tr,
                isShowBtnCancel:
                    configModel.body!.flutter!.forceDownload == false
                        ? true
                        : false,
                onCancelTap: () {},
                onActionTap: () async {
                  _launchURL(configModel.body?.flutter?.playStoreUrl ??
                      "PLAY_STORE_URL".tr);
                },
              ),
            ));
        showForceUpdateDialog(true);
      } else {
        showForceUpdateDialog(false);
      }
    } catch (exception) {
      print(exception.toString());
    }
  }

  versionCheckIos() async {
    try {
      final PackageInfo info = await PackageInfo.fromPlatform();
      _currAppVersion = info.version.toString();
      // _currAppVersion = iosAppVersion.toString();
      print("version ${configModel.body?.flutter?.version}");
      if (double.parse(configModel.body?.flutter?.version ?? "0") >
          iosAppVersion) {
        showForceUpdateDialog(true);
        await Get.dialog(
            barrierDismissible: false,
            WillPopScope(
              onWillPop: () async => false,
              child: CustomDialogWidget(
                title: "force_update_title".tr,
                logo: "",
                description: configModel.body?.flutter?.updateMessage ??
                    "force_update_msg".tr,
                buttonAction: "update_now".tr,
                buttonCancel: "cancel".tr,
                isShowBtnCancel:
                    configModel.body!.flutter!.forceDownload == false
                        ? true
                        : false,
                onCancelTap: () {},
                onActionTap: () async {
                  _launchURL(configModel.body?.flutter?.appStoreUrl ??
                      "APP_STORE_URL".tr);
                },
              ),
            ));
      } else {
        showForceUpdateDialog(false);
      }
    } catch (exception) {
      print(exception.toString());
    }
  }

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      if (Platform.isAndroid) {
        versionCheck();
      } else {
        versionCheckIos();
      }
    } else {
      throw 'Could not launch $url';
    }
  }

  refreshTheFirebaseToken() {
    Timer.periodic(const Duration(minutes: 55), (Timer t) {
      FirebaseAuth.instance.currentUser?.getIdToken(true);
      String msg =
          "${DateTime.now().hour} : ${DateTime.now().minute} ${DateTime.now().second}"; //'notification ' + counter.toString();
      print('SEND: $msg');
    });
  }

  checkTheInternet() {
    InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.disconnected:
          break;
        case InternetConnectionStatus.connected:
          break;
      }
    });
  }
}
