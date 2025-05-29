import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/bestForYou/controller/aiMatchController.dart';
import 'package:dreamcast/view/skeletonView/sessionSkeletonList.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../theme/app_decoration.dart';
import '../../../widgets/custom_search_view.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../schedule/controller/session_controller.dart';
import '../../schedule/view/session_list_body.dart';

class AiMatchSessionPage extends GetView<AiMatchController> {
  AiMatchSessionPage({super.key});

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final SessionController sessionController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 0,
        title: ToolbarTitle(
          title: "myBookmark".tr,
        ),
        backgroundColor: white,
        shape: const Border(bottom: BorderSide(color: borderColor, width: 1)),
        elevation: 0,
        iconTheme: IconThemeData(color: colorSecondary),
      ),
      body: GetX<AiMatchController>(
        builder: (controller) {
          return Container(
            padding: EdgeInsets.symmetric(
                vertical: 14.adaptSize, horizontal: 15.adaptSize),
            child: Stack(
              children: [
                RefreshIndicator(
                  key: _refreshIndicatorKey,
                  color: Colors.white,
                  backgroundColor: colorSecondary,
                  strokeWidth: 4.0,
                  triggerMode: RefreshIndicatorTriggerMode.anywhere,
                  onRefresh: () async {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        controller.getDataByIndexPage(3);
                      },
                    );
                  },
                  child: buildListView(context),
                ),
                _progressEmptyWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildListView(BuildContext context) {
    return Skeletonizer(
      enabled: controller.isFirstLoading.value,
      child: controller.isFirstLoading.value
          ? const SessionListSkeleton()
          : ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 0,
                );
              },
              itemCount: controller.aiSessionList.length,
              itemBuilder: (context, index) {
                return SessionListBody(
                  isFromBookmark: false,
                  session: controller.aiSessionList[index],
                  index: index,
                  size: controller.aiSessionList.length,
                );
              },
            ),
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isLoading.value || sessionController.loading.value
          ? const Loading()
          : controller.aiSessionList.isEmpty && !controller.isFirstLoading.value
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }
}
