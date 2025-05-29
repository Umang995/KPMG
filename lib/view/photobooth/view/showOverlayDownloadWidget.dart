import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/view/photobooth/controller/showOverlayDownloadController.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadOverlay extends StatelessWidget {
  final controller = Get.find<DownloadOverlayController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isVisible.value
        ? Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisSize: MainAxisSize.min, // This ensures the container width is determined by the row's content
                children: [
                  // CustomTextView(
                  //   text: "downloading".tr,
                  //   color: colorSecondary,
                  //   fontSize: 14,
                  //   fontWeight: FontWeight.bold,
                  // ), // Small gap between text and the image
                  Image.asset(ImageConstant.downloadGif, height: 30),
                ],
              ),
            ),
          )
    )
        : const SizedBox());
  }
}
