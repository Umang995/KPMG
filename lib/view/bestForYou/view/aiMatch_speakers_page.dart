import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_decoration.dart';
import '../../../widgets/custom_search_view.dart';
import '../../../widgets/loadMoreItem.dart';
import '../../../widgets/loading.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../skeletonView/speakerBodySkeleton.dart';
import '../../speakers/controller/speakersController.dart';
import '../../speakers/view/speakerListBody.dart';
import '../controller/aiMatchController.dart';

class AiMatchesSpeakerPage extends GetView<AiMatchController> {
  static const routeName = "/AiMatchesListPage";
  AiMatchesSpeakerPage({Key? key}) : super(key: key);

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final SpeakersDetailController userController =
      Get.put(SpeakersDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GetX<AiMatchController>(builder: (controller) {
        return Container(
          color: Colors.transparent,
          width: context.width,
          padding: AppDecoration.commonVerticalPadding(),
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
                child: buildListview(context),
              ),
              _progressEmptyWidget()
            ],
          ),
        );
      }),
    );
  }

  refreshListApi({required String search}) {
    controller.getDataByIndexPage(2);
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isLoading.value
          ? const Loading()
          : controller.aiSpeakerList.isEmpty && !controller.isFirstLoading.value
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  Widget buildListview(BuildContext context) {
    return Skeletonizer(
        enabled: controller.isFirstLoading.value,
        child: controller.isFirstLoading.value
            ? const SpeakerListSkeleton()
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.aiSpeakerList.length,
                itemBuilder: (context, index) => controller.isFirstLoading.value
                    ? const SpeakerListSkeleton()
                    : buildListBody(controller.aiSpeakerList[index]),
              ));
  }

  Widget buildListBody(dynamic representatives) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: InkWell(
        onTap: () async {
          controller.isLoading(true);
          await userController.getSpeakerDetail(
              speakerId: representatives.id,
              role: representatives.role,
              isSessionSpeaker: false);
          controller.isLoading(false);
        },
        child: SpeakerViewWidget(
            isApiLoading: controller.isFirstLoading.value,
            speakerData: representatives,
            isSpeakerType: false),
      ),
    );
  }
}
