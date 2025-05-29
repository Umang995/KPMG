import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/schedule/controller/session_controller.dart';
import 'package:dreamcast/view/startNetworking/view/pitchStage/pitchStage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../utils/image_constant.dart';
import '../../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../../widgets/app_bar/custom_app_bar.dart';
import '../../../../widgets/loading.dart';
import '../../../../widgets/toolbarTitle.dart';
import '../../../dashboard/showLoadingPage.dart';
import '../../../schedule/view/session_list_body.dart';
import '../../../skeletonView/agendaSkeletonList.dart';

class PitchStageList extends GetView<PitchStageController> {
  PitchStageList({Key? key}) : super(key: key);

  static const routeName = "/pitchStageList";
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final SessionController sessionController = Get.find();
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
        title: const ToolbarTitle(title: "Pitch Stage"),
      ),
      body: GetX<PitchStageController>(
        builder: (controller) {
          return Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 3),
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
              ));
        },
      ),
    );
  }

  Future<void> refreshList(String search) async {
    var requestBody = {
      "page": "1",
      "pitch_stage":true,
      "filters": {
        "text": search ?? "",
        "sort": "ASC",
        "type": "all_session",
        "params": {
          "date": "",
          "pitch_stage":true,
        },
      }
    };
    controller.getSessionList(requestBody: requestBody, isRefresh: true);
  }

  Widget buildListView(BuildContext context) {
    return Skeletonizer(
      enabled: controller.isFirstLoading.value,
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: controller.isFirstLoading.value
            ? const ListAgendaSkeleton()
            : ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 0,
                  );
                },
                itemCount: controller.sessionList.length,
                itemBuilder: (context, index) {
                  return SessionListBody(
                    isFromBookmark: false,
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
              ? ShowLoadingPage(
                  refreshIndicatorKey: _refreshIndicatorKey,
                  message: "data_not_found".tr,
                )
              : const SizedBox(),
    );
  }
}
