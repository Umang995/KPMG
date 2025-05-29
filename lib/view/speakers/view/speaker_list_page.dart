import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/speakers/controller/speakerNetworkController.dart';
import 'package:dreamcast/view/speakers/model/speakersModel.dart';
import 'package:dreamcast/view/speakers/view/speakerListBody.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/view/representatives/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../routes/my_constant.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/az_listview/src/az_listview.dart';
import '../../../widgets/az_listview/src/index_bar.dart';
import '../../../widgets/linkedin_aibutton.dart';
import '../../../widgets/textview/customTextView.dart';
import '../../../widgets/custom_search_view.dart';
import '../../../widgets/loadMoreItem.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../bestForYou/view/aiMatch_dashboard_page.dart';
import '../../dashboard/dashboard_controller.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../skeletonView/userBodySkeleton.dart';
import '../dialog/speaker_filter_dialog.dart';
import '../widget/feature_speaker_widget.dart';

class SpeakerListPage extends GetView<SpeakerNetworkController> {
  SpeakerListPage({super.key});
  static const routeName = "/SpeakerNetworkPage";
  String role = MyConstant.speakers;

  SpeakerNetworkController speakerNetworkController =
      Get.put(SpeakerNetworkController());

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
        title: ToolbarTitle(
            title: Get.arguments?[MyConstant.titleKey] ?? "speakers".tr),
      ),
      body: GetX<SpeakerNetworkController>(
        builder: (controller) {
          return NestedScrollView(
            controller: controller.nestedScrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: featureWidget(),
                ),
              ];
            },
            body: silverBodyWidget(context),
          );
        },
      ),
    );
  }

  ///header widget
  Widget silverBodyWidget(BuildContext context) {
    return Container(
      width: context.width,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 20,
          ),
          _buildSearchSection(),
          userCountWidget(),
          Expanded(
            child: Stack(
              children: [
                RefreshIndicator(
                  color: colorLightGray,
                  backgroundColor: colorPrimary,
                  strokeWidth: 1.0,
                  key: controller.refreshIndicatorKey,
                  onRefresh: () {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        controller.getFeatureSpeakerList(isRefresh: false);
                        refreshApiData(isRefresh: false);
                      },
                    );
                  },
                  child: azListViewWidget(context),
                ),
                _progressEmptyWidget()
              ],
            ),
          ),
          // when the _loadMore function is running
          controller.isLoadMoreRunning.value
              ? const LoadMoreLoading()
              : const SizedBox()
        ],
      ),
    );
  }

  ///no data found widget
  Widget _progressEmptyWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      child: controller.isLoading.value
          ? const Loading()
          : controller.attendeeList.isEmpty && !controller.isFirstLoading.value
              ? ShowLoadingPage(
                  refreshIndicatorKey: controller.refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  ///this is indexing az listview
  Widget azListViewWidget(BuildContext context) {
    return Skeletonizer(
      enabled: controller.isFirstLoading.value,
      child: controller.isFirstLoading.value
          ? const UserListSkeleton()
          : AzListView(
              itemScrollController: controller.itemScrollController,
              data: controller.attendeeList,
              itemCount: controller.attendeeList.length,
              scrollController: controller.nestedScrollController,
              itemBuilder: (BuildContext context, int index) {
                var model = controller.attendeeList[index];
                return buildChildMenuBody(model);
              },
              physics: const BouncingScrollPhysics(),
              itemPositionsListener: controller.itemPositionsListener,
              indexBarData: const [...kIndexBarData],
              indexBarOptions: IndexBarOptions(
                needRebuild: true,
                ignoreDragCancel: true,
                textStyle: TextStyle(color: colorPrimary, fontSize: 12),
                downTextStyle:
                    const TextStyle(fontSize: 12, color: Colors.white),
                downItemDecoration:
                    BoxDecoration(shape: BoxShape.circle, color: colorPrimary),
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

                if (itemIndex > -1) {
                  controller.itemScrollController.scrollTo(
                      index: itemIndex, duration: const Duration(seconds: 1));
                } else {
                  return;
                  //controller.attendeeAPiCall(isRefresh: true);
                }
              },
            ),
    );
  }

  ///child of listview
  Widget buildChildMenuBody(SpeakersData representatives) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 25),
      child: GestureDetector(
        onTap: () async {
          controller.isLoading(true);
          await controller.userDetailController.getSpeakerDetail(
              speakerId: representatives.id,
              isSessionSpeaker: true,
              role: representatives.role);
          controller.isLoading(false);
        },
        child: SpeakerViewWidget(
          speakerData: representatives,
          isApiLoading: controller.isFirstLoading.value,
          isSpeakerType: true,
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      width: double.maxFinite,
      margin: EdgeInsets.zero,
      child: CustomSearchView(
        isShowFilter: true,
        controller: controller.textController.value,
        hintText: "search_here".tr,
        hintStyle: const TextStyle(fontSize: 16),
        isFilterApply: controller.isFilterApply.value,
        onSubmit: (result) {
          if (result.isNotEmpty) {
            FocusManager.instance.primaryFocus?.unfocus();
            refreshApiData(isRefresh: false);
          }
        },
        onChanged: (result) {
          if (result.length == 0) {
            Future.delayed(const Duration(seconds: 1), () {
              refreshApiData(isRefresh: false);
            });
          }
        },
        onClear: (result) {
          controller.refreshIndicatorKey.currentState?.show();
        },
        press: () async {
          final filterBody = controller.userFilterBody.value;
          if ((filterBody.filters?.isEmpty ?? true) ||
              filterBody.sort == null) {
            await controller.getAndResetFilter(isRefresh: true);
          }
          controller.clearFilterIfNotApply();
          var result = await Get.to(SpeakerFilterDialog(
            role: role,
          ));
          if (result != null) {
            refreshApiData(isRefresh: false);
          }
        },
      ),
    );
  }

  refreshApiData({required isRefresh}) async {
    controller.networkRequestModel.filters?.text =
        controller.textController.value.text.trim() ?? "";
    await controller.getUserListApi(isRefresh: isRefresh);
  }

  ///show the feature speaker data
  Widget featureWidget() {
    return controller.featureSpeakerList.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(bottom: 0, left: 14, right: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                controller.isFirstLoading.value == false &&
                        controller.featureSpeakerList.isEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(
                            left: 0, right: 17, bottom: 17, top: 12),
                        child: CustomTextView(
                          text: "featured_speaker".tr,
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          color: colorGray,
                        ),
                      ),
                controller.isFirstLoading.value == false &&
                        controller.featureSpeakerList.isEmpty
                    ? const SizedBox()
                    : FeatureSpeakerWidget(),
              ],
            ),
          )
        : const SizedBox();
  }

  ///show total user count and ai match button
  Widget userCountWidget() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: CustomTextView(
                text: controller.totalUserCount.value.isNotEmpty
                    ? "${"total_count".tr} (${controller.totalUserCount.value})"
                    : "total_count".tr,
                fontWeight: FontWeight.w600,
                color: colorGray,
                fontSize: 22,
              ),
            ),
            AIMatchButton(
              onTap: () {
                final DashboardController dashboardController = Get.find();
                dashboardController.selectedAiMatchIndex(2);
                Get.toNamed(AiMatchDashboardPage.routeName);
              },
              title: 'aimatches'.tr,
            )
          ],
        ),
      ),
    );
  }
}

/*
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
          color: indicatorColor,
        );
      },
    ),
  );
}*/
