import 'dart:convert';

import 'package:dreamcast/api_repository/app_url.dart';
import 'package:dreamcast/model/common_model.dart';
import 'package:dreamcast/view/askQuestion/model/ask_question_model.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../theme/ui_helper.dart';
import '../../exhibitors/model/bookmark_common_model.dart';
import '../model/ask_save_model.dart';

class AskQuestionController extends GetxController {
  var loading = false.obs;
  var isFirstLoading = false.obs;

  String? image;
  String? name;
  String? itemId = "";
  String? message;
  String? itemType = "";
  String? hallNo = "";
  String? boothNo = "";
  var questionList = <AskQuestion>[].obs;
  bool? buttonStatus = true;

  final AuthenticationManager authenticationManager = Get.find();
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      name = Get.arguments["name"];
      itemId = Get.arguments["item_id"];
      itemType = Get.arguments["item_type"];
      image = Get.arguments["image"];
      hallNo = Get.arguments["hall_no"];
      boothNo = Get.arguments["booth_no"];
    }
    getAskQuestionList();
  }

  ///get the question for the event, session and exhibitor
  Future getAskQuestionList() async {
    if (!authenticationManager.isLogin()) {
      return;
    }
    var requestBody = {"item_id": itemId, "item_type": itemType};
    isFirstLoading(true);

    final model = AskQuestionModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: requestBody,
          url: "${AppUrl.askQuestion}/getQuestions"),
    ));
    isFirstLoading(false);
    if (model.status! && model.code == 200) {
      questionList.clear();
      questionList.addAll(model.data ?? []);
      message = model.message ?? "";
      buttonStatus = true;
      questionList.refresh();
    } else {
      message = model.message ?? "";
      buttonStatus = false;
    }
  }

  ///save the question for the event, session and exhibitor
  Future<Map<String, dynamic>> saveQuestion(dynamic question) async {
    var result = <String, dynamic>{};
    var body = {"question": question, "item_id": itemId, "item_type": itemType};
    loading(true);
    final model = SaveQuestionModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: body,
          url: "${AppUrl.askQuestion}/saveQuestions"),
    ));
    getAskQuestionList();
    loading(false);
    if (model.status! && model.code == 200) {
      result = {
        "message": model.body?.message ?? model.message,
        "status": true,
      };
    } else {
      result = {
        "message": model.body?.message ?? model.message,
        "status": false
      };
    }
    print("Ask question api response: $result");
    return result;
  }
}
