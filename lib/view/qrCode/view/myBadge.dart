import 'dart:io';
import 'dart:typed_data';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/home/screen/pdfViewer.dart';
import 'package:dreamcast/view/qrCode/controller/qr_page_controller.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../theme/ui_helper.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/customImageWidget.dart';
import '../../../widgets/fullscreen_image.dart';
import '../../../widgets/loading.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';

class MyBadgePage extends GetView<QrPageController> {
  MyBadgePage({Key? key}) : super(key: key);
  var dataLoaded = true.obs;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final AuthenticationManager authManager = Get.find();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SizedBox(
          width: context.width,
          height: context.height,
          child: GetX<QrPageController>(builder: (controller) {
            return SizedBox(
              width: context.width,
              height: context.height,
              child: Stack(
                children: [
                  false
                      ? createBadge(context)
                      : controller.localQrCodePath.isNotEmpty &&
                              controller.localQrCodePath.contains(".pdf")
                          ? showPdf()
                          : showBadge(context),
                  controller.localQrCodePath.value.isEmpty &&
                          controller.loading.value
                      ? const Loading()
                      : const SizedBox()
                ],
              ),
            );
          }),
        ));
  }

  //show the badge as image and download the badge also
  showBadge(BuildContext context) {
    return controller.localQrCodePath.value.isNotEmpty
        ? GestureDetector(
            onTap: () => Get.to(FullImageView(
                isLocalUrl: true, imgUrl: controller.localQrCodePath.value)),
            child: FutureBuilder<Uint8List>(
              future: File(controller.localQrCodePath.value)
                  .readAsBytes(), // ❌ NO `await` here
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Container(
                      width: context.width,
                      height: context.height,
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.all(6),
                      color: Colors.transparent,
                      child: Image.memory(snapshot.data!));
                } else {
                  return const CircularProgressIndicator(); // Show loader while loading
                }
              },
            ))
        : const Loading();
  }

  //used for show the badge as PDF view and download the PDF also
  showPdf() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SfPdfViewer.file(
          File(controller.localQrCodePath.value),
          key: _pdfViewerKey,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: GestureDetector(
            onTap: () {
              if (controller.qrBadge.value.isNotEmpty) {
                Get.to(PdfViewPage(
                    htmlPath: controller.qrBadge.value, title: "Badge"));
              }
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.download_for_offline_rounded,
                size: 45,
                color: colorSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //used to create the custom badge using pre-defined info
  createBadge(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          Container(
            width: context.width,
            height: context.height,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: white, borderRadius: BorderRadius.circular(12)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20.adaptSize),
                  CustomImageWidget(
                    imageUrl: PrefUtils.getImage() ?? "",
                    shortName: PrefUtils.getUsername() ?? "",
                    size: 100.adaptSize,
                    borderWidth: 0,
                  ),
                  const SizedBox(height: 6.0),
                  CustomTextView(
                    text: PrefUtils.getName() ?? "",
                    fontSize: 22,
                    maxLines: 2,
                    fontWeight: FontWeight.w600,
                    color: colorSecondary,
                  ),
                  SizedBox(height: 5.0.adaptSize),
                  if (PrefUtils.getCategory()?.isNotEmpty ?? false)
                    CustomTextView(
                      text: PrefUtils.getCategory() ?? "",
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: colorGray,
                    ),
                  SizedBox(height: 24.0.adaptSize),
                  controller.badgeMessage.value.isNotEmpty
                      ? Card(
                          elevation: 5,
                          color: white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: QrImageView(
                              data: controller.qrBadge.value ??
                                  "", // Replace with your data
                              version: QrVersions.auto,
                              size: 170.0.adaptSize,
                            ),
                          ),
                        )
                      : CustomTextView(
                          text: controller.badgeMessage.value ?? "",
                          color: colorPrimary,
                          maxLines: 3,
                          fontSize: 14,
                          textAlign: TextAlign.center,
                        ),
                  SizedBox(
                    height: 26.adaptSize,
                  ),
                  GestureDetector(
                    onTap: () {
                      Share.share(UiHelper.removeHtmlTags(
                          controller.qrBadge.value ?? ""));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 23),
                      decoration: BoxDecoration(
                          color: white,
                          border: Border.all(color: colorSecondary, width: 1),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(18),
                          )),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            "assets/svg/share_icon.svg",
                            color: colorSecondary,
                          ),
                          SizedBox(
                            width: 13.h,
                          ),
                          CustomTextView(
                            text: "Share QR",
                            color: colorSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          bottom: 23.adaptSize, top: 84.adaptSize),
                      padding: EdgeInsets.all(23.adaptSize),
                      decoration: BoxDecoration(
                          color: colorLightGray,
                          border:
                              Border.all(color: Colors.transparent, width: 1),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomTextView(
                                text: "Share my profile",
                                textAlign: TextAlign.start,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              SvgPicture.asset(
                                  "assets/svg/ic_toggle_button.svg")
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: CustomTextView(
                              textAlign: TextAlign.start,
                              text:
                                  "Your complete profile will be shared with all your friends!",
                              maxLines: 2,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
          controller.loading.value ? const Loading() : const SizedBox()
        ],
      ),
    );
  }
}
/*
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/home/screen/pdfViewer.dart';
import 'package:dreamcast/view/qrCode/controller/qr_page_controller.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../widgets/fullscreen_image.dart';
import '../../../widgets/loading.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';

class MyBadgePage extends GetView<QrPageController> {
  MyBadgePage({Key? key}) : super(key: key);
  var dataLoaded = true.obs;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final AuthenticationManager authManager = Get.find();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: white,
      width: context.width,
      height: context.height,
      child: GetX<QrPageController>(builder: (controller) {
        return SizedBox(
          width: context.width,
          height: context.height,
          child: Stack(
            children: [
              false
                  ? createBadge(context)
                  : controller.qrBadge.isNotEmpty &&
                          controller.qrBadge.contains(".pdf")
                      ? showPdf()
                      : showBadge(context),
              controller.qrBadge.value.isEmpty && controller.loading.value
                  ? const Loading()
                  : const SizedBox()
            ],
          ),
        );
      }),
    ));
  }

  //show the badge as image and download the badge also
  showBadge(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(FullImageView(imgUrl: controller.qrBadge.value)),
      child: Container(
        width: context.width,
        height: context.height,
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(6),
        color: Colors.transparent,
        child: CachedNetworkImage(
          imageUrl: controller.qrBadge.value,
          imageBuilder: (context, imageProvider) => Container(
            height: context.height * 0.65,
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
            ),
          ),
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => controller.loading.value
              ? const SizedBox()
              : Text(controller.badgeMessage.value ?? ""),
        ),
      ),
    );
  }

  //used for show the badge as PDF view and download the PDF also
  showPdf() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SfPdfViewer.network(
          controller.qrBadge.value,
          key: _pdfViewerKey,
        ),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () => Get.to(PdfViewPage(
                htmlPath: controller.qrBadge.value, title: "Badge")),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.download_for_offline_rounded,
                size: 45,
                color: colorSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //used to create the custom badge using pre-defined info
  createBadge(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          Container(
            width: context.width,
            height: context.height,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: white, borderRadius: BorderRadius.circular(12)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 50.adaptSize),
                  SizedBox(
                    height: 71.adaptSize,
                    child: CachedNetworkImage(
                      imageUrl: authManager.getImage() ?? "",
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.contain),
                        ),
                      ),
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          Image.asset("assets/icons/logo.png"),
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  CustomTextView(
                    text: authManager.getName() ?? "",
                    fontSize: 22,
                    maxLines: 2,
                    fontWeight: FontWeight.w600,
                    color: colorSecondary,
                  ),
                  SizedBox(height: 5.0.adaptSize),
                  CustomTextView(
                    text: authManager.getCategory() ?? "",
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: colorGray,
                  ),
                  SizedBox(height: 24.0.adaptSize),
                  controller.badgeMessage.value.isNotEmpty
                      ? Card(
                          elevation: 5,
                          color: white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: QrImageView(
                              data: controller.qrBadge.value ??
                                  "", // Replace with your data
                              version: QrVersions.auto,
                              size: 170.0.adaptSize,
                            ),
                          ),
                        )
                      : CustomTextView(
                          text: controller.badgeMessage.value ?? "",
                          color: white,
                          maxLines: 3,
                          fontSize: 14,
                          textAlign: TextAlign.center,
                        ),
                  SizedBox(
                    height: 26.adaptSize,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 23),
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(color: colorSecondary, width: 1),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(18),
                        )),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "assets/svg/share_icon.svg",
                          color: colorSecondary,
                        ),
                        SizedBox(
                          width: 13.h,
                        ),
                        const CustomTextView(
                          text: "Share QR",
                          color: colorSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        )
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          bottom: 23.adaptSize, top: 84.adaptSize),
                      padding: EdgeInsets.all(23.adaptSize),
                      decoration: BoxDecoration(
                          color: colorLightGray,
                          border:
                              Border.all(color: Colors.transparent, width: 1),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomTextView(
                                text: "Share my profile",
                                textAlign: TextAlign.start,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              SvgPicture.asset(
                                  "assets/svg/ic_toggle_button.svg")
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: CustomTextView(
                              textAlign: TextAlign.start,
                              text:
                                  "Your complete profile will be shared with all your friends!",
                              maxLines: 2,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
          controller.loading.value ? const Loading() : const SizedBox()
        ],
      ),
    );
  }
}
*/
