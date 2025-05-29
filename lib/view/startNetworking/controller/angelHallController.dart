import 'dart:async';
import 'dart:convert';
import 'package:dreamcast/routes/my_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/dialog_constant.dart';
import '../../../utils/image_constant.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/dialog/custom_animated_dialog_widget.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../dashboard/dashboard_controller.dart';
import '../../exhibitors/model/bookmark_common_model.dart';
import '../../meeting/model/create_time_slot.dart';
import '../model/angelAllyModel.dart';
import '../model/startNetworkingSlot.dart';
import '../view/angelAlly/angel_details_page.dart';
import '../view/dialog/investor_slot_dialog.dart';

class AngelHallController extends GetxController {
  final DashboardController dashboardController = Get.find();

  late final AuthenticationManager _authManager;
  ScrollController tabScrollController = ScrollController();

  AuthenticationManager get authManager => _authManager;
  var loading = false.obs;
  var isFirstLoading = false.obs;
  final _angelBody = AngelBody().obs;
  AngelBody get sessionDetailBody => _angelBody.value;
  var sessionList = <AngelBody>[].obs;
  //pagination of session
  late bool hasNextPage;
  late int _pageNumber;
  var isFirstLoadRunning = false.obs;
  var isLoadMoreRunning = false.obs;
  ScrollController scrollController = ScrollController();
  dynamic newRequestBody = {};

  var timeslotsList = <MeetingSlots>[].obs;
  var slots = <CreatedSlots>[].obs;
  var bookingAppointmentList = [];

  @override
  void onInit() {
    super.onInit();
    _authManager = Get.find();
    getApiData();
  }

  getApiData() async {
    await getAngelAllyHallList(requestBody: {
      "page": "1",
      "type": MyConstant.angelAlly,
    }, isRefresh: false);
  }

  ///get hall list data
  Future<void> getAngelAllyHallList(
      {required requestBody, bool? isRefresh}) async {
    isFirstLoading(true);
    if (await UiHelper.isNoInternet()) {
      isFirstLoading(false);
      return;
    }
    _pageNumber = 1;
    hasNextPage = false;
    newRequestBody = requestBody;


    final model = AngelAllyModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: requestBody,
          url: AppUrl.searchAspireList),
    ));

    isFirstLoading(false);
    if (model.status! && model.code == 200) {
      sessionList.clear();
      sessionList.addAll(model.body?.sessions ?? []);
      hasNextPage = model.body?.hasNextPage ?? false;
      _pageNumber = _pageNumber + 1;
      if (hasNextPage) {
        getAngelAllyLoadMore();
      }
    } else {
      print(model.code.toString());
    }
  }

  ///get more hall data
  Future<void> getAngelAllyLoadMore() async {
    scrollController.addListener(() async {
      if (hasNextPage == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunning.value == false &&
          scrollController.position.maxScrollExtent ==
              scrollController.position.pixels) {
        isLoadMoreRunning(true);
        newRequestBody["page"] = _pageNumber.toString();
        try {
          final responseModel = AngelAllyModel.fromJson(json.decode(
            await apiService.dynamicPostRequest(
                body: newRequestBody,
                url: AppUrl.searchAspireList),
          ));

          if (responseModel.status! && responseModel.code == 200) {
            hasNextPage = responseModel.body!.hasNextPage!;
            _pageNumber = _pageNumber + 1;
            sessionList.addAll(responseModel.body?.sessions ?? []);
          }
        } catch (e) {
          print(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }

  ///get the detail of page by id
  Future<void> getAngelHallDetail(sessionId) async {
    loading(true);
    var payloadBody = {
      "page": "1",
      "id": sessionId,
      "type": MyConstant.angelAlly,
    };
    final responseModel = AngelAllyModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: payloadBody,
          url: AppUrl.searchAspireList),
    ));
    loading(false);
    if (responseModel.status! && responseModel.code == 200) {
      _angelBody(responseModel.body?.sessions?[0]);
      if (_angelBody.value.id != null) {
        Get.to(AngelAllyDetailPage(
          sessions: _angelBody.value,
        ));
      }
    }
  }

  ///open dialog to book the slot
  showScheduleDialog(BuildContext context) async {
    loading(true);
    await startNetworkingSlotList(requestBody: {
      "user_id": sessionDetailBody.id ?? "",
      "type": "Angel Ally",
    });
    loading(false);

    //its used for remove the expired data form calender list
    var newSlotData = filterMeetingSlotDate(
        PrefUtils.getTimezone() ?? "", timeslotsList);
    timeslotsList.clear();
    timeslotsList.addAll(newSlotData);

    var result = await Get.to(AngelSlotDialog(
      duration:
      timeslotsList.isNotEmpty ? timeslotsList[0].duration.toString() : "",
      personName: sessionDetailBody.label ?? "",
      profileImg: "",
      shortName: "",
    ));

    if (result != null) {
      var requestBody = {
        "receiver_id": sessionDetailBody.id ?? "",
        "receiver_name": sessionDetailBody.label ?? "",
        "receiver_role": "session",
        "start_datetime": result["date_time"],
        "duration": result["duration"].toString(),
        "location": "Booth",
        "rescheduled_id": "",
        "type": "Angel Ally",
        "message": result["message"].toString(),
      };
      debugPrint("requestBody-:$requestBody");
      bookAppointment(body: requestBody, context: context);
    }
  }

  static List<MeetingSlots> filterMeetingSlotDate(
      String timezone, List<MeetingSlots> slotDateList) {
    List<MeetingSlots> newSlotDate = [];
    print(timezone);
    var mCurrentDate = UiHelper.getCurrentDate(timezone: timezone);
    for (var slotData in slotDateList) {
      DateTime startDate = DateTime.parse(UiHelper.getFormattedDateForCompare(
          date: slotData.endDatetime, timezone: timezone));

      DateTime dt1 = DateTime.parse(mCurrentDate);
      if (dt1.isBefore(startDate)) {
        newSlotDate.add(slotData);
        print("DT1 is before DT2");
      } else {
        print("DT1 is After DT2");
      }
    }
    return newSlotDate;
  }

  ///this is used for the get the timeslot
  Future<void> startNetworkingSlotList({required requestBody}) async {
    loading(true);
    final model = StartNetworkingSlot.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: requestBody,
          url: AppUrl.getAspireUserSlot),
    ));
    loading(false);
    if (model.status! && model.code == 200) {
      bookingAppointmentList.clear();
      bookingAppointmentList.addAll(model.body?.appointments ?? []);
      timeslotsList(model.body?.meetingSlots ?? []);
    }
    else{
      UiHelper.showFailureMsg(null, model.body?.message??"");
    }
  }

  /// this is request for book the seat after selected slot
  Future<void> bookAppointment(
      {dynamic body, required BuildContext context}) async {
    loading(true);
    final model = BookmarkCommonModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: body,
          url: AppUrl.bookAspireAppointmentUrl),
    ));
    loading(false);
    if (model.body!.status! && model.code == 200) {
      Future.delayed(const Duration(seconds: 1), () async {
        await Get.dialog(
            barrierDismissible: false,
            CustomAnimatedDialogWidget(
              title: "",
              logo: ImageConstant.icSuccessAnimated,
              description: model.body!.message??"",
              buttonAction: "okay".tr,
              buttonCancel: "cancel".tr,
              isHideCancelBtn: true,
              onCancelTap: () {},
              onActionTap: () async {
                Get.back();
              },
            ));
      });
    } else {
      UiHelper.showFailureMsg(context, model.body!.message ?? "");
    }
  }
}
