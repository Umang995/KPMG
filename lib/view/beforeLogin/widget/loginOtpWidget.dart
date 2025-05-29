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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../widgets/already_have_an_account_acheck.dart';
import '../../../widgets/or_divider.dart';

class LoginOTPWidget extends GetView<LoginController> {
  bool isGuestForm;
  LoginOTPWidget({super.key, required this.isGuestForm});

  @override
  Widget build(BuildContext context) {
    return GetX<LoginController>(
      builder: (controller) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Pinput(
              length: 6,
              defaultPinTheme: controller.defaultPinTheme,
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              pinAnimationType: PinAnimationType.fade,
              animationCurve: Curves.linear,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly, // Only allows numbers
              ],
              onCompleted: (pin) {
                controller.otpCode = pin;
              },
              onChanged: (value) {
                if (value.length < 5) {
                  controller.otpCode = "";
                }
              },
              cursor: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: 2,
                      height: 23,
                      color: borderColor,
                    ),
                  ),
                ],
              ),
              focusedPinTheme: controller.defaultPinTheme.copyWith(
                decoration: controller.defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: colorSecondary),
                ),
              ),
              submittedPinTheme: controller.defaultPinTheme.copyWith(
                decoration: controller.defaultPinTheme.decoration!.copyWith(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: colorSecondary),
                ),
              ),
              errorPinTheme: controller.defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: !controller.isTimerIsRunning.value
                  ? GestureDetector(
                      onTap: () {
                        controller.shareVerificationCode(
                            controller.emailCtr.text.trim(), context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 6),
                        child: CustomTextView(
                          text: "resend_otp".tr,
                          underline: true,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w500,
                          color: colorPrimary,
                          fontSize: 15,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                          top: 12, bottom: 6, left: 12, right: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextView(
                            text: "resend_otp_in".tr,
                            fontSize: 15,
                            color: colorGray,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          SizedBox(
                            width: 60.adaptSize,
                            child: CustomTextView(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: colorGray,
                                text:
                                    '${UiHelper.formatCountdown(controller.tickCount.value)} Sec'),
                          )
                        ],
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
