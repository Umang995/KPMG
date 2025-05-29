import 'package:get/get.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../schedule/controller/session_controller.dart';
import 'dart:convert';
import 'package:dreamcast/view/myFavourites/controller/favourite_controller.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../schedule/model/scheduleModel.dart';
import '../../schedule/model/speaker_webinar_model.dart';
import '../../schedule/request_model/session_request_model.dart';

class SessionBookingController extends GetxController {
  var favouriteSessionList = <SessionsData>[].obs;

  var loading = false.obs;
  var isFirstLoading = false.obs;

  FavouriteController favouriteController = Get.find();
  SessionController sessionController = Get.find();
  AuthenticationManager authenticationManager = Get.find();

  SessionRequestModel sessionRequestModel = SessionRequestModel();

  @override
  void onInit() {
    super.onInit();
    getApiData();
  }

  getApiData() async {
    sessionRequestModel = SessionRequestModel(
        page: 1,
        favourite: 0,
        booking: 1,
        filters: RequestFilters(
            text:
                favouriteController.textController.value.text.trim().toString(),
            sort: "ASC",
            params: RequestParams(date: "")));
    getBookmarkSession(isRefresh: false);
  }

  Future<void> getBookmarkSession({required isRefresh}) async {
    if (!isRefresh ?? false) {
      isFirstLoading(true);
    }
    final model = ScheduleModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: sessionRequestModel,
        url: AppUrl.getSession,
      ),
    ));
    sessionController.isBookmarkLoaded(true);

    if (model.status! && model.code == 200) {
      favouriteSessionList.clear();
      favouriteSessionList.addAll(model.body?.sessions ?? []);
      favouriteSessionList.refresh();
      sessionController.userIdsList.clear();
      if (favouriteSessionList.isNotEmpty) {
        sessionController.userIdsList
            .addAll(favouriteSessionList!.map((obj) => obj.id).toList());
        sessionController.getBookmarkIds();
        if (authenticationManager.isLogin()) {
          getSpeakerWebinarList(
              requestBody: {"webinars": sessionController.userIdsList});
        }
      }

      update();
      isFirstLoading(false);
    } else {
      isFirstLoading(false);
    }
  }

  Future<void> getSpeakerWebinarList({required requestBody}) async {
    final model = SpeakerModelWebinarModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: requestBody,
        url: AppUrl.getSpeakerByWebinarId,
      ),
    ));
    if (model.status! && model.code == 200 && model.body != null) {
      for (var session in favouriteSessionList) {
        var matchingSpeakerData = model.body!
            .firstWhere((speakerData) => speakerData.id == session.id);
        if (matchingSpeakerData != null) {
          session.speakers?.addAll(matchingSpeakerData.sessionSpeaker ?? []);
          favouriteSessionList.refresh();
        }
      }
    } else {
      print(model.code.toString());
    }
  }
}
