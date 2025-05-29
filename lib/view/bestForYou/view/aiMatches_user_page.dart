import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/bestForYou/controller/aiMatchController.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/view/representatives/controller/user_detail_controller.dart';
import 'package:dreamcast/widgets/userListBody.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_decoration.dart';
import '../../../widgets/custom_search_view.dart';
import '../../../widgets/loadMoreItem.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../skeletonView/userBodySkeleton.dart';

class AiMatchUserPage extends GetView<AiMatchController> {
  static const routeName = "/AiMatchesListPage";
  AiMatchUserPage({super.key});

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 0,
        centerTitle: false,
        shape:
            const Border(bottom: BorderSide(color: borderColor, width: 1)),
        title: ToolbarTitle(
          title: "attendee".tr,
          color: Colors.black,
        ),
        backgroundColor: white,
        iconTheme:  IconThemeData(color: colorSecondary),
      ),
      body: GetX<AiMatchController>(builder: (controller) {
        return Container(
          width: context.width,
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Stack(
            children: [
              RefreshIndicator(
                backgroundColor: colorSecondary,
                key: _refreshIndicatorKey,
                onRefresh: () {
                  return Future.delayed(
                    const Duration(seconds: 1),
                    () {
                      refreshListApi(search: "");
                    },
                  );
                },
                child: buildChildList(context),
              ),
              _progressEmptyWidget()
            ],
          ),
        );
      }),
    );
  }

  refreshListApi({required String search}) {
    controller.getDataByIndexPage(0);
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isLoading.value
          ? const Loading()
          : controller.aiUserList.isEmpty && !controller.isFirstLoading.value
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
                physics: const AlwaysScrollableScrollPhysics(),
                controller: controller.userScrollController,
                itemCount: controller.aiUserList.length,
                itemBuilder: (context, index) =>
                    buildChildMenuBody(controller.aiUserList[index]),
              ));
  }

  Widget buildChildMenuBody(dynamic representatives) {
    return UserListWidget(
      isFromBookmark: false,
      isApiLoading: controller.isFirstLoading.value,
      representatives: representatives,
      press: () async {
        controller.isLoading(true);
        await controller.userDetailController
            .getUserDetailApi(representatives.id, representatives.role);
        controller.isLoading(false);
      },
    );
  }
}
