import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/view/globalSearch/controller/globleSearchController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../theme/app_decoration.dart';
import '../../../widgets/loadMoreItem.dart';
import '../../../widgets/loading.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../schedule/controller/session_controller.dart';
import '../../schedule/view/session_list_body.dart';
import '../../skeletonView/agendaSkeletonList.dart';

class SearchSessionPage extends GetView<SessionController> {
  SearchSessionPage({super.key});

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  final controller = Get.put(SessionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GetX<SessionController>(
        builder: (controller) {
          return Container(
              padding: AppDecoration.userParentPadding(),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          key: _refreshIndicatorKey,
                          color: Colors.white,
                          backgroundColor: colorSecondary,
                          strokeWidth: 4.0,
                          triggerMode: RefreshIndicatorTriggerMode.anywhere,
                          onRefresh: () async {
                            return Future.delayed(
                              const Duration(seconds: 1),
                              () {
                                controller.getSessionList(isRefresh: true);
                              },
                            );
                          },
                          child: buildListView(context),
                        ),
                      ),
                      controller.isLoadMoreRunning.value
                          ? const LoadMoreLoading()
                          : const SizedBox()
                      // when the _loadMore function is running
                    ],
                  ),
                  _progressEmptyWidget(),
                ],
              ));
        },
      ),
    );
  }

  Widget buildListView(BuildContext context) {
    return Skeletonizer(
      enabled: controller.isFirstLoading.value,
      child: controller.isFirstLoading.value
          ? const ListAgendaSkeleton()
          : ListView.separated(
              controller: controller.scrollController,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 0,
                );
              },
              itemCount: controller.sessionList.length,
              itemBuilder: (context, index) {
                return SessionListBody(
                  isFromBookmark: false,
                  apiLoading: controller.isFirstLoading.value,
                  session: controller.sessionList[index],
                  index: index,
                  size: controller.sessionList.length,
                );
              },
            ),
    );
  }

  Widget _progressEmptyWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 120),
      child: controller.loading.value
          ? const Loading()
          : !controller.isFirstLoading.value && controller.sessionList.isEmpty
              ? ShowLoadingPage(
                  refreshIndicatorKey: controller.refreshIndicatorKey,
                  message: "no_data_found_description".tr,
                )
              : const SizedBox(),
    );
  }
}
