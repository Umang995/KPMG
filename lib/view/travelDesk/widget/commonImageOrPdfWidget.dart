import 'package:dreamcast/core/extension/content_extension.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/travelDesk/controller/travelDeskController.dart';
import 'package:dreamcast/widgets/fullscreen_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../widgets/textview/customTextView.dart';

class CommonImageOrPdfWidget extends GetView<TravelDeskController> {
  final String fileUrl;
  final String title;

  CommonImageOrPdfWidget({
    Key? key,
    required this.fileUrl,
    required this.title,
  }) : super(key: key);

  final TravelDeskController travelDeskController = Get.find();

  @override
  Widget build(BuildContext context) {
    String fileName = fileUrl.split('/').last;
    String fileExtension = fileName.split('.').last.toLowerCase();

    bool isImage =
        ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(fileExtension);
    String showFileValue = fileName.length >= 15
        ? fileName.substring(fileName.length - 15)
        : fileName;

    return Container(
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                isImage
                    ? SvgPicture.asset(ImageConstant.image_icon)
                    : SvgPicture.asset(ImageConstant.pdf),
                SizedBox(width: 8.h),
                CustomTextView(
                  text: title,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorSecondary,
                  maxLines: 1,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: isImage
                      ? () {
                          Get.to(() => FullImageView(
                                imgUrl: fileUrl ?? "",
                                showDownload: true,
                                showNotification: true,
                              ));
                        }
                      : () {
                          travelDeskController.viewPdf(
                              fileName: title ?? "",
                              networkPath: fileUrl ?? "");
                        },
                  child: SvgPicture.asset(ImageConstant.showPdf),
                ),
                SizedBox(width: 12.h),
                Obx(() => InkWell(
                      onTap: () {
                        travelDeskController.pdfDownload(
                            fileName: title.replaceAll(" ", "-") ?? "",
                            networkPath: fileUrl ?? "");
                      },
                      child: controller.downloadProgress.value > 0 &&
                              controller.downloadProgress.value < 1 &&
                              (fileUrl ==
                                  travelDeskController.showFileLoader.value)
                          ? SizedBox(
                              height: 30,
                              width: 30,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: controller.downloadProgress.value,
                                    strokeWidth: 3,
                                    backgroundColor: Colors.grey.shade300,
                                  ),
                                  CustomTextView(
                                    text:
                                        "${(controller.downloadProgress.value * 100).toStringAsFixed(0)}%",
                                    fontSize: 13.fSize,
                                  ),
                                ],
                              ),
                            )
                          : SvgPicture.asset(ImageConstant.downloadpdf),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
