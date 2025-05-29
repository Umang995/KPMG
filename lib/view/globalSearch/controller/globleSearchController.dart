import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/view/breifcase/controller/common_document_controller.dart';
import 'package:dreamcast/view/exhibitors/controller/exhibitorsController.dart';
import 'package:dreamcast/view/representatives/controller/networkingController.dart';
import 'package:dreamcast/view/schedule/controller/session_controller.dart';
import 'package:dreamcast/view/speakers/controller/speakerNetworkController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api_repository/api_service.dart';
import '../../../../api_repository/app_url.dart';
import '../../../theme/ui_helper.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../exhibitors/model/exibitorsModel.dart';
import '../../representatives/model/user_model.dart';
import '../../representatives/request/network_request_model.dart';
import '../../schedule/model/scheduleModel.dart';
import '../../schedule/request_model/session_request_model.dart';
import '../../speakers/model/speakersModel.dart';

class GlobalSearchController extends GetxController {
   final AuthenticationManager _authManager=Get.find();
  AuthenticationManager get authManager => _authManager;
  var selectedSearchTag = "Exhibitors".obs;
  var selectedSearchIndex = 0.obs;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final textController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    tabIndexAndSearch(false);
  }

  tabIndexAndSearch(bool isRefresh) {
    switch (selectedSearchTag.value) {
      case "Exhibitors":
        BoothController controller = Get.find();
        controller.bootRequestModel.filters?.text =
            textController.value.text.trim() ?? "";
        controller.bootRequestModel.favourite = 0;
        controller.bootRequestModel.filters?.notes = false;
        controller.bootRequestModel.filters?.sort = "";
        controller.bootRequestModel.filters?.params = {};
        controller.getExhibitorsList(isRefresh: isRefresh);
        selectedSearchIndex(0);
        break;
      case "Networking":
        selectedSearchIndex(3);
        NetworkingController controller = Get.find();
        controller.networkRequestModel.filters?.text =
            textController.value.text.trim() ?? "";
        controller.networkRequestModel.favorite = 0;
        controller.networkRequestModel.filters?.isBlocked = false;
        controller.networkRequestModel.filters?.notes = false;
        controller.networkRequestModel.filters?.sort = "";
        controller.networkRequestModel.filters?.params = {};
        controller.getAttendeeList(isRefresh: isRefresh);
        selectedSearchIndex(1);
        break;
      case "Sessions":
        selectedSearchIndex(2);
        SessionController controller = Get.find();
        controller.sessionRequestModel.filters?.text =
            textController.value.text.trim() ?? "";
        controller.sessionRequestModel.filters?.params =
            RequestParams(date: "");
        controller.getSessionList(isRefresh: isRefresh);

        break;
      case "Speakers":
        selectedSearchIndex(3);
        SpeakerNetworkController controller = Get.find();
        controller.networkRequestModel.filters?.text =
            textController.value.text.trim() ?? "";
        controller.networkRequestModel.favorite = 0;
        controller.networkRequestModel.filters?.isBlocked = false;
        controller.networkRequestModel.filters?.notes = false;
        controller.networkRequestModel.filters?.sort = "";
        controller.networkRequestModel.filters?.params = {};
        controller.getUserListApi(isRefresh: isRefresh);
        break;
    }
  }

  /* ///search load user list
  Future<void> getSearchUserApi({bool? isRefresh}) async {
    _pageNumber = 1;
    networkRequestModel.page = 1;
    networkRequestModel.role = MyConstant.networking;
    if (await UiHelper.isNoInternet()) {
      return;
    }
    isFirstLoadRunning(true);
    try {
      RepresentativeModel? model = await apiService.getUserList(
          networkRequestModel, "${AppUrl.usersListApi}/search");
      isFirstLoadRunning(false);
      if (model.status! && model.code == 200) {
        userList.clear();
        if (model.body?.representatives != null &&
            model.body!.representatives!.isNotEmpty) {
          userList.addAll(model.body!.representatives ?? []);
          hasNextPage = model.body?.hasNextPage ?? false;
          if (hasNextPage) {
            _pageNumber = _pageNumber + 1;
            _loadMoreUser();
          }
        }
      } else {
        debugPrint(model.code.toString());
      }
    } catch (exception) {
      debugPrint(exception.toString());
      isFirstLoadRunning(false);
    }
  }

  ///add pagination for attendee
  Future<void> _loadMoreUser() async {
    userScrollController.addListener(() async {
      if (hasNextPage == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunning.value == false &&
          userScrollController.position.maxScrollExtent ==
              userScrollController.position.pixels) {
        isLoadMoreRunning(true);
        networkRequestModel.page = _pageNumber;
        try {
          RepresentativeModel? model = await apiService.getUserList(
              networkRequestModel, "${AppUrl.usersListApi}/search");
          if (model.status! && model.code == 200) {
            hasNextPage = model.body!.hasNextPage!;
            _pageNumber = _pageNumber + 1;
            userList.addAll(model.body!.representatives ?? []);
            update();
          }
        } catch (e) {
          debugPrint(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }

  ///search load speaker list
  Future<void> getSearchSpeakerApi({bool? isRefresh}) async {
    _pageNumber = 1;
    networkRequestModel.page = 1;
    networkRequestModel.role = MyConstant.speakers;
    if (await UiHelper.isNoInternet()) {
      return;
    }
    isFirstLoadRunning(true);
    try {
      SpeakersModel? model = await apiService.getSpeakersApi(
          networkRequestModel, "${AppUrl.usersListApi}/search");
      isFirstLoadRunning(false);
      if (model.status! && model.code == 200) {
        speakerList.clear();
        if (model.body?.representatives != null &&
            model.body!.representatives!.isNotEmpty) {
          speakerList.addAll(model.body!.representatives ?? []);
          hasNextPage = model.body?.hasNextPage ?? false;
          if (hasNextPage) {
            _pageNumber = _pageNumber + 1;
            _loadMoreSpeaker();
          }
        }
      } else {
        debugPrint(model.code.toString());
      }
    } catch (exception) {
      debugPrint(exception.toString());
      isFirstLoadRunning(false);
    }
  }

  ///add pagination for speaker
  Future<void> _loadMoreSpeaker() async {
    speakerScrollController.addListener(() async {
      if (hasNextPage == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunning.value == false &&
          speakerScrollController.position.maxScrollExtent ==
              speakerScrollController.position.pixels) {
        isLoadMoreRunning(true);
        networkRequestModel.page = _pageNumber;
        try {
          SpeakersModel? model = await apiService.getSpeakersApi(
              networkRequestModel, "${AppUrl.usersListApi}/search");
          if (model.status! && model.code == 200) {
            hasNextPage = model.body!.hasNextPage!;
            _pageNumber = _pageNumber + 1;
            speakerList.addAll(model.body!.representatives ?? []);
            update();
          }
        } catch (e) {
          debugPrint(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }

  ///load get exhibitor list
  Future<void> getSearchExhibitorsApi({bool? isRefresh}) async {
    _pageNumber = 1;
    if (await UiHelper.isNoInternet()) {
      return;
    }
    var requestBody = {
      "filters": {
        "text": textController.value.text ?? "",
        "sort": "",
        */ /*ASC , DESC*/ /*
        "params": {"interest": []}
      },
      "featured": 0,
      "favourite": 0,
      "page": 1
    };
    isFirstLoadRunning(true);
    try {
      ExhibitorsModel? model = await apiService.getExhibitorsList(
          requestBody, "${AppUrl.exhibitorsListApi}/search");
      isFirstLoadRunning(false);
      if (model.status! && model.code == 200) {
        exhibitorsMatchesList.clear();
        exhibitorsMatchesList.value = model.body!.exhibitors ?? [];
        hasNextPage = model.body?.hasNextPage ?? false;
        if (hasNextPage) {
          _pageNumber = _pageNumber + 1;
          _loadMoreExhibitor(requestBody);
        }
      } else {
        debugPrint(model.code.toString());
      }
    } catch (exception) {
      debugPrint(exception.toString());
      isFirstLoadRunning(false);
    }
  }

  ///add pagination for exhibitor
  Future<void> _loadMoreExhibitor(Map<String, Object> newRequestBody) async {
    exhibitorScrollController.addListener(() async {
      if (hasNextPage == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunning.value == false &&
          exhibitorScrollController.position.maxScrollExtent ==
              exhibitorScrollController.position.pixels) {
        isLoadMoreRunning(true);
        newRequestBody["page"] = _pageNumber.toString();
        try {
          ExhibitorsModel? model = await apiService.getExhibitorsList(
              newRequestBody, "${AppUrl.exhibitorsListApi}/search");
          if (model.status! && model.code == 200) {
            hasNextPage = model.body!.hasNextPage!;
            _pageNumber = _pageNumber + 1;
            exhibitorsMatchesList.addAll(model.body!.exhibitors ?? []);
            update();
          }
        } catch (e) {
          debugPrint(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }

  ///search session data
  Future<void> getSearchSessionApi({bool? isRefresh}) async {
    _pageNumber = 1;
    var requestBody = {
      "page": 1,
      "filters": {
        "text": textController.value.text ?? "",
        "sort": "ASC",
        "params": {
          "date": "",
          "keywords": []
          //  "status":1
        }
      },
      "favourite": 0
    };
    isFirstLoadRunning(true);
    ScheduleModel? model =
        await apiService.getSessionList(requestBody, AppUrl.getSession);
    isFirstLoadRunning(false);
    if (model.status! && model.code == 200) {
      sessionList.clear();
      sessionList.addAll(model.body?.sessions ?? []);
      hasNextPage = model.body?.hasNextPage ?? false;
      if (hasNextPage) {
        _pageNumber = _pageNumber + 1;
        _loadMoreSession(requestBody);
      }
      if (model.body?.sessions != null) {
        userIdsList.addAll(model.body!.sessions!.map((obj) => obj.id).toList());
      }
      getBookmarkIds();
      update();
    } else {
      debugPrint(model.code.toString());
    }
    try {} catch (exception) {
      debugPrint(exception.toString());
      isFirstLoadRunning(false);
    }
  }

  final CommonDocumentController commonController = Get.find();

  Future<void> getBookmarkIds() async {
    if (userIdsList.isEmpty) {
      return;
    }
    if (Get.isRegistered<CommonDocumentController>()) {
      CommonDocumentController commonController = Get.find();
      bookMarkIdsList.value = await commonController.getCommonBookmarkIds(
          items: userIdsList, itemType: "webinar");
    } else {
      CommonDocumentController commonController =
          Get.put(CommonDocumentController());
      bookMarkIdsList.value = await commonController.getCommonBookmarkIds(
          items: userIdsList, itemType: "webinar");
    }
  }

  ///add the pagination to session
  Future<void> _loadMoreSession(Map<String, Object> newRequestBody) async {
    sessionScrollController.addListener(() async {
      if (hasNextPage == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunning.value == false &&
          sessionScrollController.position.maxScrollExtent ==
              sessionScrollController.position.pixels) {
        isLoadMoreRunning(true);
        newRequestBody["page"] = _pageNumber.toString();
        try {
          ScheduleModel? model = await apiService.getSessionList(
              newRequestBody, AppUrl.getSession);
          if (model.status! && model.code == 200) {
            hasNextPage = model.body!.hasNextPage!;
            _pageNumber = _pageNumber + 1;
            sessionList.addAll(model.body?.sessions ?? []);
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
  }*/
}
