import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/button/common_material_button.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/view/photobooth/controller/photobooth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../routes/my_constant.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/button/custom_icon_button.dart';
import '../../../widgets/fullscreen_image.dart';
import '../../../widgets/loadMoreItem.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../skeletonView/photobooth_list_skeleton.dart';
import '../model/photoListModel.dart';

class AIPhotoSeachPage extends GetView<PhotoBoothController> {
  AIPhotoSeachPage({Key? key}) : super(key: key);
  static const routeName = "/photoBoothPage";
  PhotoBoothController photoboothController = Get.put(PhotoBoothController());

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (value) {
        photoboothController.onClearData();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          height: 72.v,
          leadingWidth: 45.h,
          leading: AppbarLeadingImage(
            imagePath: ImageConstant.imgArrowLeft,
            margin: EdgeInsets.only(
              left: 7.h,
              top: 3,
              // bottom: 12.v,
            ),
            onTap: () {
              Get.back();
              photoboothController.onClearData();
            },
          ),
          title: ToolbarTitle(
              title: Get.arguments?[MyConstant.titleKey] ?? "ai_gallery".tr),
        ),
        body: GetX<PhotoBoothController>(builder: (controller) {
          return Container(
            padding: const EdgeInsets.all(12),
            child: Stack(
              children: [
                controller.photoList.isEmpty
                    ? _progressEmptyWidget()
                    : const SizedBox(),
                Column(
                  children: [
                    Skeletonizer(
                      enabled: controller.isFirstLoadRunning.value,
                      child: Obx(() => !photoboothController
                              .isSelectionMode.value
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomTextView(
                                    text:
                                        "${"photos".tr} (${controller.totalPhotos.value.toString()})" /*"Total ${controller.totalPhotos.value.toString()} Photos"*/,
                                    color: colorGray,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22),
                                TextButton(
                                    onPressed: () async {
                                      if (controller.isMyPhotos.value) {
                                        await controller.getAllPhotos(
                                            body: {"page": 1},
                                            isRefresh: false);
                                      } else {
                                        controller.showPicker(context, false);
                                      }
                                    },
                                    child: CustomTextView(
                                      text: controller.isMyPhotos.value
                                          ? "all_photos".tr
                                          : "upload_photo".tr,
                                      color: colorPrimary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ))
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                  CustomTextView(
                                      text:
                                          "${"selected_photos".tr} (${photoboothController.isSelectedImagesList.length})",
                                      color: gray,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600),
                                  if (photoboothController
                                      .isSelectionMode.value)
                                    InkWell(
                                      onTap: () {
                                        photoboothController.onClearData();
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: SvgPicture.asset(
                                          ImageConstant.closeIcon,
                                          height: 29.v,
                                          width: 29.v,
                                        ),
                                      ),
                                    )
                                ])),
                    ),
                    SizedBox(
                      height: 19.v,
                    ),
                    Expanded(
                        child: RefreshIndicator(
                      color: colorLightGray,
                      backgroundColor: colorPrimary,
                      strokeWidth: 1.0,
                      key: _refreshIndicatorKey,
                      onRefresh: () {
                        return Future.delayed(
                          const Duration(seconds: 1),
                          () async {
                            await controller.getAllPhotos(
                                body: {"page": 1}, isRefresh: true);
                          },
                        );
                      },
                      child: loadListView(),
                    )),
                    // when the _loadMore function is running
                    // controller.isLoadMoreRunning.value
                    //     ? const LoadMoreLoading()
                    //     : const SizedBox(),
                    const SizedBox(
                      height: 12,
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        controller.isLoadMoreRunning.value
                            ? const LoadMoreLoading()
                            : const SizedBox(),
                        controller.isSelectedImagesList.isNotEmpty
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  color: white,
                                  height: 95.v,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Stack(
                                        children: [
                                          CustomTextView(
                                            text: "downlaod_limit".tr,
                                            color: gray,
                                            fontSize: 14,
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: CommonMaterialButton(
                                          color: colorPrimary,
                                          iconHeight: 19,
                                          svgIcon: ImageConstant.photoDownload,
                                          height: 55,
                                          text: "Download",
                                          textSize: 18,
                                          onPressed: () {
                                            controller.downloadSelectedImages(
                                                context);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : controller.isAiSearchVisible.value &&
                                    controller.photoList.isNotEmpty
                                ? Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 0),
                                      child: CustomIconButton(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(ImageConstant
                                                    .ai_photo_search))),
                                        height: 50,
                                        width: context.width,
                                        onTap: () {
                                          controller.searchFromCamera();
                                        },
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                      ]),
                ),
                controller.loadImagesLoader.value
                    ? const Loading()
                    : const SizedBox()
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.loading.value
          ? const Loading()
          : !controller.isFirstLoadRunning.value && controller.photoList.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  ///main list view
  loadListView() {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Skeletonizer(
          enabled: controller.isFirstLoadRunning.value,
          child: controller.isFirstLoadRunning.value
              ? const PhotoListSkeleton()
              : Obx(() => GridView.builder(
                    //reverse: false,
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: controller.scrollController,
                    itemCount: controller.photoList.length,
                    itemBuilder: (context, index) {
                      String data = controller.photoList[index];
                      return Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onLongPress: () =>
                                  controller.onImageLongPress(index, data),
                              onTap: () =>
                                  controller.onImageTap(index, data, context),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: context.height,
                                    width: context.width,
                                    child: UiHelper.getPhotoBoothImage(
                                        imageUrl: data ?? ""),
                                  ),
                                  if (controller.isSelectionMode.value)
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.4),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: SvgPicture.asset(
                                          controller.isSelected[index]
                                              ? ImageConstant.select
                                              : ImageConstant.unselect,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 1,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16),
                  ))),
    );
  }
}
