import 'dart:convert';

import 'package:get/get.dart';

import '../../api_repository/api_service.dart';
import '../../api_repository/app_url.dart';
import '../../model/common_model.dart';
import '../../theme/ui_helper.dart';

class UserReportController extends GetxController {
  var loading = false.obs;
  var selectedReportOption = 0.obs;

  var commentResign = [
    "Spam or misleading content",
    "Offensive or abusive language",
    "Hate speech or discrimination",
    "Harassment or bullying",
    "False information",
    "My reason is not listed above.",
  ];

  //report post
  Future<void> reportPostApi({required requestBody}) async {
    loading(true);
    final model = CommonModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: requestBody, url: AppUrl.reportToUser),
    ));
    loading(false);
    UiHelper.showSuccessMsg(null, model.message ?? "");
  }
}
