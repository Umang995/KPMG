import 'package:dreamcast/core/extension/content_extension.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
import '../utils/dialog_constant.dart';
import '../utils/image_constant.dart';
import '../utils/pref_utils.dart';
import 'button/custom_icon_button.dart';
import 'textview/customTextView.dart';

class AICustomButton extends StatelessWidget {
  AICustomButton({super.key, required this.onTap, required this.title});
  final VoidCallback? onTap;
  String title;
  @override
  Widget build(BuildContext context) {
    return PrefUtils.getAiFeatures()
        ? GestureDetector(
            onTap: () async {
              onTap?.call();
            },
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: outerRingColor, width: 1)),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: innerRingColor, width: 1)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    gradient: LinearGradient(
                      colors: [gradientBegin, gradientEnd],
                    ),
                  ),
                  height: 44.v,
                  // width: context.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          ImageConstant.ai_star,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        CustomTextView(
                          text: title,
                          color: Theme.of(context).highlightColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}

class AIMatchButton extends StatelessWidget {
  AIMatchButton({super.key, required this.onTap, required this.title});
  final VoidCallback? onTap;
  String title;

  final AuthenticationManager manager = Get.find<AuthenticationManager>();
  @override
  Widget build(BuildContext context) {
    return PrefUtils.getAiFeatures()
        ? GestureDetector(
            onTap: () async {
              if (!manager.isLogin()) {
                DialogConstantHelper.showLoginDialog(Get.context!, manager);
                return;
              }
              onTap?.call();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                gradient: LinearGradient(
                  colors: [gradientBegin, gradientEnd],
                ),
              ),
              // width: context.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      ImageConstant.ai_star,
                      height: 12,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    CustomTextView(
                      text: "aimatches".tr,
                      color: white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
