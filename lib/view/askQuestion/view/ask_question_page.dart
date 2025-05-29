import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/dashboard/showLoadingPage.dart';
import 'package:dreamcast/view/askQuestion/controller/askQuestionController.dart';
import 'package:dreamcast/widgets/dialog/custom_animated_dialog_widget.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/button/common_material_button.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../skeletonView/ListDocumentSkeleton.dart';
import '../model/ask_question_model.dart';

class AskQuestionPage extends GetView<AskQuestionController> {
  AskQuestionPage({Key? key}) : super(key: key);
  static const routeName = "/AskQuestionPage";

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final textFieldController = TextEditingController();
  final AskQuestionController askQuestionController =
      Get.put(AskQuestionController());

  var _isButtonDisabled = false;

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
        title: ToolbarTitle(title: "ask_question".tr),
      ),
      body: GetX<AskQuestionController>(
        builder: (controller) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                Column(
                  children: [
                    askQuestionController.itemType == "webinar"
                        ? askQuestionTypeDetails(context)
                        : const SizedBox(),
                    askQuestionController.itemType == "webinar"
                        ? const SizedBox(
                            height: 13,
                          )
                        : const SizedBox(),
                    askQuestionController.itemType != "webinar" &&
                        askQuestionController.itemType != "event"
                        ? Container(
                            padding: const EdgeInsets.all(14),
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 1,
                            decoration: BoxDecoration(
                              color: /*const Color.fromRGBO(244, 243, 247, 1)*/
                                  colorLightGray,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                askQuestionController.image != null &&
                                        askQuestionController.image!.isNotEmpty
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                        child: Center(
                                          child: AspectRatio(
                                              aspectRatio: 7 / 6,
                                              child: UiHelper
                                                  .getExhibitorDetailsImage(
                                                      imageUrl:
                                                          askQuestionController
                                                              .image)),
                                        ))
                                    : const SizedBox(),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomTextView(
                                        text: askQuestionController.name ?? "",
                                        color: colorSecondary,
                                        // Adjust text color if needed
                                        fontSize: 18,
                                        textAlign: TextAlign.start,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Flexible(
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                                ImageConstant.iconLocationMap),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            CustomTextView(
                                              fontSize: 12,
                                              maxLines: 2,
                                              color: colorGray,
                                              fontWeight: FontWeight.normal,
                                              textAlign: TextAlign.start,
                                              text:
                                                  "Hall No: ${askQuestionController.hallNo ?? ""} | "
                                                  "Booth No: ${askQuestionController.boothNo ?? ""} ",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    askQuestionController.itemType != "webinar" &&
                        askQuestionController.itemType != "event"
                        ? const SizedBox(
                            height: 13,
                          )
                        : const SizedBox(),
                    askQuestionController.itemType != "webinar" &&
                        askQuestionController.itemType != "event"
                        ? const Divider(
                      color: Color.fromRGBO(138, 138, 142, 1),
                      thickness: 0.1,
                    )  : const SizedBox(),
                    const SizedBox(
                      height: 13,
                    ),
                    controller.questionList.isNotEmpty
                        ? askQuestionHeader(context)
                        : const SizedBox(),
                    controller.questionList.isNotEmpty
                        ? const SizedBox(
                            height: 20,
                          )
                        : const SizedBox(),
                    addedQuestionList(context),
                  ],
                ),
                progressEmptyWidget(context)
              ],
            ),
          );
        },
      ),
    );
  }

  Widget askQuestionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomTextView(
          text: "Total ${controller.questionList.length} questions",
          color: colorGray,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: white,
            backgroundColor: colorPrimary,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            side: BorderSide(color: colorPrimary),
          ),
          onPressed: () async {
            FocusScope.of(context).unfocus();
            textFieldController.clear();
            askQuestionDialog(context);
          },
          child: CustomTextView(
            text: "add_new".tr,
            color: white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }

  RefreshIndicator? refreshIndicatorKey;

  refreshApiData() async {
    askQuestionController.getAskQuestionList();
  }

  askQuestionTypeDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextView(
          text: askQuestionController.itemType == null ||
                  askQuestionController.itemType!.isEmpty
              ? "Event"
              : askQuestionController.itemType == "webinar"
                  ? "Session"
                  : "Exhibitor",
          fontWeight: FontWeight.w600,
          color: colorDisabled,
          fontSize: 22,
        ),
        SizedBox(
          width: context.width * 1.h,
          child: CustomTextView(
            text: askQuestionController.name ?? "",
            fontWeight: FontWeight.w500,
            color: colorSecondary,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget addedQuestionList(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        backgroundColor: colorSecondary,
        onRefresh: () {
          return Future.delayed(
            const Duration(seconds: 1),
            () {
              refreshApiData();
            },
          );
        },
        child: Skeletonizer(
          enabled: controller.isFirstLoading.value,
          child: controller.isFirstLoading.value
              ? const ListDocumentSkeleton()
              : ListView.separated(
                  itemCount: controller.questionList.length,
                  itemBuilder: (context, index) {
                    AskQuestion data = controller.questionList[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 17),
                      decoration: BoxDecoration(
                          color: colorLightGray,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: CustomReadMoreText(
                        maxLines: 2,
                        text: "${index + 1}. ${data.question}" ?? "",
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: colorSecondary,
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 15,
                    );
                  },
                ),
        ),
      ),
    );
  }

  progressEmptyWidget(BuildContext context) {
    return Center(
      child: controller.isFirstLoading.value == false &&
              controller.questionList.isEmpty
          ? Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShowLoadingPage(
                    refreshIndicatorKey: _refreshIndicatorKey,
                    title: "no_question_found".tr,
                    message: askQuestionController.message ?? ""),
                askQuestionController.buttonStatus!
                    ? OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 50),
                          foregroundColor: white,
                          backgroundColor: colorPrimary,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: colorPrimary),
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          side: BorderSide(color: colorPrimary),
                        ),
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          textFieldController.clear();
                          askQuestionDialog(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CustomTextView(
                            text: "askQuestion".tr,
                            color: white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : const SizedBox()
              ],
            )
          : const SizedBox(),
    );
  }

  askQuestionDialog(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled:
          true, // Allows bottom sheet to adjust when keyboard opens
      builder: (BuildContext context) {
        return Container(
          padding:
              const EdgeInsets.only(left: 18, right: 18, top: 18, bottom: 8),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: white,
            border: Border.all(color: borderColor, width: 1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context)
                        .viewInsets
                        .bottom, // Adjusts padding when keyboard opens
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextView(
                            text: "ask_question".tr,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: colorSecondary,
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: SvgPicture.asset(ImageConstant.icClose),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Divider(color: colorLightGray),
                      const SizedBox(height: 12),
                      TextField(
                        controller: textFieldController,
                        maxLines: 6,
                        minLines: 3,
                        maxLength: 1024,
                        cursorColor: colorSecondary,
                        style: TextStyle(
                            fontSize: 16.fSize,
                            color: colorSecondary,
                            fontWeight: FontWeight.normal),
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: "type_question_here".tr,
                          labelStyle: TextStyle(
                              fontSize: 16.fSize,
                              color: colorGray,
                              fontWeight: FontWeight.normal),
                          hintStyle: TextStyle(
                              fontSize: 16.fSize,
                              color: colorGray,
                              fontWeight: FontWeight.normal),
                          filled: true,
                          fillColor: white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: borderColor, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: borderColor, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: borderColor, width: 1),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                      const SizedBox(height: 12),
                      CommonMaterialButton(
                        color: colorPrimary,
                        onPressed: () async {
                          if (_isButtonDisabled)
                            return; // Prevent further clicks
                          _isButtonDisabled = true;
                          Future.delayed(const Duration(seconds: 2), () {
                            _isButtonDisabled =
                                false; // Re-enable the button after the screen is closed
                          });
                          FocusScope.of(context).unfocus();
                          if (textFieldController.text
                              .toString()
                              .trim()
                              .isEmpty) {
                            UiHelper.showFailureMsgTop(
                                null, "enter_question_to_submit".tr);
                            return;
                          } else if (textFieldController.text
                                      .toString()
                                      .trim()
                                      .length <
                                  10 &&
                              textFieldController.text
                                      .toString()
                                      .trim()
                                      .length >
                                  1024) {
                            UiHelper.showFailureMsgTop(null,
                                "The field should be 10 to 1024 characters long.");
                            return;
                          }
                          var result = await controller.saveQuestion(
                              textFieldController.text.trim().toString());
                          Future.delayed(const Duration(seconds: 0), () async {
                            Get.back();
                            await Get.dialog(
                                barrierDismissible: false,
                                CustomAnimatedDialogWidget(
                                  title: "success_action".tr,
                                  logo: ImageConstant.icSuccessAnimated,
                                  description: result['message'],
                                  buttonAction: "okay".tr,
                                  buttonCancel: "cancel".tr,
                                  isHideCancelBtn: true,
                                  onCancelTap: () {},
                                  onActionTap: () async {},
                                ));
                          });
                        },
                        text: "submit_question".tr,
                        textSize: 18,
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() => controller.loading.value
                  ? SizedBox(height: 300.adaptSize, child: const Loading())
                  : const SizedBox()),
            ],
          ),
        );
      },
    );
  }

  Widget circularImage({url, shortName}) {
    return url != null && url.isNotEmpty
        ? SizedBox(
            height: 40,
            width: 40, // the picture will acquire all of the parent space.
            child: CircleAvatar(backgroundImage: NetworkImage(url)),
          )
        : const SizedBox();
  }
}
