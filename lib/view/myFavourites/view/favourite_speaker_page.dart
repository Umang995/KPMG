import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_decoration.dart';
import '../../../widgets/userListBody.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../representatives/model/user_model.dart';
import '../../skeletonView/speakerBodySkeleton.dart';
import '../../skeletonView/userBodySkeleton.dart';
import '../../speakers/controller/speakersController.dart';
import '../../speakers/model/speakersModel.dart';
import '../../speakers/view/speakerListBody.dart';
import '../controller/favourite_speaker_controller.dart';
import '../model/bookmark_speaker_model.dart';

class FavouriteSpeakerPage extends GetView<FavSpeakerController> {
  FavouriteSpeakerPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        width: context.width,
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: GetX<FavSpeakerController>(builder: (controller) {
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
                        controller.getBookmarkUser(isRefresh: true);
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
      child: controller.loading.value /*|| userController.isLoading.value*/
          ? const Loading()
          : controller.favouriteSpeakerList.isEmpty &&
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
              itemCount: controller.favouriteSpeakerList.length,
              itemBuilder: (context, index) =>
                  buildListViewBody(controller.favouriteSpeakerList[index]),
            ),
    );
  }

  Widget buildListViewBody(SpeakersData representatives) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: GestureDetector(
        onTap: () async {
          controller.loading(true);
          await controller.userController.getSpeakerDetail(
              speakerId: representatives.id,
              role: representatives.role ?? MyConstant.speakers,
              isSessionSpeaker: false);
          controller.loading(false);
        },
        child: SpeakerViewWidget(
          speakerData: representatives,
          isApiLoading: controller.isFirstLoading.value,
          isSpeakerType: false,
        ),
      ),
    );
  }
}
