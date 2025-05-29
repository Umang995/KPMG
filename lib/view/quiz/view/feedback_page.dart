import 'package:dreamcast/theme/app_decoration.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/quiz/model/question_list_model.dart';
import 'package:dreamcast/widgets/button/common_material_button.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';

import '../../../routes/my_constant.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/showLoadingPage.dart';
import '../controller/feedbackController.dart';

class FeedbackPage extends GetView<FeedbackController> {
  FeedbackPage({Key? key}) : super(key: key);
  static const routeName = "/FeedbackPage";
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final textFieldController = TextEditingController();
  var count = 0;
  var itemWidget = <Widget>[];
  var title = "feedback".tr;

  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      title = Get.arguments?[MyConstant.titleKey] ?? "";
    }
    return GetBuilder<FeedbackController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          resizeToAvoidBottomInset: true,
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
            title: ToolbarTitle(title: title),
          ),
          body: Container(
            padding: const EdgeInsets.all(14),
            child: GetX<FeedbackController>(
              builder: (controller) {
                return Stack(
                  children: [
                    listviewWidget(context),
                    controller.questionList.isNotEmpty
                        ? Align(
                            child: bottomWidget(context),
                            alignment: Alignment.bottomCenter,
                          )
                        : const SizedBox(),
                    _progressEmptyWidget()
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.loading.value
          ? const Loading()
          : !controller.loading.value && controller.questionList.isEmpty
              ? ShowLoadingPage(
                  refreshIndicatorKey: _refreshIndicatorKey,
                  title: title,
                  message: controller.message,
                  iconUrl: controller.message.contains("submitted")
                      ? ImageConstant.actionDoneIcon
                      : "",
                )
              : const SizedBox(),
    );
  }

  Widget listviewWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 90.v),
      child: ListView.builder(
        itemCount: controller.questionList.length,
        itemBuilder: (context, index) {
          var myQuizQuestion = controller.questionList[index];
          Future.delayed(const Duration(seconds: 1), () {
            controller.isValidateForm();
          });
          print("refresh call");
          switch (myQuizQuestion.type) {
            case "textarea":
              return _buildTextareaWidget(myQuizQuestion, index.toString(),
                  minLines: 3, maxLine: 6);
            case "text":
              return _buildTextareaWidget(myQuizQuestion, index.toString(),
                  minLines: 1, maxLine: 1);
            case "checkbox":
              return _buildCheckboxWidget(myQuizQuestion, index.toString());
            case "select":
              return _buildDropdownWidget(myQuizQuestion, index.toString());
            case "radio":
              return _buildRadioWidget(myQuizQuestion, index.toString());
            case "star_rating":
              return buildRatingWidget(
                  myQuizQuestion, context, index.toString());

            case "emoji_rating":
              return buildEmojiWidget(
                  myQuizQuestion, context, index.toString());

            case "number_rating":
              return buildNumberRating(
                  myQuizQuestion, context, index.toString());

            default:
              return const Text("No question type found.");
          }
        },
      ),
    );
  }

  ///common widget
  Widget sharedContainer(Widget child, {EdgeInsets? margin}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: margin ?? const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: colorLightGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  ///common widget
  Widget buildFormattedQuestionLabel(
      FeedbackQuestion question, String questionNumber) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: RichText(
          text: TextSpan(
        text:
            '${(int.parse(questionNumber) + 1)}. ${question.label ?? ""}', // First part of the text
        style: TextStyle(
            fontSize: 18.fSize,
            color: colorSecondary,
            fontWeight: FontWeight.w500),
        children: <TextSpan>[
          TextSpan(
              text: question.rules.toString().contains("required") ? "*" : "",
              style: TextStyle(
                  fontSize: 18.fSize,
                  color: accentColor,
                  fontWeight: FontWeight.w500)),
        ],
      )),
    );
  }

  Widget _buildDropdownWidget(
      FeedbackQuestion createFieldBody, String questionNumber) {
    // Current selected value
    String? selectedValue = createFieldBody.value;

    return sharedContainer(
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          buildFormattedQuestionLabel(createFieldBody, questionNumber),
          const SizedBox(height: 8),
          DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              items: createFieldBody.options
                  ?.map(
                    (option) => DropdownMenuItem<String>(
                      value: option.value,
                      child: CustomTextView(
                        text: option.text ?? "",
                        fontSize: 16, fontWeight: FontWeight.w500,
                        color: selectedValue == option.value
                            ? colorSecondary // Selected text color
                            : colorGray, // Prevents text overflow
                      ),
                    ),
                  )
                  .toList(),
              value: selectedValue,
              onChanged: (newValue) {
                createFieldBody.value = newValue;
                controller.questionList.refresh();
              },
              buttonStyleData: ButtonStyleData(
                padding: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: borderColor,
                  ),
                  color: white,
                ),
              ),
              iconStyleData: IconStyleData(
                icon: const Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.arrow_drop_down,
                  ),
                ),
                iconSize: 22,
                iconEnabledColor: colorSecondary,
                iconDisabledColor: colorSecondary,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                //width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: white,
                ),
                offset: const Offset(0, -5),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(40),
                  thickness: WidgetStateProperty.all<double>(6),
                  thumbVisibility: WidgetStateProperty.all<bool>(true),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                //height: 100,
                padding:
                    EdgeInsets.only(left: 14, right: 14, top: 0, bottom: 0),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildRadioWidget(
      FeedbackQuestion createFieldBody, String questionNumber) {
    return sharedContainer(
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: buildFormattedQuestionLabel(createFieldBody, questionNumber),
        subtitle: ListView.separated(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: createFieldBody.options?.length ?? 0,
          itemBuilder: (context, index) {
            var option = createFieldBody.options![index];
            return Padding(
              padding: const EdgeInsets.only(top: 0),
              child: InkWell(
                onTap: () {
                  createFieldBody.value = option.value;
                  controller.questionList.refresh();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: CustomTextView(
                        text: option.text ?? "",
                        fontSize: 16,
                        maxLines: 30,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w500,
                        color: createFieldBody.value.toString() ==
                                option.value.toString()
                            ? colorSecondary // Color when selected
                            : colorGray,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    SvgPicture.asset(
                      colorFilter: ColorFilter.mode(
                          createFieldBody.value.toString() ==
                                  option.value.toString()
                              ? colorPrimary
                              : colorGray,
                          BlendMode.srcIn),
                      ImageConstant.icRadioActive,
                      height: 22.v,
                      width: 22.h,
                      color: createFieldBody.value.toString() ==
                              option.value.toString()
                          ? colorPrimary
                          : colorLightGray,
                    )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 15);
          },
        ),
      ),
    );
  }

  Widget _buildTextareaWidget(
      FeedbackQuestion createFieldBody, String questionNumber,
      {required int minLines, required int maxLine}) {
    final TextEditingController textAreaController = TextEditingController();
    textAreaController.text = createFieldBody.value.toString();

    return sharedContainer(
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: buildFormattedQuestionLabel(createFieldBody, questionNumber),
        subtitle: TextFormField(
          textInputAction: TextInputAction.done,
          controller: textAreaController,
          onChanged: (value) {
            createFieldBody.value = textAreaController.text;
          },
          validator: (String? value) {
            if (createFieldBody.rules.toString().contains("required")) {
              if (value!.trim().isEmpty) {
                return "Please enter ${createFieldBody.validationAs.toString().capitalize}";
              }
            }
            return null;
          },
          style: TextStyle(
              fontSize: 14,
              color: colorSecondary,
              fontWeight: FontWeight.normal),
          decoration: AppDecoration.editFieldDecorationArea(
              label: createFieldBody.label ?? "",
              placeHolder: createFieldBody.placeholder ?? "",
              color: colorLightGray),
          minLines: minLines,
          maxLines: maxLine,
        ),
      ),
    );
  }

  Widget _buildCheckboxWidget(
      FeedbackQuestion createFieldBody, String questionNumber) {
    return sharedContainer(
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: buildFormattedQuestionLabel(createFieldBody, questionNumber),
        subtitle: ListView.separated(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: createFieldBody.options?.length ?? 0,
          itemBuilder: (context, index) {
            var option = createFieldBody.options?[index];
            return InkWell(
              onTap: () {
                if (createFieldBody.value.contains(option?.value)) {
                  createFieldBody.value.remove(option?.value);
                } else {
                  createFieldBody.value.add(option?.value);
                }
                controller.questionList.refresh();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: CustomTextView(
                      text: option?.text ?? "",
                      fontSize: 16,
                      maxLines: 30,
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.w500,
                      color: createFieldBody.value.contains(option?.value)
                          ? colorSecondary
                          : colorGray,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  SvgPicture.asset(
                    createFieldBody.value.contains(option?.value)
                        ? ImageConstant.icCheckboxOn
                        : ImageConstant.icCheckboxOff,
                    width: 22,
                    height: 22,
                  )
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 15);
          },
        ),
      ),
    );
  }

  ///start rating widget
  buildRatingWidget(FeedbackQuestion createFieldBody, BuildContext context,
      String questionNumber) {
    return sharedContainer(
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: buildFormattedQuestionLabel(createFieldBody, questionNumber),
        subtitle: RatingBar.builder(
          initialRating: (createFieldBody.value != null &&
                  createFieldBody.value.toString().isNotEmpty)
              ? double.parse(createFieldBody.value.toString())
              : 0.0,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: createFieldBody.options?.length ?? 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          unratedColor: const Color(0xffF9BC34),
          itemBuilder: (context, index) {
            return Icon(
              (index + 1) <=
                      (createFieldBody.value != null &&
                              createFieldBody.value.toString().isNotEmpty
                          ? double.parse(createFieldBody.value.toString())
                          : 0)
                  ? Icons.star
                  : Icons.star_border_outlined,
              color: const Color(0xffF9BC34),
            );
          },
          onRatingUpdate: (rating) {
            createFieldBody.value = rating.toString();
          },
        ),
      ),
    ); //selected of
  }

  ///emoji rating widget
  buildEmojiWidget(FeedbackQuestion createFieldBody, BuildContext context,
      String questionNumber) {
    return sharedContainer(
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: buildFormattedQuestionLabel(createFieldBody, questionNumber),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:
              List.generate(createFieldBody.options?.length ?? 0, (index) {
            var data = createFieldBody.options?[index];
            bool isSelected =
                createFieldBody.value.toString() == data?.value.toString();
            return GestureDetector(
              onTap: () {
                createFieldBody.value = data?.value ?? "";
                controller.update();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      isSelected ? Colors.transparent : colorLightGray,
                      BlendMode.color),
                  child: Text(
                    data?.text ?? "",
                    style: const TextStyle(
                      fontSize: 35,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  buildNumberRating(FeedbackQuestion createFieldBody, BuildContext context,
      String questionNumber) {
    return sharedContainer(
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: buildFormattedQuestionLabel(createFieldBody, questionNumber),
        subtitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: createFieldBody.options?.length ?? 0,
                itemBuilder: (context, index) {
                  var item = createFieldBody.options?[index];
                  return GestureDetector(
                    onTap: () {
                      createFieldBody.value = item?.value;
                      controller.questionList.refresh();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: createFieldBody.value == item?.value
                                  ? colorPrimary
                                  : defaultCheckboxColor)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 11),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              colorFilter: ColorFilter.mode(
                                  createFieldBody.value == item?.value
                                      ? colorPrimary
                                      : colorGray,
                                  BlendMode.srcIn),
                              ImageConstant.icRadioActive,
                              width: 22,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextView(text: item?.text ?? ""),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 6 / 10,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 10),
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextView(
                      text: "Poor", fontWeight: FontWeight.w400, fontSize: 14),
                  CustomTextView(
                      text: "Excellent",
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bottomWidget(BuildContext context) {
    return Container(
      color: white,
      padding: const EdgeInsets.all(0),
      child: CommonMaterialButton(
        color: controller.buttonEnable.value
            ? colorPrimary
            : colorPrimary.withOpacity(0.5),
        onPressed: () async {
          count = 0;
          var formData = <String, dynamic>{};
          for (int index = 0; index < controller.questionList.length; index++) {
            var data = controller.questionList[index];
            if (data.value != null && data.value!.isNotEmpty) {
              if (data.value is List) {
                formData["${data.name}"] = data.value ?? [];
              } else {
                formData["${data.name}"] = data.value ?? "";
              }
            } else {
              if (data.rules == "required") {
                count = count + 1;
              }
              formData["${data.name}"] = "";
            }
          }
          if (count > 0) {
            UiHelper.showFailureMsg(context, "select_required_feedback".tr);
            return;
          }
          var jsonObject = {
            "item_id": controller.itemId,
            "item_type": controller.feedbackType, //event,exhibitor
            "answers": formData
          };
          controller.saveFeedback(requestBody: jsonObject);
        },
        text: "submit".tr,
      ),
    );
  }
}
