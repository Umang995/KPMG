import 'dart:io';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/beforeLogin/login/login_controller.dart';
import 'package:dreamcast/view/beforeLogin/widget/loginOtpWidget.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:signin_with_linkedin/signin_with_linkedin.dart';
import '../../../api_repository/app_url.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/dialog/custom_dialog_widget.dart';
import '../../../widgets/button/common_material_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/already_have_an_account_acheck.dart';
import '../../../widgets/or_divider.dart';
import '../../dashboard/dashboard_page.dart';
import 'loginEmailFieldWidget.dart';

class LoginFormWidget extends GetView<LoginController> {
  bool isGuestForm;
  LoginFormWidget({super.key, required this.isGuestForm});

  final AuthenticationManager _authmanager = Get.find();
  final _storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return GetX<LoginController>(
      builder: (controller) {
        return Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: controller.formKey,
          child: Container(
            margin: isGuestForm
                ? EdgeInsets.zero
                : EdgeInsets.symmetric(vertical: 0, horizontal: 35.adaptSize),
            padding: isGuestForm
                ? EdgeInsets.zero
                : const EdgeInsets.only(
                    top: 30, bottom: 30, left: 30, right: 30),
            decoration: BoxDecoration(
                color: white,
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                controller.isOtpSend.value
                    ? CustomTextView(
                        text: controller.sentOTPMessage.value,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorSecondary,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      )
                    : isGuestForm == false
                        ? CustomTextView(
                            text: "enter_your_detail".tr,
                            fontSize: 26,
                            color: colorSecondary,
                            fontWeight: FontWeight.w600,
                          )
                        : const SizedBox(),
                SizedBox(
                  height: 28.v,
                ),
                controller.isOtpSend.value
                    ? LoginOTPWidget(
                        isGuestForm: isGuestForm,
                      )
                    : LoginEmailWidget(
                        isGuestForm: isGuestForm,
                      ),
                controller.isOtpSend.value
                    ? const SizedBox(
                        height: 0,
                      )
                    : SizedBox(height: 20.v),
                CommonMaterialButton(
                  height: 55.v,
                  color: colorPrimary,
                  textSize: 18,
                  weight: FontWeight.w600,
                  isLoading: controller.isLoading.value,
                  onPressed: () {
                    if (controller.formKey.currentState?.validate() ?? false) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (controller.isOtpSend.value) {
                        if (controller.otpCode.isEmpty) {
                          UiHelper.showFailureMsg(
                              context, "please_enter_OTP".tr);
                          return;
                        }
                        var loginRequest = {
                          'email': controller.emailCtr.text.trim(),
                          "verification_code": controller.otpCode,
                        };
                        controller.commonLoginApi(
                            requestBody: loginRequest,
                            url: AppUrl.loginByOTP,
                            isGuestForm: isGuestForm,
                            context: context);
                      } else {
                        if (controller.emailCtr.text.trim().isEmpty) {
                          return;
                        } else if (!UiHelper.isEmail(
                            controller.emailCtr.text.trim())) {
                          return UiHelper.showFailureMsg(
                              context, "enter_valid_email_address".tr);
                        }
                        controller.shareVerificationCode(
                            controller.emailCtr.text.trim(), context);
                      }
                    }
                  },
                  text: controller.isOtpSend.value
                      ? "login".tr.toString()
                      : "send_otp".tr.toString(),
                ),
                controller.isOtpSend.value
                    ? const SizedBox()
                    : const SizedBox(),
                controller.isOtpSend.value
                    ? const SizedBox()
                    : Platform.isIOS || Platform.isAndroid
                        ? OrDivider()
                        : const SizedBox(),
                !controller.isOtpSend.value && Platform.isIOS
                    ? loginWithApple(context)
                    : const SizedBox(),
                !controller.isOtpSend.value
                    ? loginWithLinked(context)
                    : const SizedBox(),
                (isGuestForm ||
                        controller.isOtpSend.value ||
                        PrefUtils.getGuestLogin() == false)
                    ? const SizedBox()
                    : TextButton(
                        onPressed: () {
                          PrefUtils.clearPreferencesData();
                          PrefUtils.saveTimezone(
                            (_authmanager.configModel.body?.defaultTimezone
                                        ?.isNotEmpty ??
                                    false)
                                ? _authmanager
                                    .configModel.body!.defaultTimezone!
                                : "Asia/Kolkata",
                          );
                          isGuestForm
                              ? Get.back()
                              : Get.offAllNamed(DashboardPage.routeName);
                        },
                        child: CustomTextView(
                          text: "login_as_guest".tr,
                          fontSize: 18,
                          color: colorPrimary,
                        )),
                controller.isOtpSend.value ? backButton() : signupButton()
              ],
            ),
          ),
        );
      },
    );
  }

  Widget loginWithApple(BuildContext context) {
    return Platform.isIOS
        ? CommonMaterialButton(
            borderWidth: 1,
            borderColor: colorSecondary,
            color: white,
            svgIcon: "assets/svg/AppleLogo.svg",
            iconHeight: 15,
            height: 52.v,
            text: "continue_with_apple".tr,
            textSize: 16,
            textColor: colorSecondary,
            weight: FontWeight.w500,
            onPressed: () async {
              try {
                // Retrieve the Apple Sign-In credential
                final credential = await SignInWithApple.getAppleIDCredential(
                  scopes: [
                    AppleIDAuthorizationScopes.email,
                  ],
                  webAuthenticationOptions: WebAuthenticationOptions(
                    clientId: "signInAppleClientId".tr,
                    redirectUri: Uri.parse("signInWithAppleUrl".tr),
                  ),
                  nonce: 'example-nonce',
                  state: 'example-state',
                );

                // Check if email is available in the credential
                if (credential.email != null) {
                  // If email is available, store it securely
                  await _storage.write(
                      key: "user_email", value: credential.email);
                  print("Email stored securely: ${credential.email}");

                  var loginRequest = {
                    'email': credential.email.toString(),
                    "verification_code": "242526",
                    "login_via": "apple",
                  };
                  controller.commonLoginApi(
                      requestBody: loginRequest,
                      isGuestForm: isGuestForm,
                      url: AppUrl.loginByOTP,
                      context: context);
                } else {
                  // If email is null, fallback to the stored email
                  String? storedEmail = await _storage.read(key: "user_email");
                  if (storedEmail != null) {
                    print("Using stored email: $storedEmail");
                    var loginRequest = {
                      'email': storedEmail,
                      "verification_code": "242526",
                      "login_via": "apple",
                    };
                    controller.commonLoginApi(
                        requestBody: loginRequest,
                        isGuestForm: isGuestForm,
                        url: AppUrl.loginByOTP,
                        context: context);
                  } else {
                    // Handle the case where no email is available
                    print("No email available for login.");
                    // Optionally, show a message to the user
                    UiHelper.showFailureMsg(
                        context, "Unable to sign in. Email not available.");
                  }
                }
              } catch (e) {
                print("Error during Apple Sign-In: $e");
                // Handle the error appropriately, e.g., show an error message
                //UiHelper.showFailureMsg(context, "Error during Apple Sign-In: $e");
              }
            },
          )
        : const SizedBox();
  }

  Widget loginWithLinked(BuildContext context) {
    return _authmanager.linkedInConfig != null
        ? CommonMaterialButton(
            borderWidth: 1,
            borderColor: colorSecondary,
            color: white,
            svgIcon: "assets/svg/linkedin.svg",
            iconHeight: 15,
            height: 52.v,
            text: "continue_with_linkedin".tr,
            textSize: 16,
            textColor: colorSecondary,
            iconColor: Colors.black,
            weight: FontWeight.w500,
            onPressed: () async {
              SignInWithLinkedIn.logout();
              SignInWithLinkedIn.signIn(
                context,
                config: _authmanager.linkedInConfig!,
                onGetUserProfile: (tokenData, user) {
                  print('Auth token data: ${tokenData.accessToken}');
                  print('LinkedIn User: ${user.toJson()}');
                  if (user?.email != null && user!.email!.isNotEmpty) {
                    var loginRequest = {
                      'code': tokenData.accessToken ?? "",
                    };
                    controller.commonLoginApi(
                        requestBody: loginRequest,
                        isGuestForm: isGuestForm,
                        url: AppUrl.linkedInLoginApi,
                        context: context);
                  } else {
                    UiHelper.showFailureMsg(context, "user_not_found".tr);
                  }
                },
                onSignInError: (error) {
                  print('Error on sign in: $error');
                },
              );
            },
          )
        : const SizedBox();
  }

  Widget backButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 24.v),
        controller.isOtpSend.value
            ? InkWell(
                onTap: () {
                  controller.isOtpSend(false);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  height: 29,
                  width: 73,
                  decoration: BoxDecoration(
                    color: colorLightGray,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Center(
                    child: CustomTextView(
                      text: "back".tr,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                      color: colorSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget signupForm(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: controller.formKey,
      child: Container(
        decoration: BoxDecoration(
            color: white,
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
        padding:
            const EdgeInsets.only(top: 42, bottom: 30, left: 25, right: 25),
        child: SingleChildScrollView(
          child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextView(
                      text: "signup".tr,
                      fontSize: 26,
                      color: colorSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(
                      height: 28.v,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: loginWithWeb(),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: loginWithWhatsApp(),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 40.v,
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.signupform.value = false;
                      },
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CustomTextView(
                                text: "already_have_account".tr,
                                color: colorSecondary,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                              CustomTextView(
                                  text: "Sign In",
                                  underline: true,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: colorPrimary),
                              //RegularTextView(text: login ? MyStrings.signup : "Login",color: primaryColor,)
                            ],
                          )),
                    )
                  ])),
        ),
      ),
    );
  }

  Widget signupButton() {
    return (_authmanager.configModel.body?.pages?.signup?.whatsApp != null &&
                _authmanager
                    .configModel.body!.pages!.signup!.whatsApp!.isNotEmpty) ||
            (_authmanager.configModel.body?.pages?.signup?.url != null &&
                _authmanager.configModel.body!.pages!.signup!.url!.isNotEmpty)
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 24.v),
              GestureDetector(
                onTap: () {
                  if ((_authmanager.configModel.body?.pages?.signup?.whatsApp !=
                              null &&
                          _authmanager.configModel.body!.pages!.signup!
                              .whatsApp!.isNotEmpty) &&
                      (_authmanager.configModel.body?.pages?.signup?.url !=
                              null &&
                          _authmanager.configModel.body!.pages!.signup!.url!
                              .isNotEmpty)) {
                    controller.signupform.value = true;
                  } else if (_authmanager
                              .configModel.body?.pages?.signup?.whatsApp !=
                          null &&
                      _authmanager.configModel.body!.pages!.signup!.whatsApp!
                          .isNotEmpty) {
                    UiHelper.inAppBrowserView(Uri.parse(_authmanager
                            .configModel.body!.pages!.signup!.whatsApp ??
                        ""));
                  } else {
                    UiHelper.inAppBrowserView(Uri.parse(
                        _authmanager.configModel.body!.pages!.signup!.url ??
                            ""));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: const AlreadyHaveAnAccountCheck(
                    true,
                  ),
                ),
              )
            ],
          )
        : const SizedBox();
  }

  Widget loginWithWeb() {
    return CommonMaterialButton(
        borderWidth: 1,
        borderColor: colorSecondary,
        color: white,
        svgIcon: "assets/svg/web.svg",
        iconHeight: 18,
        height: 52.v,
        text: "Continue with Web",
        textSize: 14,
        textColor: colorSecondary,
        onPressed: () {
          var signupLink =
              _authmanager.configModel.body?.pages?.signup?.url ?? "";
          UiHelper.inAppBrowserView(Uri.parse(signupLink ?? ""));
        });
  }

  Widget loginWithWhatsApp() {
    return CommonMaterialButton(
        borderWidth: 1,
        borderColor: colorSecondary,
        color: white,
        svgIcon: "assets/svg/whatsapp.svg",
        iconHeight: 18,
        height: 52.v,
        text: "Continue with WhatsApp",
        textSize: 14,
        textColor: colorSecondary,
        onPressed: () {
          var signupLink =
              _authmanager.configModel.body?.pages?.signup?.whatsApp ?? "";
          UiHelper.inAppBrowserView(Uri.parse(signupLink ?? ""));
        });
  }

  Widget disclaimerWidget(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: InkWell(
              onTap: () {
                if (controller.isDisclamer.value) {
                  controller.isDisclamer(false);
                } else {
                  controller.isDisclamer(true);
                }
              },
              child: controller.isDisclamer.value
                  ? Icon(
                      Icons.check_box,
                      color: colorSecondary,
                    )
                  : const Icon(Icons.check_box_outline_blank)),
        ),
        const SizedBox(
          width: 6,
        ),
        Expanded(
          flex: 9,
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialogWidget(
                    title: "disclaimer".tr,
                    logo: ImageConstant.logout,
                    description: "disclamer".tr,
                    buttonAction: "okay".tr,
                    buttonCancel: "Cancel",
                    isShowBtnCancel: true,
                    onCancelTap: () {},
                    onActionTap: () async {},
                  );
                },
              );
            },
            child: Text.rich(
              TextSpan(
                text: "disclamerHalf".tr,
                style: const TextStyle(fontSize: 12, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: "read_more".tr,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 12,
                          color: colorSecondary)),
                  // can add more TextSpans here...
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  ///currently its not used
  Widget infoButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomTextView(
          text: "enter_your_detail".tr,
          fontSize: 24,
        ),
        const SizedBox(
          width: 6,
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialogWidget(
                  title: "hygiene_points".tr,
                  logo: ImageConstant.logout,
                  description: "hyginePoints".tr,
                  buttonAction: "okay".tr,
                  buttonCancel: "Cancel",
                  isShowBtnCancel: true,
                  onCancelTap: () {},
                  onActionTap: () async {},
                );
              },
            );
          },
          child: const Icon(Icons.info),
        ),
      ],
    );
  }

// Modify the "scope" below as per your need
/*final _linkedInConfig = LinkedInConfig(
    clientId: '779t0y9f5ktq1i' */ /*"77eyp1qqv75h26"*/ /*,
    clientSecret: 'MBxjONEOyNe0Y346' */ /*"U4DGUjRm5MPMKESv"*/ /*,
    redirectUrl:
        'https://live.dreamcast.in/dc_eventapp_2025' */ /*"https://www.indiamobilecongress.com"*/ /*,
    scope: ['openid', 'profile', 'email'],
  );*/
}
