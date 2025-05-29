import 'dart:convert';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/view/representatives/controller/user_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/dialog/custom_animated_dialog_widget.dart';
import '../../../widgets/dialog/custom_dialog_widget.dart';
import '../../../widgets/dialog/markMeetingDialog.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../exhibitors/model/bookmark_common_model.dart';
import '../model/meeting_detail_model.dart';
import '../model/meeting_filter_model.dart';
import '../model/meeting_model.dart';

class MeetingController extends GetxController {
  var loading = false.obs;
  var isFirstLoadRunning = false.obs;
  final _meetingDetailBody = Meetings().obs;

  var meetingList = <Meetings>[].obs;

  var confirmFilterItem = <Options>[].obs;
  var invitesFilterItem = <Options>[].obs;

  //manage the tag wise
  var confirmStatus = "all_meeting".obs;
  var invitesStatus = "received".obs;
  var countBadge = 0.obs;

  late final AuthenticationManager _authManager;

  AuthenticationManager get authManager => _authManager;

  Meetings get meetingDetailBody => _meetingDetailBody.value;

  //temp is not used
  var meetingFilterList = <MeetingFilters>[].obs;
  var dateObject = MeetingFilters().obs;
  var selectedOption = Options(name: "", id: "").obs;
  late UserDetailController userDetailController;

  //both are used for mark the meeting.
  var selectedIndex = 1.obs;

  var selectedTabIndex = 0.obs;
  final TextEditingController textAreaController = TextEditingController();

  final GlobalKey<RefreshIndicatorState> refreshCtrConfirmed =
      GlobalKey<RefreshIndicatorState>();

  final GlobalKey<RefreshIndicatorState> refreshCtrInvited =
      GlobalKey<RefreshIndicatorState>();

  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  bool cancelRequestDetail = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    userDetailController = Get.isRegistered<UserDetailController>()
        ? Get.find()
        : Get.put(UserDetailController());
    _authManager = Get.find();
    if (Get.arguments != null) {
      selectedTabIndex(Get.arguments?["tab_index"] ?? 0);
    }
    getMeetingListFilter(tabName: MyConstant.confirmed);
    await getMeetingListFilter(tabName: MyConstant.invitees);
    getMeetingApi();
    // dependencies();
  }

  void dependencies() {
    //Get.put<UserDetailController>(UserDetailController());
    Get.lazyPut(() => UserDetailController(), fenix: true);
    /*this is used for the reschedule the meeting*/
  }

  getMeetingApi() async {
    await getMeetingList(requestBody: {
      "page": "1",
      "filters": {
        "status": selectedTabIndex.value == 0
            ? confirmStatus.value
            : invitesStatus.value
      },
    }, isRefresh: false);
  }

  Future<void> getMeetingList(
      {required requestBody, required isRefresh}) async {
    if (!isRefresh) {
      isFirstLoadRunning(true);
    }

    final model = MeetingModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: requestBody,
        url: AppUrl.userMeetingsSearch,
      ),
    ));

    if (model.status! && model.code == 200) {
      meetingList.clear();
      meetingList.addAll(model.body?.meetings ?? []);
      countBadge(meetingList.length);
      update();
    } else {
      print(model.code.toString());
    }
    isFirstLoadRunning(false);
  }

  Future<Map> getMeetingListFilter({tabName}) async {
    var result = {};
    isFirstLoadRunning(true);


    final model = MeetingFilterModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: {"type": tabName},
        url: AppUrl.userMeetingFilter,
      ),
    ));
    isFirstLoadRunning(false);
    if (model.status! && model.code == 200) {
      meetingFilterList.clear();
      meetingFilterList.addAll(model.body?.filters ?? []);
      if (meetingFilterList.isNotEmpty) {
        if (tabName == MyConstant.confirmed) {
          confirmFilterItem.addAll(meetingFilterList[0].options ?? []);
          confirmStatus.value = confirmFilterItem[0].id ?? "";
        } else if (tabName == MyConstant.invitees) {
          invitesFilterItem.addAll(meetingFilterList[0].options ?? []);
          invitesStatus.value = invitesFilterItem[0].id ?? "";
          if (selectedTabIndex.value == 1) {
            invitesStatus(invitesFilterItem[1].id);
          }
        }
      }
      result = {"status": true};
    } else {
      result = {"status": false};
    }
    return result;
  }

  Future<Map> getMeetingDetail({required requestBody, isRefresh}) async {
    print("loading ${isRefresh ?? true}");
    print("loading ${requestBody}");
    print("loading ${cancelRequestDetail}");
    cancelRequestDetail = false;
    print("loading ${cancelRequestDetail}");

    var result = {};
    loading(isRefresh ?? true);

    final model = MeetingDetailModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: requestBody,
        url: AppUrl.userMeetingDetail,
      ),
    ));
    loading(false);
    if (model.status! && model.code == 200) {
      _meetingDetailBody(model.body);
      result = {
        "status": cancelRequestDetail
            ? false
            : _meetingDetailBody.value.id != null
                ? true
                : false,
        "message": model.message
      };
    } else {
      result = {"status": false, "message": model.message};
    }
    return result;
  }

  /*accept and reject the request of meeting*/
  Future<Map> actionAgainstRequest({required requestBody}) async {
    var result = {};
    loading(true);

    final model = BookmarkCommonModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: requestBody, url: AppUrl.actionAgainstRequest),
    ));

    loading(false);
    if (model.status! && model.code == 200) {
      result = {"status": true, "message": model.message ?? ""};
    } else {
      result = {"status": false, "message": model.message ?? ""};
    }
    return result;
  }

  /*mark request of meeting*/
  Future<Map> actionMeetingComplete({required requestBody}) async {
    var result = {};
    loading(true);

    final model = BookmarkCommonModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: requestBody, url: AppUrl.markMeetingStatus),
    ));

    loading(false);
    if (model.status! && model.code == 200) {
      result = {"status": true, "message": model.message ?? ""};
    } else {
      result = {"status": false, "message": model.message ?? ""};
    }
    return result;
  }

  ///save the event in date calender
  Event buildEvent({Recurrence? recurrence, required sessions}) {
    return Event(
      title: sessions?.user?.name ?? "",
      description:
          "${AppUrl.appName} Meeting with ${sessions?.user?.name ?? ""}",
      location: '',
      startDate: DateTime.parse(sessions?.startDatetime ?? ""),
      endDate: DateTime.parse(sessions?.endDatetime ?? ""),
      allDay: false,
      iosParams: const IOSParams(reminder: Duration(minutes: 40)),
      recurrence: recurrence,
    );
  }

  void showActionMeetingDialog(
      {required context,
      required content,
      required body,
      required title,
      required logo,
      required confirmButtonText,
      required isFromDetail}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogWidget(
          logo: logo,
          title: title,
          description: content,
          buttonAction: "Yes, $confirmButtonText",
          buttonCancel: "go_back".tr,
          onCancelTap: () {},
          onActionTap: () async {
            var result = await actionAgainstRequest(requestBody: body);
            if (result["status"]) {
              await Get.dialog(
                  barrierDismissible: false,
                  CustomAnimatedDialogWidget(
                    title: "",
                    logo: ImageConstant.icSuccessAnimated,
                    description: result['message'],
                    buttonAction: "okay".tr,
                    buttonCancel: "cancel".tr,
                    isHideCancelBtn: true,
                    onCancelTap: () {},
                    onActionTap: () async {
                      if (isFromDetail) {
                        getMeetingDetail(requestBody: {"id": body["id"]});
                      }
                      if (selectedTabIndex.value == 0) {
                        refreshCtrConfirmed.currentState?.show();
                      } else if (selectedTabIndex.value == 1) {
                        refreshCtrInvited.currentState?.show();
                      }
                      //Get.back();
                    },
                  ));
            } else {
              UiHelper.showFailureMsg(context, result["message"]);
            }
          },
        );
      },
    );
  }

  void showMarkMeetingDialog(
      {required context,
      required content,
      required meetings,
      required isFromDetail}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MarkMeetingDialog(
          title: "confirmation".tr,
          meeting: meetings,
          buttonAction: "confirm".tr,
          buttonCancel: "cancel".tr,
          onCancelTap: () {},
          onActionTap: () async {
            var body = {
              "id": meetings.id,
              "user_id": meetings.user?.id ?? "",
              "status": selectedIndex.value,
              "message": textAreaController.text ?? "",
            };
            var result = await actionMeetingComplete(requestBody: body);
            if (result["status"]) {
              await Get.dialog(
                  barrierDismissible: false,
                  CustomAnimatedDialogWidget(
                    title: "",
                    logo: ImageConstant.icSuccessAnimated,
                    description: result['message'],
                    buttonAction: "okay".tr,
                    buttonCancel: "cancel".tr,
                    isHideCancelBtn: true,
                    onCancelTap: () {},
                    onActionTap: () async {
                      if (isFromDetail) {
                        getMeetingDetail(requestBody: {"id": body["id"]});
                      }
                      if (selectedTabIndex.value == 0) {
                        refreshCtrConfirmed.currentState?.show();
                      } else if (selectedTabIndex.value == 1) {
                        refreshCtrInvited.currentState?.show();
                      }
                    },
                  ));
            } else {
              UiHelper.showFailureMsg(context, result["message"]);
            }
          },
        );
      },
    );
  }

  Future<void> rescheduleMeeting(
      {dynamic body, required BuildContext context}) async {
    loading(true);
    final model = BookmarkCommonModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: body, url: AppUrl.bookAppointment),
    ));
    loading(false);
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
              refreshKey.currentState?.show();
              if (selectedTabIndex.value == 0) {
                refreshCtrConfirmed.currentState?.show();
              } else if (selectedTabIndex.value == 1) {
                refreshCtrInvited.currentState?.show();
              }
            },
          ));
    } else {
      UiHelper.showFailureMsg(context, model?.message ?? "");
    }
  }

  @override
  void dispose() {
    super.dispose();
    cancelRequestDetail = false;
  }
}
