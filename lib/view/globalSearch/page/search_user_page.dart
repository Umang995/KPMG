import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/view/representatives/controller/networkingController.dart';
import 'package:dreamcast/view/skeletonView/userBodySkeleton.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/view/representatives/controller/user_detail_controller.dart';
import 'package:dreamcast/widgets/userListBody.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_decoration.dart';
import '../../../widgets/loadMoreItem.dart';
import '../../dashboard/showLoadingPage.dart';
import '../controller/globleSearchController.dart';

class SearchUserPage extends GetView<NetworkingController> {
  SearchUserPage({super.key});

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  final controller = Get.put(NetworkingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GetX<NetworkingController>(builder: (controller) {
        return Container(
          color: Colors.transparent,
          width: context.width,
          padding: AppDecoration.commonVerticalPadding(),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      backgroundColor: colorSecondary,
                      key: _refreshIndicatorKey,
                      onRefresh: () {
                        return Future.delayed(
                          const Duration(seconds: 1),
                          () {
                            refreshListApi();
                          },
                        );
                      },
                      child: buildChildList(context),
                    ),
                  ),
                  controller.isLoadMoreRunning.value
                      ? const LoadMoreLoading()
                      : const SizedBox()
                  // when the _loadMore function is running
                ],
              ),
              _progressEmptyWidget()
            ],
          ),
        );
      }),
    );
  }

  refreshListApi() {
    controller.getAttendeeList(isRefresh: true);
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isLoading.value ||
              controller.userDetailController.isLoading.value
          ? const Loading()
          : controller.attendeeList.isEmpty && !controller.isFirstLoading.value
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  Widget buildChildList(BuildContext context) {
    return Skeletonizer(
        enabled: controller.isFirstLoading.value,
        child: controller.isFirstLoading.value
            ? const UserListSkeleton()
            : ListView.builder(
                controller: controller.scrollControllerAttendee,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.attendeeList.length,
                itemBuilder: (context, index) =>
                    buildChildMenuBody(controller.attendeeList[index]),
              ));
  }

  Widget buildChildMenuBody(dynamic representatives) {
    return UserListWidget(
      representatives: representatives,
      isFromBookmark: false,
      isApiLoading: controller.isFirstLoading.value,
      press: () async {
        controller.isLoading(true);
        await controller.userDetailController
            .getUserDetailApi(representatives.id, representatives.role);
        controller.isLoading(false);
      },
    );
  }
}
