
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import '../../widgets/customImageWidget.dart';
import '../../widgets/textview/customTextView.dart';
class LoadingEventFeedWidget extends StatelessWidget {
  const LoadingEventFeedWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: context.width,
        margin: EdgeInsets.symmetric(
            horizontal: false ? 0 : 18.adaptSize, vertical: false ? 0 : 6),
        padding: EdgeInsets.symmetric(horizontal: 18.adaptSize, vertical: 15),
        decoration: BoxDecoration(
          color: colorLightGray,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CustomImageWidget(size: 45, imageUrl: "", shortName: ""),
                SizedBox(
                  width: 7.v,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextView(
                      text: "Aditi Singh",
                      color: colorSecondary,
                      maxLines: 3,
                      fontSize: 16.fSize,
                    ),
                    SizedBox(
                      width: 3.v,
                    ),
                    CustomTextView(
                      text: "20 Oct 2023 | 10:00 AM",
                      color: colorGray,
                      maxLines: 3,
                      fontSize: 14,
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 15.v,
            ),
             CustomTextView(
                text: "just_clicked_this_picture".tr,
                color: colorSecondary,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.start,
                maxLines: 10,
                fontSize: 14),
            const SizedBox(
              height: 184,
            ),
            SizedBox(
              height: 15.v,
            ),
            SizedBox(
              height: 12.v,
            ),
            SizedBox(
              height: 6.v,
            ),
            SizedBox(
              height: 12.v,
            ),
          ],
        ));
  }
}
