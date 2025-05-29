import 'dart:async';
import 'dart:convert';
import 'package:dreamcast/api_repository/app_url.dart';
import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/view/account/controller/account_controller.dart';
import 'package:dreamcast/view/beforeLogin/signup/model/signup_category_model.dart';
import 'package:dreamcast/view/beforeLogin/splash/splash_page.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:dreamcast/view/dashboard/dashboard_page.dart';
import 'package:dreamcast/view/profileSetup/view/edit_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dreamcast/api_repository/api_service.dart';

import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinput/pinput.dart';
import '../../../main.dart';
import '../../../model/common_model.dart';
import '../../../utils/pref_utils.dart';
import 'login_response.dart';

class LoginController extends GetxController {
  late final AuthenticationManager _authManager;

  final isPolicy = false.obs;
  var isLoading = false.obs;
  var signupform = false.obs;
  var signupCateList = <Categories>[].obs;
  var isOtpSend = false.obs;
  var isDisclamer = false.obs;
  var otpCode = "";
  final signupFieldList = <dynamic>[].obs;
  final textController = TextEditingController(text: "").obs;
  XFile? pickedFile;
  String likedEmail = "";
  var sentOTPMessage = "".obs;

  Timer? _periodicTimer;
  var tickCount = 30.obs;
  var isTimerIsRunning = false.obs;
  TextEditingController emailCtr = TextEditingController(text: '');
  final GlobalKey<FormState> formKey = GlobalKey();

//its used for OTP widget
  final defaultPinTheme = PinTheme(
    width: 39,
    height: 39,
    textStyle: TextStyle(
      fontSize: 18,
      color: colorSecondary,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: borderColor),
    ),
  );

  @override
  onInit() {
    super.onInit();
    _authManager = Get.find();
    _authManager.checkUpdate();
    //_authManager.getFcmTokenFrom();
  }

  void startPeriodicTimer() {
    tickCount(30);
    const oneSecond = Duration(seconds: 1);
    _periodicTimer = Timer.periodic(oneSecond, (Timer timer) {
      if (tickCount.value == 0) {
        timer.cancel();
        isTimerIsRunning.value = false;
      } else {
        tickCount--;
        isTimerIsRunning.value = true;
      }
    });
  }

  void isPolicyAccept(bool value) {
    isPolicy(!isPolicy.value);
  }

  Future<void> commonLoginApi(
      {required requestBody,
      required String url,
      required BuildContext context,
      required bool isGuestForm}) async {
    isLoading(true);

    final loginResponseModel = LoginResponseModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          url: url, body: requestBody, defaultHeader: true, isLoginApi: true),
    ));
    isLoading(false);
    try {
      if (loginResponseModel!.status! && loginResponseModel.code == 200) {
        await _authManager.clearAppStorage();
        await PrefUtils.saveProfileData(
          fullName: loginResponseModel.body?.name ?? "",
          username: loginResponseModel.body?.shortName ?? "",
          profile: loginResponseModel.body?.avatar ?? "",
          userId: loginResponseModel.body?.id ?? "",
          role: loginResponseModel.body?.role ?? "",
          chatId: "",
          email: "",
          category: "",
        );
        await PrefUtils.savePrivacyData(
            isChat: loginResponseModel.body?.isChat == 1 ? true : false,
            isMeeting: loginResponseModel.body?.isMeeting == 1 ? true : false,
            isProfile: false);
        PrefUtils.saveTimezone(loginResponseModel.body?.timezone ?? "");
        PrefUtils.saveAuthToken(loginResponseModel.body?.accessToken ?? "");
        PrefUtils.saveExhibitorType(
            loginResponseModel.body?.exhibitorType ?? "");
        PrefUtils.setProfileUpdate(
            loginResponseModel.body?.hasProfileUpdate ?? 0);
        PrefUtils.setGuestLoginId("");
        _authManager.adFcmDeviceToken(PrefUtils.getFcmToken() ?? "");
        _authManager.showWelcomeDialog = true;
        if (isGuestForm) {
          UiHelper.showSuccessMsg(
              context, "Welcome back! You’ve successfully logged in.");
          if (Get.isRegistered<AccountController>()) {
            AccountController controller = Get.find();
            controller.getProfileData(isFromDashboard: true);
          }
          Get.forceAppUpdate();
          Get.back();
        } else {
          if (loginResponseModel.body?.hasProfileUpdate == 0) {
            Future.delayed(const Duration(seconds: 1), () async {
              await Get.toNamed(ProfileEditPage.routeName);
              Get.offNamedUntil(DashboardPage.routeName, (route) => false);
            });
          } else {
            Get.offNamedUntil(DashboardPage.routeName, (route) => false);
          }
        }
      } else {
        if (loginResponseModel.body?.email != null) {
          UiHelper.showFailureMsg(
              context, loginResponseModel.body?.email ?? "");
        } else {
          UiHelper.showFailureMsg(
              context, loginResponseModel.message.toString());
        }
      }
    } catch (exception) {
      UiHelper.showFailureMsg(context, exception.toString());
    }
  }

  Future<void> shareVerificationCode(
      String mobile, BuildContext context) async {
    var loginRequest = {
      "email": mobile ?? "",
    };
    isLoading(true);

    final loginResponseModel = CommonModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: loginRequest,
          url: AppUrl.shareVerificationCode,
          defaultHeader: true,
          isLoginApi: false),
    ));

    isLoading(false);

    if (loginResponseModel.status! && loginResponseModel.code == 200) {
      sentOTPMessage(loginResponseModel.message.toString());
      startPeriodicTimer();
      UiHelper.showSuccessMsg(context, loginResponseModel.message.toString());
      isOtpSend(true);
    } else {
      if (loginResponseModel.body?.email != null) {
        UiHelper.showFailureMsg(context, loginResponseModel.body?.email ?? "");
      } else {
        UiHelper.showFailureMsg(context, loginResponseModel.message.toString());
      }
    }
  }

  @override
  void dispose() {
    _periodicTimer?.cancel();
    super.dispose();
  }
}
