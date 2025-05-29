import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/view/quiz/model/question_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/dialog/custom_animated_dialog_widget.dart';
import '../../../widgets/toolbarTitle.dart';
import '../controller/feedbackController.dart';

class QuizPage extends GetView<FeedbackController> {
  QuizPage({Key? key}) : super(key: key);
  static const routeName = "/QuizPage";

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  var quizController = Get.put(FeedbackController());
  final textFieldController = TextEditingController();
  final _progressValue = 0.0.obs;

  var itemWidget = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: false,
        title: ToolbarTitle(
          title: "quiz_page".tr,
          color: Colors.black,
        ),
        elevation: 0,
        shape: const Border(bottom: BorderSide(color: borderColor, width: 1)),
        backgroundColor: white,
        iconTheme: IconThemeData(color: colorSecondary),
      ),
      body: Container(
          padding: const EdgeInsets.all(12),
          child: GetX<FeedbackController>(
            builder: (controller) {
              return Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 6,
                      ),
                      CustomTextView(
                        text:
                            "${controller.selectedTabIndex.value} of ${itemWidget.length}",
                        color: colorSecondary,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      SizedBox(
                        width: 100,
                        child: LinearProgressIndicator(
                          backgroundColor: colorGray,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(colorSecondary),
                          value: _progressValue.value,
                          minHeight: 5,
                        ),
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      IndexedStack(
                        index: controller.selectedTabIndex.value,
                        children: quizItemWidget(),
                      ),
                      bottomWidget()
                    ],
                  ),
                  controller.loading.value ? const Loading() : const SizedBox()
                ],
              );
            },
          )),
    );
  }

  quizItemWidget() {
    itemWidget.clear();
    controller.questionList.forEach((myQuizQuestion) {
      return itemWidget.add(GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
              color: colorLightGray,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          margin: const EdgeInsets.all(6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 30,
              ),
              myQuizQuestion.type == "radio"
                  ? _buildRadioOption(myQuizQuestion)
                  : _buildRadioOption(myQuizQuestion)
            ],
          ),
        ),
      ));
    });
    return itemWidget;
  }

  /* _textAreaWidget(FeedbackQuestion createFieldBody) {
    final TextEditingController textAreaController = TextEditingController();
    textAreaController.text = createFieldBody.answer.toString()!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildTitle(createFieldBody.question),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: textAreaController,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          style: const TextStyle(fontSize: 22, fontFamily: 'SourceSansPro'),
          cursorColor: primaryColor,
          minLines: 1,
          maxLines: 6,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(false ? 60 : 15, 15, 15, 15),
              filled: true,
              hintStyle: const TextStyle(
                  color: grayColorLight, fontFamily: 'SourceSansPro'),
              hintText: "Type you question here",
              fillColor: Colors.white70),
        )
      ],
    );
  }*/

  _buildRadioOption(FeedbackQuestion createFieldBody) {
    return ListTile(
      title: buildTitle(createFieldBody.label),
      subtitle: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: createFieldBody.options?.length,
        itemBuilder: (context, index) {
          var option = createFieldBody.options![index];
          return GestureDetector(
            onTap: () {},
            child: _buildRadio(option, createFieldBody),
          );
        },
      ),
    );
  }

  _buildRadio(FeedbackOptions option, FeedbackQuestion createFieldBody) {
    return InkWell(
      onTap: () {
        createFieldBody.value = option.value;
        controller.questionList.refresh();
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: createFieldBody.value!.isEmpty
                ? Colors.white
                : option.isTrue
                    ? Colors.green
                    : createFieldBody.value == option.value
                        ? Colors.red
                        : white,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: colorGray, width: 1)),
        child: ListTile(
          title: CustomTextView(
            text: option.text ?? "",
            textAlign: TextAlign.start,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          trailing: createFieldBody.value!.isEmpty
              ? Icon(
                  Icons.check_circle,
                  color: white,
                )
              : option.isTrue!
                  ? Icon(
                      Icons.check_circle,
                      color: white,
                    )
                  : Icon(
                      Icons.cancel,
                      color: white,
                    ),
        ),
      ),
    );
  }

  buildTitle(dynamic question) {
    return Text(
      question.toString(),
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  bottomWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        controller.selectedTabIndex.value != 0
            ? GestureDetector(
                child: const Icon(Icons.arrow_back),
                onTap: () {
                  controller
                      .selectedTabIndex(controller.selectedTabIndex.value - 1);
                  _progressValue(0.0);
                },
              )
            : const SizedBox(),
        MaterialButton(
          animationDuration: const Duration(seconds: 1),
          color: colorSecondary,
          hoverColor: colorSecondary,
          splashColor: colorSecondary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () async {
            if (controller.selectedTabIndex.value <
                controller.questionList.length - 1) {
              controller
                  .selectedTabIndex(controller.selectedTabIndex.value + 1);
            } else {
              await Get.dialog(
                  barrierDismissible: false,
                  CustomAnimatedDialogWidget(
                    title: "",
                    logo: ImageConstant.icSuccessAnimated,
                    description: "quiz_submitted_success".tr,
                    buttonAction: "okay".tr,
                    buttonCancel: "cancel".tr,
                    isHideCancelBtn: true,
                    onCancelTap: () {},
                    onActionTap: () async {
                      Get.back();
                    },
                  ));
            }
          },
          child: CustomTextView(
            text: "submit".tr,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
