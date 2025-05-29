import 'package:dreamcast/widgets/home_widget/common_document_widget.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/view/guide/controller/info_guide_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../skeletonView/resource_center_skeleton.dart';

class UserGuideList extends GetView<InfoFaqController> {
  UserGuideList({Key? key}) : super(key: key);

  static const routeName = "/GuideListPage";

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        centerTitle: false,
        title: ToolbarTitle(
          title: "guide".tr,
          color: Colors.black,
        ),
        shape: const Border(bottom: BorderSide(color: borderColor, width: 1)),
        backgroundColor: white,
        iconTheme: IconThemeData(color: colorSecondary),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: GetX<InfoFaqController>(
          builder: (controller) {
            return Stack(
              children: [
                RefreshIndicator(
                  key: _refreshIndicatorKey,
                  color: colorLightGray,
                  backgroundColor: colorPrimary,
                  strokeWidth: 1.0,
                  triggerMode: RefreshIndicatorTriggerMode.anywhere,
                  onRefresh: () async {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        controller.getUserGuide(isRefresh: true);
                      },
                    );
                  },
                  child: buildListView(context),
                ),
                // when the first load function is running
                _progressEmptyWidget()
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.loading.value
          ? const SizedBox()
          : !controller.isFirstLoading.value && controller.guideList.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  Widget buildListView(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorLightGray,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Skeletonizer(
        enabled: controller.isFirstLoading.value,
        child: controller.isFirstLoading.value
            ? ResourceCenterSkeleton()
            : ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: controller.guideList.length,
                itemBuilder: (context, index) {
                  var data = controller.guideList[index];
                  return CommonDocumentWidget(
                    data: data,
                    isBriefcase: false,
                    showBookmark: false,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    height: 1,
                    color: borderColor,
                  );
                },
              ),
      ),
    );
  }
}
