import 'dart:convert';

import 'package:dreamcast/model/common_model.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/dialog/custom_animated_dialog_widget.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../model/question_list_model.dart';

class FeedbackController extends GetxController {
  var loading = false.obs;
  var isLoadMoreRunning = false.obs;
  var questionList = <FeedbackQuestion>[].obs;
  final textController = TextEditingController().obs;
  final selectedTabIndex = 0.obs;
  ScrollController scrollController = ScrollController();
  var buttonEnable = false.obs;

  late final AuthenticationManager _authManager;

  var itemId = "";
  var feedbackType = "";
  var tempOptionList = <FeedbackOptions>[].obs;
  var message = "";
  var currentRating = 0.obs;

  var openDropDown = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments["type"] != null) {
      itemId = Get.arguments["item_id"];
      feedbackType = Get.arguments["type"];
      getQuestionList(body: {"item_id": itemId, "item_type": feedbackType});
    } else {
      itemId = "";
      feedbackType = "event";
      getQuestionList(body: {"item_id": "", "item_type": feedbackType});
    }
    _authManager = Get.find();
  }

  ///common used for the  webinar and event
  Future<void> getQuestionList({required dynamic body}) async {
    loading(true);
    final model = QuestionListModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: body,
        url: "${AppUrl.feedbackQuestions}/getQuestions",
      ),
    ));
    loading(false);
    if (model.status! && model.code == 200) {
      message = model.message ?? "";
      questionList.clear();
      questionList.addAll(model.body ?? []);
    } else {
      message = model.message ?? "";
      questionList.clear();
    }
  }

  ///common used for the the session webinar and event
  Future<void> saveFeedback({dynamic requestBody}) async {
    loading(true);

    final model = CommonModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: requestBody, url: "${AppUrl.feedbackQuestions}/saveQuestions"),
    ));

    loading(false);
    if (model.status! && model.code == 200) {
      await Get.dialog(
          barrierDismissible: false,
          CustomAnimatedDialogWidget(
            title: "success_action".tr,
            logo: ImageConstant.icSuccessAnimated,
            description: model.body?.message ?? model.message,
            buttonAction: "okay".tr,
            buttonCancel: "cancel".tr,
            isHideCancelBtn: true,
            onCancelTap: () {},
            onActionTap: () async {
              Get.back();
            },
          ));
    } else {
      UiHelper.showFailureMsg(null, model.message ?? "");
    }
  }

  isValidateForm() {
    int count = 0;
    var formData = <String, dynamic>{};
    for (int index = 0; index < questionList.length; index++) {
      var data = questionList[index];
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
    buttonEnable(count > 0 ? false : true);
  }
}
