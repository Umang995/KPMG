import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/startNetworking/controller/angelHallController.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../routes/my_constant.dart';
import '../../../../theme/app_decoration.dart';
import '../../../../utils/image_constant.dart';
import '../../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../../widgets/app_bar/custom_app_bar.dart';
import '../../../../widgets/toolbarTitle.dart';
import '../../../dashboard/showLoadingPage.dart';
import '../../../skeletonView/angelBodySkeleton.dart';
import 'angelWidget/AngelListBody.dart';

class AngelHallListPage extends GetView<AngelHallController> {
  AngelHallListPage({Key? key}) : super(key: key);

  static const routeName = "/AngelHallListPage";
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final AngelHallController sessionController = Get.put(AngelHallController());
  final AuthenticationManager authenticationManager = Get.find();

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
        title: const ToolbarTitle(title: "Angel Ally"),
      ),
      body: GetX<AngelHallController>(
        builder: (controller) {
          return Container(
            color: Colors.white,
            padding: AppDecoration.commonVerticalPadding(),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
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
                              refreshList("");
                            },
                          );
                        },
                        child: buildListView(context),
                      ),
                    )
                  ],
                ),
                _progressEmptyWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> refreshList(String search) async {
    var requestBody = {
      "page": "1",
      "type": MyConstant.angelAlly,
    };
    controller.getAngelAllyHallList(requestBody: requestBody, isRefresh: true);
  }

  Widget buildListView(BuildContext context) {
    return Skeletonizer(
      enabled: controller.isFirstLoading.value,
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0, left: 4),
        child: controller.isFirstLoading.value
            ? const AngelListSkeleton()
            : ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 0,
                  );
                },
                itemCount: controller.sessionList.length,
                itemBuilder: (context, index) {
                  return AngelHallBody(
                    session: controller.sessionList[index],
                    index: index,
                    size: controller.sessionList.length,
                  );
                },
              ),
      ),
    );
  }

  Widget _progressEmptyWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 200),
      child: controller.loading.value
          ? const Loading()
          : !controller.isFirstLoading.value && controller.sessionList.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }
}
