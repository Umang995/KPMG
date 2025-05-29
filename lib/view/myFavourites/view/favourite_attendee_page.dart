import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/view/myFavourites/controller/favourite_user_controller.dart';
import 'package:dreamcast/view/skeletonView/userBodySkeleton.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../widgets/custom_search_view.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../representatives/controller/user_detail_controller.dart';
import '../../../widgets/userListBody.dart';
import '../../representatives/model/user_model.dart';

class FavouriteAttendeePage extends GetView<FavUserController> {
  static const routeName = "/RepresentativesListPage";
  FavouriteAttendeePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        width: context.width,
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: GetX<FavUserController>(builder: (controller) {
          return Stack(
            children: [
              RefreshIndicator(
                  color: colorLightGray,
                  backgroundColor: colorPrimary,
                  strokeWidth: 1.0,
                  key: controller.refreshIndicatorKey,
                  child: buildChildList(context),
                  onRefresh: () {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        controller.getBookmarkUser();
                      },
                    );
                  }),
              _progressEmptyWidget()
            ],
          );
        }),
      ),
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child:
          controller.loading.value || controller.userController.isLoading.value
              ? const Loading()
              : controller.favouriteAttendeeList.isEmpty &&
                      !controller.isFirstLoading.value
                  ? ShowLoadingPage(
                      refreshIndicatorKey: controller.refreshIndicatorKey)
                  : const SizedBox(),
    );
  }

  Widget buildChildList(BuildContext context) {
    return Skeletonizer(
      enabled: controller.isFirstLoading.value,
      child: controller.isFirstLoading.value
          ? const UserListSkeleton()
          : ListView.builder(
              itemCount: controller.favouriteAttendeeList.length,
              itemBuilder: (context, index) =>
                  buildListViewBody(controller.favouriteAttendeeList[index]),
            ),
    );
  }

  Widget buildListViewBody(Representatives representatives) {
    return UserListWidget(
      representatives: representatives,
      press: () async {
        await controller.userController.getUserDetailApi(
            representatives.id, representatives.role ?? MyConstant.attendee);
      },
      isFromBookmark: false,
    );
  }
}
