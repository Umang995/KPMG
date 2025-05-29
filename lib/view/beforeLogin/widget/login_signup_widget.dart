import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/Validations.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/beforeLogin/login/login_controller.dart';
import 'package:dreamcast/view/beforeLogin/widget/loginOtpWidget.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pinput/pinput.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:signin_with_linkedin/signin_with_linkedin.dart';
import '../../../api_repository/app_url.dart';
import '../../../widgets/dialog/custom_dialog_widget.dart';
import '../../../widgets/input_form_field.dart';
import '../../../widgets/button/common_material_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/already_have_an_account_acheck.dart';
import '../../../widgets/or_divider.dart';
import 'loginEmailFieldWidget.dart';

class LoginSignupWidget extends GetView<LoginController> {
  bool isGuestForm;
  LoginSignupWidget({super.key, required this.isGuestForm});

  final AuthenticationManager _authmanager = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey();
  final LoginController _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetX<LoginController>(
      builder: (controller) {
        return Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Container(
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
            padding:
                const EdgeInsets.only(top: 42, bottom: 30, left: 25, right: 25),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
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
                            _viewModel.signupform.value = false;
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
                      ]),
                  controller.isLoading.value
                      ? const Loading()
                      : const SizedBox()
                ],
              ),
            ),
          ),
        );
      },
    );
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
}
