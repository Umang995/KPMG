import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/button/common_material_button.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/showLoadingPage.dart';
import '../controller/pollsController.dart';
import '../model.dart';

class PollsPage extends GetView<PollController> {
  PollsPage({Key? key}) : super(key: key);
  static const routeName = "/PollsPage";

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  var quizController = Get.put(PollController());
  final textFieldController = TextEditingController();
  var itemWidget = <Widget>[];

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
        title: ToolbarTitle(
            title: controller.itemType == "event"
                ? "polls".tr
                : "session_poll".tr),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: GetX<PollController>(
          builder: (controller) {
            return Stack(
              children: [
                controller.isSubmit.value
                    ? const SizedBox()
                    : SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            controller.getLivePoll().isNotEmpty
                                ? controller.getLivePoll()[0].status == 2
                                    ? buildPollResult(
                                        controller.getLivePoll()[0])
                                    : ListTile(
                                        contentPadding: const EdgeInsets.all(0),
                                        title: buildQuestion(controller
                                                .getLivePoll()[0]
                                                .question ??
                                            ""),
                                        subtitle: ListView.builder(
                                          padding: const EdgeInsets.all(0),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: controller
                                              .getLivePoll()[0]
                                              .options
                                              ?.length,
                                          itemBuilder: (context, index) {
                                            var option = controller
                                                .getLivePoll()[0]
                                                .options![index];
                                            return GestureDetector(
                                              onTap: () {},
                                              child: buildOption(
                                                  option,
                                                  controller.getLivePoll()[0],
                                                  index),
                                            );
                                          },
                                        ),
                                      )
                                : const SizedBox(),
                            const SizedBox(
                              height: 100,
                            )
                          ],
                        ),
                      ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: (controller.getLivePoll().isNotEmpty &&
                              controller.getLivePoll()[0].status == 1) &&
                          !controller.isSubmit.value
                      ? CommonMaterialButton(
                          textSize: 18,
                          height: 56.v,
                          text: "send_response".tr,
                          color: colorPrimary,
                          onPressed: () {
                            if (controller.isAnswerd.value) {
                              var questionId = controller.getLivePoll()[0].id;
                              var opinion = controller
                                  .getLivePoll()[0]
                                  .options?[controller.selectedTabIndex.value];
                              if (opinion != null &&
                                  opinion.toString().isEmpty) {
                                UiHelper.showFailureMsg(
                                    context, "select_answer".tr);
                                return;
                              } else {
                                var requestBody = {
                                  "opinion": opinion.toString(),
                                  "id": questionId,
                                  "item_id": controller.itemId,
                                  "item_type": controller.itemType
                                };
                                controller.submitPollResponse(
                                    requestBody: requestBody);
                              }
                            } else {
                              UiHelper.showFailureMsg(
                                  context, "select_answer".tr);
                            }
                          },
                        )
                      : const SizedBox(),
                ),
                controller.isSubmit.value
                    ? alReadySubmittedWidget()
                    : _progressEmptyWidgetTab2(),
                controller.loading.value ? const Loading() : const SizedBox()
              ],
            );
          },
        ),
      ),
    );
  }

  buildOption(String option, PollListModel createFieldBody, int index) {
    return GestureDetector(
      onTap: () {
        if (controller.isSubmit.value) {
          return;
        }
        controller.isAnswerd(true);
        controller.selectedTabIndex(index);
      },
      child: Obx(
        () => Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: checkQuestionColor(option),
            borderRadius: const BorderRadius.all(Radius.circular(26)),
          ),
          child: ListTile(
            title: CustomTextView(
              text: option ?? "",
              fontSize: 16,
              textAlign: TextAlign.start,
              color: controller.selectedTabIndex.value == index
                  ? controller.selectedOption == option
                      ? white
                      : colorSecondary
                  : colorSecondary,
              fontWeight: controller.selectedTabIndex.value == index
                  ? FontWeight.w500
                  : FontWeight.w500,
            ),
            trailing: controller.selectedTabIndex.value == index
                ?  Icon(Icons.radio_button_checked_outlined,
                    color: colorPrimary, size: 22)
                : SvgPicture.asset(
                    ImageConstant.icRadioInactive,
                    height: 22.v,
                    width: 22.h,
                  ),
          ),
        ),
      ),
    );
  }

  checkQuestionColor(option) {
    return controller.selectedOption.value == option
        ? colorLightGray
        : colorLightGray;
  }

  buildQuestion(dynamic question) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: CustomTextView(
        fontSize: 22,
        text: question.toString(),
        maxLines: 10,
        color: colorSecondary,
        textAlign: TextAlign.start,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _progressEmptyWidgetTab2() {
    return Center(
      child: controller.loading.value
          ? const Loading()
          : controller.getLivePoll().isEmpty
              ? ShowLoadingPage(
                  title: "polls".tr,
                  refreshIndicatorKey: _refreshIndicatorKey,
                  message: controller.message ?? "polls_will_start_soon".tr,
                )
              : const SizedBox(),
    );
  }

  Widget alReadySubmittedWidget() {
    return Center(
      child: ShowLoadingPage(
        refreshIndicatorKey: _refreshIndicatorKey,
        message: controller.message,
        iconUrl: ImageConstant.actionDoneIcon,
        title: "polls".tr,
      ),
    );
  }

  buildPollResult(PollListModel pollModel) {
    var resultList = pollModel.result.toList();
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: buildQuestion(controller.getLivePoll()[0].question ?? ""),
      subtitle: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        scrollDirection: Axis.vertical,
        itemCount: resultList.length,
        itemBuilder: (context, index) {
          var mapEntry = resultList[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: white,
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              border: Border.all(width: 1, color: colorSecondary),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomReadMoreText(
                        text: mapEntry['opinion'],
                        textAlign: TextAlign.start,
                        maxLines: 3,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    CustomTextView(
                      maxLines: 5,
                      fontWeight: FontWeight.bold,
                      text: "${mapEntry['percentage']}%",
                      textAlign: TextAlign.start,
                      fontSize: 16,
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                LinearProgressIndicator(
                  value: (mapEntry['percentage'] / 100),
                  backgroundColor: colorLightGray,
                  valueColor:  AlwaysStoppedAnimation<Color>(colorPrimary),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
