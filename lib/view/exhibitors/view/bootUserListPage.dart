import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/widgets/userListBody.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/loadMoreItem.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/dashboard_controller.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../representatives/controller/user_detail_controller.dart';
import '../../skeletonView/userBodySkeleton.dart';
import '../controller/exhibitorsController.dart';
import '../controller/exhibitorsUserController.dart';
import '../controller/exhibitorsUserController.dart';
import '../controller/exhibitorsUserController.dart';
import '../model/exhibitorTeamModel.dart';
import '../widget/boot_user_widget.dart';

class BootUserListPage extends GetView<BootUserController> {
  static const routeName = "/BootUserListPage";
  BootUserListPage({Key? key}) : super(key: key);

  final GlobalKey<RefreshIndicatorState> _refreshTab1Key =
      GlobalKey<RefreshIndicatorState>();

  final BoothController bootController = Get.find();

  final BootUserController bootUserController = Get.put(BootUserController());

  String role = MyConstant.attendee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        title: const ToolbarTitle(title: "Representatives"),
      ),
      body: buildTabFirst(context),
    );
  }

  Widget buildTabFirst(BuildContext context) {
    return GetX<BootUserController>(builder: (controller) {
      return Container(
        color: Colors.transparent,
        width: context.width,
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: RefreshIndicator(
                  key: _refreshTab1Key,
                  onRefresh: () {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () async {
                        callUserListAPi(search: "", isRefresh: true);
                      },
                    );
                  },
                  child: buildChildList(context),
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

  callUserListAPi({required String search, required isRefresh}) async {
    var body = {"id": bootController.exhibitorsBody.value.id, "page": 1};
    await controller.getExhibitorUser(requestBody: body, limited: false);
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isLoading.value
          ? const Loading()
          : controller.representativesList.isEmpty &&
                  !controller.isFirstLoadRunning.value
              ? ShowLoadingPage(refreshIndicatorKey: _refreshTab1Key)
              : const SizedBox(),
    );
  }

  Widget buildChildList(BuildContext context) {
    return Skeletonizer(
      enabled: controller.isFirstLoadRunning.value,
      child: controller.isFirstLoadRunning.value
          ? const UserListSkeleton()
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: controller.userScrollController,
              itemCount: controller.representativesList.length,
              itemBuilder: (context, index) => Padding(
                child: _teamViewCard(
                  context,
                  controller.representativesList[index],
                ),
                padding: const EdgeInsets.only(bottom: 10),
              ),
            ),
    );
  }

  _openUserDetail({userId, role}) async {
    final UserDetailController reController = Get.isRegistered<UserDetailController>()
        ? Get.find()
        : Get.put(UserDetailController());
    controller.isLoading(true);
    await reController.getUserDetailApi(userId, role);
    controller.isLoading(false);
  }

  _teamViewCard(
    BuildContext context,
    ExhibitorTeamData representativesParam,
  ) {
    return InkWell(
      onTap: () {
        _openUserDetail(
            userId: representativesParam.id, role: representativesParam.role);
      },
      child: BootUserWidget(
        representativesParam: representativesParam,
      ),
    );
  }
}
