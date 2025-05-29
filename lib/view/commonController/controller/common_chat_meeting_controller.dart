import 'dart:convert';

import 'package:dreamcast/view/commonController/view/common_sechdule_meeting_dialog.dart';
import 'package:dreamcast/view/meeting/controller/meetingController.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/image_constant.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/dialog/custom_animated_dialog_widget.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../exhibitors/model/bookmark_common_model.dart';
import '../../meeting/model/create_time_slot.dart';
import '../../meeting/model/timeslot_model.dart';
import '../../meeting/view/meeting_dashboard_page.dart';
import '../../representatives/model/chat_request_model.dart';
import '../../representatives/model/chat_request_status_model.dart';

class CommonChatMeetingController extends GetxController {
  var isFavLoading = false.obs;
  var isChatLoading = false.obs;
  var isLoading = false.obs;
  var chatStatusRequest = 0.obs;
  var chatStatusBody = ChatRequestBody().obs;
  var allowedDate = "";

  var timeslotsList = <MeetingSlots>[].obs;
  var slots = <CreatedSlots>[].obs;
  var selectedSort = "ASC".obs;

  //used in meeting section dialog
  var selectedLocation = "Networking lounge".obs;
  var bookingAppointmentList = [];

  final AuthenticationManager _authenticationManager = Get.find();
  AuthenticationManager get authenticationManager => _authenticationManager;

  @override
  void onInit() {
    super.onInit();
  }

  Future<Map> sendChatRequest(
      {required BuildContext context, required dynamic body}) async {
    var result = {};
    isLoading(true);

    final model = ChatRequestModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: body,
        url: AppUrl.sendChatRequest,
      ),
    ));

    isLoading(false);
    if (model.status! && model.code == 200) {
      result = {"status": true, "message": model.body?.message ?? ""};
      chatStatusRequest(model.body?.room?.status ?? 0);
    } else {
      result = {"status": false, "message": model.message ?? ""};
    }
    return result;
  }

  Future<void> getChatRequestStatus(
      {required bool isShow, required String receiverId}) async {
    var body = {"receiver_id": receiverId};
    //isLoading(isShow);
    isChatLoading(true);

    final model = ChatRequestStatusModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: body,
        url: AppUrl.getChatRequestStatus,
      ),
    ));
    isChatLoading(false);
    if (model.status! && model.code == 200) {
      if (model.body?.id != null) {
        chatStatusBody(model.body!);
        chatStatusRequest(model.body?.status ?? 0);
      } else {
        chatStatusBody(ChatRequestBody());
        chatStatusRequest(model.body?.status ?? 0);
      }
    } else {
      chatStatusRequest(model.body?.status ?? 0);
    }
  }

  //get the slot for make the booking
  Future<void> getTimeslotsList({required requestBody}) async {
    isLoading(true);
    final model = TimeslotModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: requestBody,
        url: AppUrl.userMeetingSlotsGet,
      ),
    ));

    isLoading(false);
    if (model.status! && model.code == 200) {
      if (model.body?.allowedDate != null &&
          model.body!.allowedDate!.isNotEmpty) {
        allowedDate = model.body?.allowedDate ?? "";
      } else {
        allowedDate = "";
      }
      bookingAppointmentList.clear();
      bookingAppointmentList.addAll(model.body?.appointments ?? []);
      getFilterSLotDate(model.body?.meetingSlots ?? []);
    } else {
      allowedDate = "";
    }
    // return result;
  }

  getFilterSLotDate(List<MeetingSlots> list) {
    timeslotsList.clear();
    if (allowedDate.isEmpty) {
      timeslotsList.addAll(list);
    } else {
      for (var meetingsSlot in list) {
        if (allowedDate ==
            UiHelper.getAllowDateFormat(
                date: meetingsSlot.startDatetime ?? "",
                timezone: PrefUtils.getTimezone())) {
          timeslotsList.add(meetingsSlot);
        }
      }
    }
  }
  //filter the slot as per time

  showScheduleDialog(BuildContext context, String userId, String name,
      String avatar, String shortName, String role, String rescheduleId) async {
    if (Get.isRegistered<MeetingController>()) {
      MeetingController meetingController = Get.find();
      meetingController.loading(true);
    }
    isLoading(true);
    await getTimeslotsList(requestBody: {"user_id": userId});
    if (Get.isRegistered<MeetingController>()) {
      MeetingController meetingController = Get.find();
      meetingController.loading(false);
    }
    isLoading(false);
    //its used for remove the expired data form calender list
    var newSlotData = UiHelper.filterMeetingSlotDate(
        PrefUtils.getTimezone() ?? "", timeslotsList);
    timeslotsList.clear();
    timeslotsList.addAll(newSlotData);
    var result = await Get.to(CommonScheduleMeetingDialog(
      duration:
          timeslotsList.isNotEmpty ? newSlotData[0].duration.toString() : "",
      personName: name,
      profileImg: avatar,
      shortName: shortName,
    ));

    if (result != null) {
      var requestBody = {
        "receiver_id": userId,
        "receiver_name": name,
        "receiver_role": role,
        "start_datetime": result["date_time"],
        "duration": result["duration"].toString(),
        "location": "In Person",
        "message": result["message"].toString(),
        "rescheduled_id": rescheduleId,
      };
      debugPrint("requestBody-:$requestBody");
      if (rescheduleId != null && rescheduleId.isNotEmpty) {
        if (Get.isRegistered<MeetingController>()) {
          MeetingController meetingController = Get.find();
          meetingController.rescheduleMeeting(
              body: requestBody, context: context);
        }
      } else {
        bookAppointment(body: requestBody, context: context);
      }
    }
  }

  //used to create the booking
  Future<void> bookAppointment(
      {dynamic body, required BuildContext context}) async {
    isLoading(true);

    final model = BookmarkCommonModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: body, url: AppUrl.bookAppointment),
    ));

    isLoading(false);
    if (model.status! && model.code == 200) {
      await Get.dialog(
          barrierDismissible: false,
          CustomAnimatedDialogWidget(
            title: "success_action".tr,
            logo: ImageConstant.icSuccessAnimated,
            description: model.message ?? "",
            buttonAction: "myMeetings".tr,
            buttonCancel: "cancel".tr,
            isHideCancelBtn: true,
            onCancelTap: () {},
            onActionTap: () async {
              print("1212 ${Get.isRegistered<MeetingController>()}");
              if (Get.isRegistered<MeetingController>()) {
                var controller = Get.find<MeetingController>();
                // Check if a route named '/details' is in the stack
                controller.selectedTabIndex(1);
                controller.invitesStatus.value = "sent";
                await controller.getMeetingList(requestBody: {
                  "page": "1",
                  "filters": {"status": controller.invitesStatus.value},
                }, isRefresh: false);
                UiHelper.reopenMeetingPageIfExists(MyMeetingList.routeName);
              } else {
                Get.toNamed(MyMeetingList.routeName,
                    arguments: {"tab_index": 1});
              }
            },
          ));
    } else {
      UiHelper.showFailureMsg(context, model?.message ?? "");
    }
  }
}
