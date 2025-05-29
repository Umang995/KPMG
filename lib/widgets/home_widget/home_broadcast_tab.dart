/*
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../utils/image_constant.dart';
import 'package:flutter/material.dart';

import '../customTextView.dart';
class HomeBroadcastTab extends StatelessWidget {
  const HomeBroadcastTab({super.key});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return index == 0
              ? notificationView("imc_event_live_go_time".tr,
              ImageConstant.temp_alert_img1, context)
              : notificationView("hurry_up_register_open".tr,
              ImageConstant.temp_alert_img2, context);
        },
        itemCount: 2,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 5 / 7.2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 24),
      ),
    );
  }

  Widget notificationView(title, image, BuildContext context) {
    return Container(
      width: context.width,
      height: context.height,
      decoration: const BoxDecoration(
          color: colorSecondary,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            image,
          ),
          //SizedBox(height: 19.adaptSize,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.v, horizontal: 12.5.h),
            child: Center(
              child: AutoCustomTextView(
                  text: title,
                  fontWeight: FontWeight.w600,
                  maxLines: 3,
                  color: white,
                  fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

}
*/
