import 'dart:convert';

import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/view/home/controller/home_controller.dart';
import 'package:dreamcast/view/representatives/controller/user_detail_controller.dart';
import 'package:dreamcast/view/schedule/controller/session_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../model/recommended_model.dart';

class ForYouController extends GetxController {
  late final AuthenticationManager _authManager;
  AuthenticationManager get authManager => _authManager;
  var recommendedList = <dynamic>[].obs;
  var selectedMatchIndex = 0.obs;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  var isFirstLoading = false.obs;
  var isLoading = false.obs;
  var isLoadMoreRunning = false.obs;
  final HomeController _homeController = Get.find();

  @override
  void onInit() {
    super.onInit();
    _authManager = Get.find();
    dependencies();
  }

  void dependencies() {
    Get.lazyPut(() => SessionController(), fenix: true);
    Get.lazyPut(() => UserDetailController(), fenix: true);
  }

  ///call the api from  the dashbaord controller
  initApiCall() {
    getAiMatchesLinkedin(isRefresh: true);
  }

  Future<void> getAiMatchesLinkedin({required isRefresh}) async {
    if (await UiHelper.isNoInternet() ||
        AuthenticationManager().isLogin() == false) {
      return;
    }
    isFirstLoading(isRefresh);

    final model = RecommendedModel.fromJson(json.decode(
      await apiService.dynamicGetRequest(url: AppUrl.recommended),
    ));

    isFirstLoading(false);
    if (model.status! && model.code == 200) {
      if (model.body?.items != null && model.body!.items!.isNotEmpty) {
        recommendedList.clear();
        recommendedList.addAll(model.body!.items ?? []);
        _homeController.refresh();
        _homeController.recommendedForYouList.clear();
        _homeController.recommendedForYouList.addAll(recommendedList);
      }
    }
  }
}
