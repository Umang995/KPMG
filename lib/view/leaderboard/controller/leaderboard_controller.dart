import 'dart:convert';
import 'package:dreamcast/view/leaderboard/model/my_rank_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../model/criteriaModel.dart';
import '../model/leaderboard_team_model.dart';
import '../model/my_criteria_model.dart';

class LeaderboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var loading = false.obs;
  var isFirstLoadRunning = false.obs;
  var actionName = [];
  late TabController _tabController;
  var criteria = <Criteria>[].obs;
  var myCriteria = <Criteria>[].obs;
  var team = <LeaderboardUsers>[].obs;
  var topThree = <LeaderboardUsers>[].obs;
  int teamsLength = 0;

  TabController get tabController => _tabController;
  final selectedTabIndex = 0.obs;

  Future<void> getRankApi({required bool isRefresh}) async {
    try {
      isFirstLoadRunning(true);
      var response = await apiService.dynamicPostRequest(
          body: {"page_id": 1},
          url: "${AppUrl.baseURLV1}/leaderboard/getRanks");
      LeaderboardTeamModel? model =
          LeaderboardTeamModel.fromJson(json.decode(response));
      if (model!.status! && model!.code == 200) {
        team.clear();
        topThree.clear();
        topThree.addAll(model.body?.top3 ?? []);
        team.addAll(model.body?.users ?? []);
        teamsLength = model.body?.users?.length ?? 0;
        await getMyRankApi(isRefresh: isRefresh, leaderboardModel: model);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getMyRankApi(
      {required bool isRefresh,
      required LeaderboardTeamModel leaderboardModel}) async {
    try {
      var response = await apiService.dynamicPostRequest(
          body: {"page_id": 1},
          url: "${AppUrl.baseURLV1}/leaderboard/getMyRank");
      MyRankModel? model = MyRankModel.fromJson(json.decode(response));
      isFirstLoadRunning(false);
      if (model!.status! && model!.code == 200) {
        if (model.body != null && model.body?.totalPoints != null) {
          print(model.body?.id);
          if (model.body?.id != null) {
            team.insert(0, model.body!);
          }
        }
      }
    } catch (e) {
      isFirstLoadRunning(false);
      print(e.toString());
    } finally {
      isFirstLoadRunning(false);
    }
  }

  //all criteria
  Future<void> getCriteriaApi({required bool isRefresh}) async {
    try {
      isFirstLoadRunning(true);
      var response = await apiService.dynamicPostRequest(
          body: {"page_id": 1},
          url: "${AppUrl.baseURLV1}/leaderboard/getCriteria");
      CriteriaModel? model = CriteriaModel.fromJson(json.decode(response));
      isFirstLoadRunning(false);
      if (model!.status! && model!.code == 200) {
        criteria.clear();
        criteria.addAll(model?.criteria ?? []);
        criteria.refresh();
      }
    } catch (e) {
      print(e.toString());
    }
    loading(false);
  }

  //my criteria
  Future<void> getMyCriteriaApi({required bool isRefresh}) async {
    try {
      isFirstLoadRunning(true);
      var response = await apiService.dynamicPostRequest(
          body: {"page_id": 1},
          url: "${AppUrl.baseURLV1}/leaderboard/getMyCriteria");
      MyCriteriaModel? model = MyCriteriaModel.fromJson(json.decode(response));
      isFirstLoadRunning(false);
      if (model!.status! && model!.code == 200) {
        myCriteria.clear();
        myCriteria.addAll(model.body ?? []);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void onInit() {
    super.onInit();
    getRankApi(isRefresh: false);
    _tabController = TabController(vsync: this, length: 3);
    if (Get.arguments != null && Get.arguments["tab_index"] != null) {
      _tabController.index = Get.arguments["tab_index"];
      selectedTabIndex.value = Get.arguments["tab_index"];
      loading(true);
    }
  }
}
