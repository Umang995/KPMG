import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/view/exhibitors/model/exibitorsModel.dart';
import 'package:dreamcast/view/myFavourites/controller/favourite_boot_controller.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/view/exhibitors/controller/exhibitorsController.dart';
import 'package:dreamcast/view/myFavourites/model/bookmark_exhibitor_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_decoration.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../exhibitors/view/bootListBody.dart';
import '../../skeletonView/gridViewSkeleton.dart';

class FavouriteExhibitorsPage extends GetView<FavBootController> {
  static const routeName = "/ExhibitorsListPage";
  FavouriteExhibitorsPage({super.key});

  var selectedParentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.width,
        padding: AppDecoration.userParentPadding(),
        child: GetX<FavBootController>(builder: (controller) {
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
                        controller.getBookmarkExhibitor();
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
      child: controller.loading.value ||
              controller.exhibitorsController.isLoading.value
          ? const Loading()
          : !controller.isFirstLoading.value &&
                  controller.favouriteBootList.isEmpty
              ? ShowLoadingPage(
                  refreshIndicatorKey: controller.refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  Widget buildChildList(BuildContext context) {
    return Skeletonizer(
        enabled: controller.isFirstLoading.value,
        child: controller.isFirstLoading.value
            ? const BootViewSkeleton()
            : GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.favouriteBootList.length,
                itemBuilder: (context, index) => buildChildBody(
                    controller.favouriteBootList[index], context),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 9 / 10,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15)));
  }

  Widget buildChildBody(Exhibitors exhibitors, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        controller.exhibitorsController.getExhibitorsDetail(exhibitors.id);
      },
      child: BootListBody(
        exhibitor: exhibitors,
        isApiLoading: controller.isFirstLoading.value,
      ),
    );
  }
}
