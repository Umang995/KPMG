import 'package:dreamcast/core/extension/content_extension.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import '../button/custom_icon_button.dart';

class CustomAnimatedDialogWidget extends StatelessWidget {
  final String title, description, buttonCancel, buttonAction, logo;
  final VoidCallback? onCancelTap, onActionTap;
  final bool? isHideCancelBtn;

  const CustomAnimatedDialogWidget(
      {super.key,
      required this.logo,
      required this.title,
      required this.description,
      required this.buttonCancel,
      required this.buttonAction,
      this.isHideCancelBtn,
      this.onCancelTap,
      this.onActionTap});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 19.0, vertical: 31),
        decoration: BoxDecoration(
          color: white,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              logo.isNotEmpty
                  ? logo.contains("http") || logo.contains("https")
                      ? Image.network(logo, height: 100.adaptSize)
                      : logo.contains("json")
                          ? Lottie.asset(logo, width: 100)
                          : logo.contains("svg")
                              ? SvgPicture.asset(logo, height: 100.adaptSize)
                              : Image.asset(logo, height: 76.adaptSize)
                  : const SizedBox(),
              const SizedBox(height: 5.0),
              title.isNotEmpty
                  ? CustomTextView(
                      text: title,
                      textAlign: TextAlign.center,
                      fontSize: 22.0,
                      color: colorSecondary,
                      fontWeight: FontWeight.w600,
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 8,
              ),
              CustomTextView(
                text: description,
                textAlign: TextAlign.center,
                fontSize: 16.0,
                color: colorSecondary,
                maxLines: 100,
                fontWeight: FontWeight.normal,
              ),
              const SizedBox(height: 22.0),
              Row(
                children: [
                  isHideCancelBtn != null
                      ? const SizedBox()
                      : Expanded(
                          flex: 1,
                          child: CustomIconButton(
                            height: 50.v,
                            decoration: BoxDecoration(
                                color: white,
                                border: Border.all(color: colorGray, width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            width: context.width,
                            onTap: () {
                              onCancelTap!();
                              Navigator.of(context).pop();
                            },
                            child: Center(
                              child: CustomTextView(
                                text: buttonCancel,
                                fontSize: 16,
                                maxLines: 1,
                                fontWeight: FontWeight.w500,
                                color: colorSecondary,
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    width: 10.h,
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              isHideCancelBtn ?? false ? 40.adaptSize : 0),
                      child: CustomIconButton(
                        height: 50.v,
                        decoration: BoxDecoration(
                            color: colorPrimary,
                            border: Border.all(color: colorPrimary, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        width: context.width,
                        onTap: () {
                          Navigator.of(context).pop();
                          onActionTap?.call();
                        },
                        child: Center(
                          child: CustomTextView(
                            text: buttonAction,
                            fontSize: 16,
                            maxLines: 1,
                            fontWeight: FontWeight.w500,
                            color: white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
