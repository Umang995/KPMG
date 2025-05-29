import 'package:dreamcast/core/extension/content_extension.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../button/custom_icon_button.dart';

class CustomDialogWidget extends StatelessWidget {
  final String title, description, buttonCancel, buttonAction, logo;
  final bool? isShowBtnCancel;
  final VoidCallback? onCancelTap, onActionTap;

  const CustomDialogWidget(
      {super.key,
      required this.logo,
      required this.title,
      required this.description,
      required this.buttonCancel,
      required this.buttonAction,
      this.onCancelTap,
      this.isShowBtnCancel = true,
      this.onActionTap});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: white,
          border: Border.all(color: const Color(0xffDCE2E6)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            logo.isNotEmpty
                ? Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color.fromRGBO(244, 243, 247, 1),
                    ),
                    child: !logo.contains(".svg")
                        ? Image.asset(
                            logo,
                            scale: 3.5,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(/*14.0*/ 6.0),
                            child: SvgPicture.asset(logo),
                          ),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 10,
            ),
            CustomTextView(
              text: title,
              textAlign: TextAlign.center,
              fontSize: 22.0,
              color: colorSecondary,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 6.0),
            CustomTextView(
              text: description,
              textAlign: TextAlign.center,
              fontSize: 16.0,
              color: colorSecondary,
              maxLines: 100,
              fontWeight: FontWeight.normal,
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                isShowBtnCancel == false
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
                              fontWeight: FontWeight.normal,
                              color: colorSecondary,
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  width: isShowBtnCancel == false ? 0 : 10.h,
                ),
                Expanded(
                  flex: 1,
                  child: CustomIconButton(
                    height: 50.v,
                    decoration: BoxDecoration(
                        color: colorPrimary,
                        border: Border.all(color: colorPrimary, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    width: context.width,
                    onTap: () {
                      onActionTap!();
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: CustomTextView(
                        text: buttonAction,
                        fontSize: 16,
                        maxLines: 1,
                        fontWeight: FontWeight.normal,
                        color: white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
