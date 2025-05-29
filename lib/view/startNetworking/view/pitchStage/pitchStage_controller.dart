import 'dart:async';
import 'dart:convert';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:dreamcast/view/exhibitors/controller/exhibitorsController.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../api_repository/api_service.dart';
import '../../../../api_repository/app_url.dart';
import '../../../../theme/ui_helper.dart';
import '../../../beforeLogin/globalController/authentication_manager.dart';
import '../../../dashboard/dashboard_controller.dart';
import '../../../exhibitors/model/bookmark_common_model.dart';
import '../../../myFavourites/model/BookmarkIdsModel.dart';
import '../../../schedule/controller/session_controller.dart';
import '../../../schedule/model/scheduleModel.dart';
import '../../../schedule/view/watch_session_page.dart';

class PitchStageController extends GetxController {
  final DashboardController dashboardController = Get.find();
  late final AuthenticationManager _authManager;
  ScrollController tabScrollController = ScrollController();
  TextEditingController textController = TextEditingController();
  AuthenticationManager get authManager => _authManager;
  var loading = false.obs;
  var isFirstLoading = true.obs;

  var sessionList = <SessionsData>[].obs;
  var menuParentItemList = <MenuItem>[];
  final mSessionDetailBody = SessionsData().obs;

  SessionsData get sessionDetailBody => mSessionDetailBody.value;

  var userIdsList = <dynamic>[];
  //used for match the ids to user ids
  var bookMarkIdsList = <dynamic>[].obs;

  //reaction
  var clapReaction = false.obs;
  var hootReaction = false.obs;
  var likeReaction = false.obs;

  //pagination of session
  late bool hasNextPage;
  late int _pageNumber;
  var isFirstLoadRunning = false.obs;
  var isLoadMoreRunning = false.obs;
  ScrollController scrollController = ScrollController();
  dynamic newRequestBody = {};
  SessionController sessionController = Get.find();

  @override
  void onInit() {
    super.onInit();
    _authManager = Get.find();
    getApiData();
  }

  ///get the initial list of session
  getApiData() async {
    if (await UiHelper.isNoInternet()) {
      return;
    }
    await getSessionList(requestBody: {
      "page": "1",
      "filters": {
        "text": "",
        "sort": "ASC",
        "params": {
          "date": "",
          "pitch_stage": true,
        },
      }
    }, isRefresh: false);
  }

  ///get session list data
  Future<void> getSessionList({required requestBody, bool? isRefresh}) async {
    if (await UiHelper.isNoInternet()) {
      return;
    }
    _pageNumber = 1;
    hasNextPage = false;
    newRequestBody = requestBody;
    isFirstLoading(true);
    final model = ScheduleModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: requestBody,
        url: AppUrl.getSession,
      ),
    ));

    if (model.status! && model.code == 200) {
      sessionList.clear();
      sessionList.addAll(model.body?.sessions ?? []);
      userIdsList.clear();
      userIdsList.addAll(model.body!.sessions!.map((obj) => obj.id).toList());
      getBookmarkIds();
      hasNextPage = model.body?.hasNextPage ?? false;
      _pageNumber = _pageNumber + 1;
      if (hasNextPage) {
        _loadMore();
      }
    } else {
      print(model.code.toString());
    }
    isFirstLoading(false);
  }

  ///get more session data
  Future<void> _loadMore() async {
    scrollController.addListener(() async {
      if (hasNextPage == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunning.value == false &&
          scrollController.position.maxScrollExtent ==
              scrollController.position.pixels) {
        isLoadMoreRunning(true);
        newRequestBody["page"] = _pageNumber.toString();
        try {

          final model = ScheduleModel.fromJson(json.decode(
            await apiService.dynamicPostRequest(
              body: newRequestBody,
              url: AppUrl.getSession,
            ),
          ));


          if (model.status! && model.code == 200) {
            hasNextPage = model.body!.hasNextPage!;
            _pageNumber = _pageNumber + 1;
            sessionList.addAll(model.body?.sessions ?? []);
            userIdsList.clear();
            userIdsList
                .addAll(model.body!.sessions!.map((obj) => obj.id).toList());
            getBookmarkIds();
            update();
          }
        } catch (e) {
          debugPrint(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }

  ///open the session detail by session controller
  openSessionDetail({required sessionId}) async {
    loading(true);
    var apiResult = await sessionController
        .getSessionDetail(requestBody: {"id": sessionId});
    loading(false);
    if (apiResult["status"]) {
      if (bookMarkIdsList.contains(sessionController.sessionDetailBody.id)) {
        sessionController.sessionDetailBody.bookmark =
            sessionController.sessionDetailBody.id;
      }
      var result = await Get.to(() => WatchDetailPage(
            sessions: sessionController.sessionDetailBody,
          ));
      if (result != null && result) {
        getApiData();
      } else {}
    }
  }

  ///open the session watch detail by session controller
  watchSessionPage({required sessionId}) async {
    SessionController controller = Get.find();
    loading(true);
    var result =
        await controller.getSessionDetail(requestBody: {"id": sessionId});
    loading(false);
    if (result["status"]) {
      if (bookMarkIdsList.contains(sessionController.sessionDetailBody.id)) {
        sessionController.sessionDetailBody.bookmark =
            sessionController.sessionDetailBody.id;
      }
      Get.to(() => WatchDetailPage(
            sessions: controller.sessionDetailBody,
          ));
    }
  }

  ///bookmark the session
  Future<void> bookmarkToSession({required requestBody}) async {
    final model = BookmarkCommonModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: requestBody, url: AppUrl.commonBookmarkApi),
    ));

    if (model.status! && model.code == 200) {
      if (model.body?.id != null && model.body!.id!.isNotEmpty) {
        bookMarkIdsList.add(requestBody["favourite_id"]);
        sessionController.sessionDetailBody.bookmark =
            requestBody["favourite_id"];
        UiHelper.showSuccessMsg(null, model.body?.message ?? "");
      } else {
        bookMarkIdsList.remove(requestBody["favourite_id"]);
        sessionController.sessionDetailBody.bookmark = "";
        UiHelper.showFailureMsg(null, model.body?.message ?? "");
      }
    }
  }

  ///add  the event to calender list
  Event buildEvent({Recurrence? recurrence, required SessionsData sessions}) {
    return Event(
      title: sessions.label ?? "",
      description: sessions.description ?? "",
      location: '',
      startDate: DateTime.parse(sessions.startDatetime ?? ""),
      endDate: DateTime.parse(sessions.endDatetime ?? ""),
      allDay: false,
      iosParams: const IOSParams(reminder: Duration(minutes: 40)),
      recurrence: recurrence,
    );
  }

  ///add  the event to calender list
  Event buildEventDetail(
      {Recurrence? recurrence, required SessionsData sessions}) {
    return Event(
      title: sessions.label ?? "",
      description: sessions.description ?? "",
      location: '',
      startDate: DateTime.parse(sessions.startDatetime ?? ""),
      endDate: DateTime.parse(sessions.endDatetime ?? ""),
      allDay: false,
      iosParams: const IOSParams(reminder: Duration(minutes: 40)),
      recurrence: recurrence,
    );
  }

  ///get the bookmark ids
  Future<void> getBookmarkIds() async {
    if (!authManager.isLogin()) {
      return;
    }
    try {
      final model = BookmarkIdsModel.fromJson(json.decode(
        await apiService.dynamicPostRequest(
            body: {"items": userIdsList, "item_type": ""},
            url: AppUrl.commonListByItemIds),
      ));

      if (model.status! && model.code == 200) {
        bookMarkIdsList.clear();
        bookMarkIdsList.addAll(model.body!.map((obj) => obj.id).toList());
      }
    } catch (exception) {
      debugPrint(exception.toString());
    }
  }
}
