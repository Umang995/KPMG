import 'dart:convert';

import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/view/exhibitors/controller/exhibitorsController.dart';
import 'package:dreamcast/view/schedule/controller/session_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../dashboard/dashboard_controller.dart';
import '../../exhibitors/model/bookmark_common_model.dart';
import '../../exhibitors/model/exibitorsModel.dart';
import '../../exhibitors/model/product_list_model.dart';
import '../../myFavourites/model/BookmarkIdsModel.dart';
import '../../representatives/controller/user_detail_controller.dart';
import '../../representatives/model/user_model.dart';
import '../../schedule/model/scheduleModel.dart';
import '../../schedule/model/speaker_webinar_model.dart';
import '../../speakers/controller/speakersController.dart';
import '../model/best_for_you_data_model.dart';

class AiMatchController extends GetxController {
  late final AuthenticationManager _authManager;
  AuthenticationManager get authManager => _authManager;

  final textController = TextEditingController().obs;

  var aiUserList = <dynamic>[].obs;
  var aiSpeakerList = <dynamic>[].obs;
  var aiExhibitorsList = <Exhibitors>[].obs;
  var aiSessionList = <dynamic>[].obs;

  ScrollController exibitorScrollController = ScrollController();
  ScrollController userScrollController = ScrollController();

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final String title = 'Home Title';
  var isFirstLoading = false.obs;
  var isLoading = false.obs;
  var isLoadMoreRunning = false.obs;

  var tabList = <String>[].obs;
  final DashboardController _dashboardController = Get.find();
  DashboardController get dashboardController => _dashboardController;
  //its manage from dashboard controller
  var recommendationTabIndex = 0.obs;

  ///used for the open the detail page.
  UserDetailController userDetailController = Get.find();
  SessionController sessionController = Get.find();

  SpeakersDetailController speakersController =
      Get.put(SpeakersDetailController());
  BoothController bootController = Get.put(BoothController());

  @override
  void onInit() {
    super.onInit();
    _authManager = Get.find();
    createTab();
  }

  Future<void> createTab() async {
    tabList.clear();
    tabList.add("attendee".tr);
    tabList.add("exhibitors".tr);
    tabList.add("speakers".tr);
    tabList.add("allSession".tr);
    getDataByIndexPage(dashboardController.selectedAiMatchIndex.value);
  }

  void getDataByIndexPage(int index) {
    dashboardController.selectedAiMatchIndex(index);
    switch (index) {
      case 0:
        getAiMatchesUser({
          "page": "1",
          "role": "user",
          "favourite": 0,
          "filters": {"text": textController.value.text.trim()}
        });
        break;
      case 1:
        getAiExhibitorsList({
          "page": "1",
          "filters": {"text": textController.value.text.trim()}
        });
        break;
      case 2:
        getAiMatchesSpeaker({
          "page": "1",
          "role": MyConstant.speakers,
          "favourite": 0,
          "filters": {"text": textController.value.text.trim()}
        });
        break;
      case 3:
        getAiSessionList({
          "page": "1",
          "favourite": 0,
          "filters": {
            "type": "ai_session",
            "text": textController.value.text.trim()
          }
        });
        break;
    }
  }

  /// done load user list
  Future<void> getAiMatchesUser(dynamic requestBody) async {
    if (!authManager.isLogin()) {
      return;
    }
    isFirstLoading(true);
    try {
      final model = RepresentativeModel.fromJson(json.decode(
        await apiService.dynamicPostRequest(
          body: requestBody,
          url: "${AppUrl.usersListApi}/aiSearch",
        ),
      ));

      isFirstLoading(false);
      if (model.status! && model.code == 200) {
        aiUserList.clear();
        if (model.body?.representatives != null &&
            model.body!.representatives!.isNotEmpty) {
          userDetailController.clearDefaultList();
          aiUserList.clear();
          aiUserList.addAll(model.body!.representatives!);
          userDetailController.userIdsList.clear();
          userDetailController.userIdsList.addAll(
              model.body!.representatives!.map((obj) => obj.id).toList());
          aiUserList.refresh();
          isFirstLoading(false);
          userDetailController.getBookmarkAndRecommendedByIds();
        }
      } else {
        print(model?.code.toString());
      }
    } catch (exception) {
      isFirstLoading(false);
    }
  }

  Future<void> getAiMatchesSpeaker(dynamic requestBody) async {
    if (!authManager.isLogin()) {
      return;
    }
    isFirstLoading(true);
    try {

      final model = RepresentativeModel.fromJson(json.decode(
        await apiService.dynamicPostRequest(
          body: requestBody,
          url: "${AppUrl.usersListApi}/aiSearch",
        ),
      ));
      isFirstLoading(false);
      if (model.status! && model.code == 200) {
        aiSpeakerList.clear();
        if (model.body?.representatives != null &&
            model.body!.representatives!.isNotEmpty) {
          speakersController.clearDefaultList();
          aiSpeakerList.clear();
          aiSpeakerList.addAll(model.body!.representatives!);
          speakersController.userIdsList.clear();
          speakersController.userIdsList.addAll(
              model.body!.representatives!.map((obj) => obj.id).toList());
          aiSpeakerList.refresh();
          isFirstLoading(false);
          speakersController.getBookmarkAndRecommendedByIds();
        }
      } else {
        print(model?.code.toString());
      }
    } catch (exception) {
      isFirstLoading(false);
    }
  }

  Future<void> getAiExhibitorsList(dynamic body) async {
    if (!authManager.isLogin()) {
      return;
    }
    isFirstLoading(true);
    try {
      final model = ExhibitorsModel.fromJson(json.decode(
        await apiService.dynamicGetRequest(
          url: "${AppUrl.exhibitorsListApi}/aiSearch",
        ),
      ));
      isFirstLoading(false);
      if (model.status! && model.code == 200) {
        aiExhibitorsList.clear();
        aiExhibitorsList.value = model.body?.exhibitors ?? [];
        bootController.userIdsList.clear();
        bootController.userIdsList
            .addAll(model.body?.exhibitors?.map((obj) => obj.id) ?? []);
        // Fetch bookmarks and recommendations
        bootController.getBookmarkAndRecommendedByIds();
      }
    } catch (e) {
      isFirstLoading(false);
    } finally {
      isFirstLoading(false);
    }
  }

  Future<void> getAiSessionList(dynamic requestBody) async {
    if (await UiHelper.isNoInternet() || !authManager.isLogin()) {
      return;
    }
    isFirstLoading(true);
    final model = ScheduleModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: requestBody,
        url: AppUrl.getSession,
      ),
    ));
    if (model.status == true && model.code == 200) {
      aiSessionList.clear();
      aiSessionList.addAll(model.body?.sessions ?? []);
      sessionController.userIdsList.clear();
      if (model.body?.sessions != null) {
        sessionController.userIdsList
            .addAll(model.body!.sessions!.map((obj) => obj.id).toList());
      }
      sessionController.getBookmarkIds();
      if (authManager.isLogin()) {
        getSpeakerWebinarList();
      }
    } else {
      print(model.code.toString());
    }
    isFirstLoading(false);
  }

  ///get the panelist of session.
  Future<void> getSpeakerWebinarList() async {
    if (sessionController.userIdsList.isEmpty) {
      return;
    }

    var requestBody = {"webinars": sessionController.userIdsList};

    final model = SpeakerModelWebinarModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: requestBody,
        url: AppUrl.getSpeakerByWebinarId,
      ),
    ));

    if (model.status! && model.code == 200) {
      for (var session in aiSessionList) {
        var matchingSpeakerData = model.body!
            .firstWhere((speakerData) => speakerData.id == session.id);
        if (matchingSpeakerData != null) {
          session.speakers = [];
          session.speakers?.addAll(matchingSpeakerData.sessionSpeaker ?? []);
          aiSessionList.refresh();
        }
      }
    } else {
      print(model.code.toString());
    }
  }
}
