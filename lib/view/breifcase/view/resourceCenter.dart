import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/resource_center_widget.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../skeletonView/resource_center_skeleton.dart';
import '../controller/common_document_controller.dart';

class ResourceCenterListPage extends GetView<CommonDocumentController> {
  static const routeName = "/ResourceListPage";
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        height: 72.v,
        leadingWidth: 45.h,
        leading: AppbarLeadingImage(
          imagePath: ImageConstant.imgArrowLeft,
          margin: EdgeInsets.only(left: 7.h, top: 3),
          onTap: () => Get.back(),
        ),
        title: ToolbarTitle(
            title: Get.arguments?[MyConstant.titleKey] ?? "resource_center".tr),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: GetX<CommonDocumentController>(builder: (controller) {
          return Stack(
            children: [
              RefreshIndicator(
                key: _refreshIndicatorKey,
                color: colorLightGray,
                backgroundColor: colorPrimary,
                strokeWidth: 1.0,
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                onRefresh: () async {
                  await controller.getDocumentList(
                      isRefresh: true, limitedMode: false);
                },
                child: Skeletonizer(
                  enabled: controller.isFirstLoadRunning.value,
                  child: controller.isFirstLoadRunning.value
                      ? ResourceCenterSkeleton(
                          isFromHome: true,
                        )
                      : const ResourceCenterWidget(
                          isFromHome: false,
                        ),
                ),
              ),
              _progressEmptyWidget(),
            ],
          );
        }),
      ),
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.loading.value
          ? const Loading()
          : !controller.isFirstLoadRunning.value &&
                  controller.resourceCenterList.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }
}
