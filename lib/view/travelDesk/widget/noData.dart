import 'package:dreamcast/api_repository/app_url.dart';
import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/travelDesk/controller/flightController.dart';
import 'package:dreamcast/view/travelDesk/controller/travelSaveFormController.dart';
import 'package:dreamcast/view/travelDesk/view/travelSaveFormPage.dart';
import 'package:dreamcast/widgets/button/common_material_button.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NoData extends StatelessWidget {
  final heading, image, title, description, slug, isAddButton, buttonTitle;

  NoData(
      {super.key,
      this.heading,
      this.title,
      this.description,
      this.image,
      this.slug,
      this.isAddButton,
        this.buttonTitle
      });

  FlightController flightController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: heading !="" ? colorLightGray : white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
           if(heading !="") Padding(
              padding: const EdgeInsets.only(left: 25, top: 16, bottom: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomTextView(
                  text: heading ?? "",
                  fontSize: 18,
                  maxLines: 10,
                  color: colorPrimary,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if(heading !="")  UiHelper.commonDivider(),
            Padding(
              padding: EdgeInsets.only(top: 52.v, left: 24.h, right: 24.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(image),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomTextView(
                    text: title,
                    color: colorSecondary,
                    fontSize: 20,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextView(
                    text: description,
                    color: colorSecondary,
                    fontSize: 16,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(
                    height: 33.v,
                  ),
                ],
              ),
            ),
            if (isAddButton)
              Padding(
                padding: EdgeInsets.only(bottom: 32.v, left: 33.h, right: 33.h),
                child: CommonMaterialButton(
                    text: buttonTitle ?? "Add Details",
                    color: colorPrimary,
                    onPressed: () {
                      Get.toNamed(TravelSaveFormPage.routeName, arguments: {
                        "type": slug,
                      });
                    }),
              )
          ],
        ));
  }
}
