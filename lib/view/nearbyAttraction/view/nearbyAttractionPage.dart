import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/nearbyAttraction/controller/nearbyAttractionController.dart';
import 'package:dreamcast/view/nearbyAttraction/view/nearbyAttractionWidget.dart';
import 'package:dreamcast/widgets/app_bar/appbar_leading_image.dart';
import 'package:dreamcast/widgets/app_bar/custom_app_bar.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../routes/my_constant.dart';
import '../../../widgets/loading.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../skeletonView/skeleton_event_feed.dart';

class NearbyAttractionPage extends GetView<NearbyAttractionController> {
  static const routeName = "/NearbyAttractionPage";

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final controller = Get.put(NearbyAttractionController());

  NearbyAttractionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          },
        ),
        title: ToolbarTitle(
            title: Get.arguments?[MyConstant.titleKey] ?? "Nearby Attractions"),
      ),
      body: GetX<NearbyAttractionController>(
        builder: (controller) {
          return Stack(
            children: [
              ///********** Nearby Attraction List *************///
              _nearbyAttractionList(),
              _progressEmptyWidget(),
            ],
          );
        },
      ),
    );
  }

  ///********** Nearby Attraction List *************///
  _nearbyAttractionList() {
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          controller.getHubMenuAPi(isRefresh: true);
        },
        child: Skeletonizer(
          enabled: controller.isFirstLoading.value,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16),
            separatorBuilder: (context, index) {
              return const SizedBox(height: 20);
            },
            itemCount: controller.isFirstLoading.value
                ? 5
                : controller.itemList.length,
            itemBuilder: (context, index) {
              if (controller.isFirstLoading.value) {
                return const LoadingEventFeedWidget();
              }
              return NearbyAttractionWidget(
                  itemList: controller.itemList[index]);
            },
          ),
        ));
  }

  Widget _progressEmptyWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      child: controller.loading.value
          ? const Loading()
          : controller.itemList.isEmpty && !controller.isFirstLoading.value
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }
}
