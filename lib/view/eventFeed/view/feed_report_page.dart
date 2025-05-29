import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/view/eventFeed/controller/eventFeedController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/button/common_material_button.dart';
import '../../../widgets/toolbarTitle.dart';

class FeedReportPage extends GetView<EventFeedController> {
  String eventFeedId = "";
  String? feedCommentId = "";
  bool isReportPost;
  FeedReportPage(
      {Key? key,
      required this.eventFeedId,
      this.feedCommentId,
      required this.isReportPost})
      : super(key: key);
  static const routeName = "/FeedbackPage";
  final TextEditingController textAreaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          title: "report_on_Feed".tr,
        ),
      ),
      body: Container(
          padding: const EdgeInsets.all(10),
          child: GetX<EventFeedController>(builder: (controller) {
            return Stack(
              children: [
                Column(
                  children: [
                    buildSelectionWidget(),
                    controller.selectedReportOption.value == controller.commentResign.length - 1
                        ?  textArea()
                        :  const SizedBox(),
                    CommonMaterialButton(
                      text: 'Submit',
                      isLoading: controller.loading.value,
                      onPressed: () async {
                        if(textAreaController.text.trim().isEmpty &&
                            controller.selectedReportOption.value ==
                                controller.commentResign.length - 1) {
                          UiHelper.showFailureMsg(
                              null, "enter_description".tr);
                          textAreaController.clear();
                          return;
                        }
                        if (isReportPost) {
                          await controller.reportPostApi(requestBody: {
                            "feed_id": eventFeedId,
                            "reason": controller.selectedReportOption.value == controller.commentResign.length - 1
                                ? textAreaController.text.trim()
                                : controller.commentResign[
                            controller.selectedReportOption.value]
                          });
                        } else {
                          await controller.reportCommentApi(requestBody: {
                            "feed_id": eventFeedId,
                            "feed_comment_id": feedCommentId,
                            "reason": controller.selectedReportOption.value == controller.commentResign.length - 1
                                ? textAreaController.text.trim()
                                : controller.commentResign[
                            controller.selectedReportOption.value]
                          });
                        }

                        Get.back();
                      },
                    )
                  ],
                ),
              ],
            );
          })),
    );
  }

  buildSelectionWidget() {
    return Expanded(
        child: ListView.builder(
            itemCount: controller.commentResign.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  controller.selectedReportOption(index);
                },
                child: ListTile(
                    title: CustomTextView(
                      fontWeight: FontWeight.normal,
                      text: controller.commentResign[index],
                      fontSize: 18,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                    ),
                    trailing: Obx(() => Icon(
                          color: Colors.black,
                          controller.selectedReportOption.value != -1 &&
                                  controller.selectedReportOption.value == index
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                        ))),
              );
            }));
  }

  textArea() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          "enter_report_description".tr,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      subtitle: TextFormField(
        textInputAction: TextInputAction.done,
        controller: textAreaController,
        validator: (String? value) {
          if (value!.trim().isEmpty || value.trim() == null) {
            return "enter_description".tr;
          }
          return null;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          //labelText: "${createFieldBody.label}",
          hintText: "",
          labelStyle: TextStyle(color: colorSecondary),
          fillColor: Colors.transparent,
          filled: true,
          prefixIconConstraints: const BoxConstraints(minWidth: 60),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colorSecondary)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black)),
        ),
        minLines: 6,
        maxLines: 12,
      ),
    );
  }
}
