import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/view/representatives/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_decoration.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/az_listview/src/az_listview.dart';
import '../../../widgets/az_listview/src/index_bar.dart';
import '../../../widgets/custom_search_view.dart';
import '../../../widgets/loadMoreItem.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../../widgets/userListBody.dart';
import '../../skeletonView/userBodySkeleton.dart';
import '../controller/featureNetworkingController.dart';

class FeatureNetworkingPage extends GetView<FeatureNetworkingController> {
  FeatureNetworkingPage({super.key});
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  static const routeName = "/featureNetworkingPage";
  String role = MyConstant.attendee;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: ToolbarTitle(title: "featured_attendees".tr),
      ),
      body: silverBodyWidget(context),
    );
  }

  Widget silverBodyWidget(BuildContext context) {
    return GetX<FeatureNetworkingController>(builder: (controller) {
      return Container(
        color: white,
        width: context.width,
        padding: AppDecoration.userParentPadding(),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSearchSection(),
                SizedBox(height: 22.v),
                Expanded(
                    child: RefreshIndicator(
                  backgroundColor: colorSecondary,
                  key: _refreshIndicatorKey,
                  onRefresh: () {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        onRefreshFun();
                      },
                    );
                  },
                  child: azListViewWidget(context),
                )),
                // when the _loadMore function is running
                controller.isLoadMoreRunning.value
                    ? const LoadMoreLoading()
                    : const SizedBox()
              ],
            ),
            _progressEmptyWidget()
          ],
        ),
      );
    });
  }

  onRefreshFun() {
    controller.getAttendeeList(requestBody: {
      "page": "1",
      "role": role,
      "filters": {
        "text": "",
        "is_blocked": false,
        "notes": false,
        "sort": "ASC",
        "params": {"featured": true}
      },
    }, isRefresh: false);
  }

  Widget _progressEmptyWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 100),
      child: controller.isLoading.value
          ? const Loading()
          : controller.attendeeList.isEmpty && !controller.isFirstLoading.value
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  //this is common listview
  Widget buildListView(BuildContext context) {
    return Skeletonizer(
      enabled: controller.isFirstLoading.value,
      child: controller.isFirstLoading.value
          ? const UserListSkeleton()
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: controller.scrollControllerAttendee,
              itemCount: controller.attendeeList.length,
              itemBuilder: (context, index) =>
                  buildChildMenuBody(controller.attendeeList[index]),
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 30.v,
                  color: borderColor,
                );
              },
            ),
    );
  }

  //this is az listiview item
  Widget azListViewWidget(BuildContext context) {
    return Skeletonizer(
      enabled: controller.isFirstLoading.value,
      child: controller.isFirstLoading.value
          ? const UserListSkeleton()
          : AzListView(
              itemScrollController: controller.itemScrollController,
              data: controller.attendeeList,
              itemCount: controller.attendeeList.length,
              itemBuilder: (BuildContext context, int index) {
                var model = controller.attendeeList[index];
                return buildChildMenuBody(model);
              },
              physics: const AlwaysScrollableScrollPhysics(),
              itemPositionsListener: controller.itemPositionsListener,
              indexBarData: const [...kIndexBarData],
              indexBarOptions: IndexBarOptions(
                needRebuild: true,
                ignoreDragCancel: true,
                textStyle: const TextStyle(color: Colors.blue),
                downTextStyle:
                    const TextStyle(fontSize: 12, color: Colors.white),
                downItemDecoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.green),
                indexHintWidth: 120 / 2,
                indexHintHeight: 100 / 2,
                indexHintDecoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImageConstant.ic_index_bar_bubble_gray),
                    fit: BoxFit.contain,
                  ),
                ),
                indexHintAlignment: Alignment.centerRight,
                indexHintChildAlignment: const Alignment(-0.25, 0.0),
                indexHintOffset: const Offset(-20, 0),
              ),
              onIndexTap: (result) {
                int itemIndex = controller.attendeeList.indexWhere((item) =>
                    item.name!
                        .toString()
                        .substring(0, 1)
                        .toUpperCase()
                        .contains(result));
                if (itemIndex > 0) {
                  controller.itemScrollController.scrollTo(
                      index: itemIndex, duration: const Duration(seconds: 1));
                } else {
                  //in this you can call the api to get the item.
                }
              },
            ),
    );
  }

  Widget buildChildMenuBody(Representatives representatives) {
    return UserListWidget(
      representatives: representatives,
      press: () async {
        controller.isLoading(true);
        await controller.userDetailController
            .getUserDetailApi(representatives.id, representatives.role);
        controller.isLoading(false);
      },
      isFromBookmark: false,
    );
  }

  /// Section Widget
  Widget _buildSearchSection() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(
        left: 0.h,
        right: 0.h,
      ),
      child: CustomSearchView(
        isShowFilter: false,
        controller: controller.textController.value,
        hintText: "search_here".tr,
        onSubmit: (result) {
          if (result.isNotEmpty) {
            FocusManager.instance.primaryFocus?.unfocus();
            controller.getAttendeeList(requestBody: {
              "page": "1",
              "role": role,
              "filters": {
                "text": result,
                "sort": "ASC",
                "is_blocked": false,
                "notes": false,
                "params": {"featured": true}
              },
            }, isRefresh: true);
          }
        },
        onClear: (result) {
          _refreshIndicatorKey.currentState?.show();
        },
        press: () async {},
      ),
    );
  }
}
