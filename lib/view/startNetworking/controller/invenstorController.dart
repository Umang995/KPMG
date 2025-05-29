import 'dart:convert';

import 'package:dreamcast/api_repository/app_url.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/dialog_constant.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/dialog/custom_animated_dialog_widget.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../exhibitors/model/bookmark_common_model.dart';
import '../../meeting/model/create_time_slot.dart';
import '../model/startNetworkingFilter.dart';
import '../model/startNetworkingModel.dart';
import '../model/startNetworkingSlot.dart';
import '../view/dialog/investor_slot_dialog.dart';

class InvestorController extends GetxController {
  late final AuthenticationManager _authenticationManager;

  AuthenticationManager get authenticationManager => _authenticationManager;

  bool hasNextPage = false;
  int _pageNumber = 1;
  var isFirstLoadRunning = false.obs;
  var isLoadMoreRunning = false.obs;
  var isLoading = false.obs;
  final textController = TextEditingController().obs;

  ScrollController scrollController = ScrollController();

  var investorList = <dynamic>[].obs;
  var selectedSort = "ASC".obs;
  var investorBody = UserAspireData().obs;

  dynamic newRequestBody = {};
  var startNetworkingFilterData = StartNetworkingFilterBody().obs;
  var title = "";
  var isInvestor = false;

  var timeslotsList = <MeetingSlots>[].obs;
  var slots = <CreatedSlots>[].obs;
  var bookingAppointmentList = [];
  var meetingDisable = false.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      title = Get.arguments["title"] ?? "";
      isInvestor = Get.arguments["isInvestor"] ?? false;
    }
    _authenticationManager = Get.find();
    getAspireList(
        requestBody: {"page": "1", "type": isInvestor ? "investor" : "mentor"},
        isRefresh: false);
    super.onInit();
  }

  /// get the user list
  Future<void> getAspireList({required requestBody, required isRefresh}) async {
    _pageNumber = 1;
    hasNextPage = false;
    newRequestBody = requestBody;
    isFirstLoadRunning(true);
    final model = StartNetworkingModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: requestBody,
          url: AppUrl.searchAspireList),
    ));
    if (model.status! && model.code == 200) {
      investorList.clear();
      investorList.addAll(model.body!.representatives!);
      hasNextPage = model.body?.hasNextPage ?? false;
      _pageNumber = 2;
      if (hasNextPage) {
        _loadMore();
      }
      isFirstLoadRunning(false);
    } else {
      isFirstLoadRunning(false);
    }
  }

  ///load more data
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
          final model = StartNetworkingModel.fromJson(json.decode(
            await apiService.dynamicPostRequest(
                body: newRequestBody,
                url: AppUrl.searchAspireList),
          ));
          if (model.status! && model.code == 200) {
            hasNextPage = model.body!.hasNextPage!;
            _pageNumber = _pageNumber + 1;
            investorList.addAll(model.body!.representatives!);
            update();
          }
        } catch (e) {
          print(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }

  ///get the user detail by id
  Future<void> getUserDetail(String id) async {
    var requestBody = {
      "page": "1",
      "id": id,
      "type": isInvestor ? "investor" : "mentor"
    };
    isLoading(true);

    final model = StartNetworkingModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: requestBody,
          url: AppUrl.searchAspireList),
    ));


    isLoading(false);
    if (model.status! && model.code == 200) {
      if (model.body?.representatives != null &&
          model.body!.representatives!.isNotEmpty) {
        investorBody(model.body!.representatives![0]);
      }
    } else {
      debugPrint(model.code.toString());
    }
  }

  ///open dialog to book the slot
  showScheduleDialog(BuildContext context) async {
    isLoading(true);
    await startNetworkingSlotList(requestBody: {
      "user_id": investorBody.value.id ?? "",
      "type": isInvestor ? "Investor" : "Mentor"
    });
    isLoading(false);
    //its used for remove the expired data form calender list
    var newSlotData = filterMeetingSlotDate(
        PrefUtils.getTimezone() ?? "", timeslotsList);
    timeslotsList.clear();
    timeslotsList.addAll(newSlotData);

    var result = await Get.to(InvestorSlotDialog(
      duration:
          timeslotsList.isNotEmpty ? timeslotsList[0].duration.toString() : "",
      personName: investorBody.value.name ?? "",
      profileImg: investorBody.value.avatar ?? "",
      shortName: investorBody.value.shortName ?? "",
    ));

    if (result != null) {
      var requestBody = {
        "receiver_id": investorBody.value.id ?? "",
        "receiver_name": investorBody.value.name ?? "",
        "receiver_role": investorBody.value.category ?? "",
        "start_datetime": result["date_time"],
        "duration": result["duration"].toString(),
        "location": "Booth",
        "rescheduled_id": "",
        "type": isInvestor ? "Investor" : "Mentor",
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
    isLoading(true);
    final model = StartNetworkingSlot.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: requestBody,
          url: AppUrl.bookAspireAppointmentUrl),
    ));
    isLoading(false);
    if (model.status! && model.code == 200) {
      bookingAppointmentList.clear();
      bookingAppointmentList.addAll(model.body?.appointments ?? []);
      timeslotsList(model.body?.meetingSlots ?? []);
      if (model.body?.senderMaxLimit > 0 || model.body?.receiverMaxLimit >= 5) {
        meetingDisable(true);
      } else {
        meetingDisable(false);
      }
    } else {
      UiHelper.showFailureMsg(null, model.body?.message ?? "");
    }
  }

  /// this is request for book the seat after selected slot
  Future<void> bookAppointment(
      {dynamic body, required BuildContext context}) async {
    isLoading(true);
    final model = BookmarkCommonModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: body,
          url: AppUrl.bookAspireAppointmentUrl),
    ));
    isLoading(false);
    if (model.body!.status! && model.code == 200) {
      await Get.dialog(
          barrierDismissible: false,
          CustomAnimatedDialogWidget(
            title: "",
            logo: ImageConstant.icSuccessAnimated,
            description: model.body!.message ?? "",
            buttonAction: "okay".tr,
            buttonCancel: "cancel".tr,
            isHideCancelBtn: true,
            onCancelTap: () {},
            onActionTap: () async {
              Get.back();
            },
          ));
    } else {
      UiHelper.showFailureMsg(context, model.body!.message ?? "");
    }
  }

  @override
  void onClose() {
    super.onClose();
    isFirstLoadRunning(false);
    isLoading(false);
  }
}
