
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/photobooth/controller/photobooth_controller.dart';
import 'package:dreamcast/view/photobooth/controller/showOverlayDownloadController.dart';
import 'package:dreamcast/view/photobooth/view/showOverlayDownloadWidget.dart';
import 'package:dreamcast/widgets/app_bar/appbar_leading_image.dart';
import 'package:dreamcast/widgets/app_bar/custom_app_bar.dart';
import 'package:dreamcast/widgets/dialog/custom_animated_dialog_widget.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/route_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:io';

class MultiImageDownloader extends GetView<PhotoBoothController> {
  MultiImageDownloader({Key? key}) : super(key: key);
  static const routeName = "/multiImageUploader";

  PhotoBoothController controller = Get.find();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 72.v,
        leadingWidth: 45.h,
        leading: AppbarLeadingImage(
          imagePath: ImageConstant.imgArrowLeft,
          margin: EdgeInsets.only(left: 7.h, top: 3),
          onTap: () {
            Get.back();
          },
        ),
        title: const ToolbarTitle(title: "Downloads"),
      ),

      body: GetX<PhotoBoothController>(
        builder: (controller){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomTextView(
                  text: "Total Photos (${controller.activeDownloadUrls
                      .length})",
                  color: colorSecondary,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.activeDownloadUrls.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: lightGray,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Obx(()=> ListTile(
                            onTap: () {},
                            title: CustomTextView(
                              text: controller.activeDownloadUrls[index]
                                  .length > 20
                                  ? controller.activeDownloadUrls[index]
                                  .substring(
                                  controller.activeDownloadUrls[index].length -
                                      20)
                                  : controller.activeDownloadUrls[index],
                              color: colorSecondary,
                              fontSize: 18,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 7.v),
                                LinearProgressIndicator(
                                  backgroundColor: defaultCheckboxColor,
                                  borderRadius: BorderRadius.circular(10),
                                  value: controller.progress[index],
                                  color: controller.progress[index] * 100 == 100
                                      ? Colors.green
                                      : colorInvitationSent,
                                ),
                                SizedBox(height: 3.v),
                                Row(
                                  children: [
                                    controller.progress[index] * 100 == 100
                                        ? const SizedBox()
                                        : CustomTextView(
                                      text: "${(controller.progress[index] *
                                          100).toStringAsFixed(0)}%",
                                    ),
                                    controller.progress[index] * 100 == 100
                                        ? Row(
                                      children: [
                                        Image.asset(
                                          ImageConstant.check,
                                          width: 14.h,
                                          height: 14.v,
                                        ),
                                        const SizedBox(width: 5),
                                        CustomTextView(text: "Downloaded", color: gray, fontSize: 14),
                                      ],
                                    )
                                        : const CustomTextView(
                                        text: " Downloading... / "),
                                    controller.imageSizes[index] != null
                                        ? controller.progress[index] * 100 ==
                                        100
                                        ? const SizedBox()
                                        : CustomTextView(
                                      text: "${controller.imageSizes[index]!
                                          .toStringAsFixed(2)} MB",
                                      fontSize: 14,
                                      color: colorPrimary,
                                    )
                                        : const SizedBox(),
                                  ],
                                ),
                              ],
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                controller.activeDownloadUrls[index],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                const Icon(Icons.error),
                                loadingBuilder: (_, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Icon(
                                    Icons.image,
                                    size: 50,
                                    color: colorDisabled,
                                  );
                                },
                              ),
                            ),
                          ),),
                         // Obx(() =>  controller.progress[index] * 100 == 100
                         //     ? const SizedBox()
                         //     : Padding(
                         //   padding: const EdgeInsets.only(right: 5.0),
                         //   child: InkWell(
                         //     onTap: () {
                         //       controller.removeImage(index);
                         //     },
                         //     child: Icon(
                         //         Icons.highlight_remove, color: colorSecondary,
                         //         size: 25),
                         //   ),
                         // ),)
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }

}

