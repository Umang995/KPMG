import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/widgets/button/common_material_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../theme/app_colors.dart';
import 'textview/customTextView.dart';

class CameraPermissionScreen extends StatelessWidget {
  String content;
  String title;
  String? heading;
  CameraPermissionScreen(
      {super.key,
      required this.content,
      required this.title,
      this.heading
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: white,
      child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
        height: 103,
        width: 103,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: const Color.fromRGBO(244, 243, 247, 1),
          ),
          child: Image.asset(ImageConstant.cameraSettings, scale: 3.5,),
        ),
        const SizedBox(
          height: 25,
        ),
        CustomTextView(
            text: heading ?? "",
            color: Colors.black, // Adjust text color if needed
            fontSize: 21,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w600),
        // const Icon(
        //   Icons.camera_front,
        //   size: 100,
        // ),
        const SizedBox(
          height: 12,
        ),
        CustomTextView(
            text: content,
            color: const Color.fromRGBO(51, 51, 51, 1), // Adjust text color if needed
            fontSize: 16,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w500),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 90),
          child: CommonMaterialButton(
            text: "goto_settings".tr,
            height: 53,
            textSize: 16,
            color: colorPrimary,
            onPressed: () async {
              var opened = await openAppSettings();
              print("Opened $opened");
              if (opened) {
                print("Opened app settings.");
              } else {
                print("Could not open app settings.");
              }
            },
            weight: FontWeight.w500, // Medium font weight
          ),
        )
      ],
              ),
            ),
    );
  }
}
