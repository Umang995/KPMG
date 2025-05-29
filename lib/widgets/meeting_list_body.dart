import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/meeting/controller/meetingController.dart';
import 'package:dreamcast/widgets/add_calender_widget.dart';
import 'package:dreamcast/widgets/customImageWidget.dart';
import 'package:dreamcast/widgets/button/custom_icon_button.dart';
import 'package:dreamcast/widgets/button/common_material_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../theme/app_colors.dart';
import '../theme/ui_helper.dart';
import '../utils/pref_utils.dart';
import '../view/meeting/model/meeting_model.dart';
import '../view/meeting/view/meeting_details_page.dart';
import '../view/representatives/controller/user_detail_controller.dart';
import 'textview/customTextView.dart';
import 'dash_widget.dart';

class MeetingListBodyWidget extends GetView<MeetingController> {
  Meetings meetingList;
  int size;
  int index;
  bool? isFromDetails;
  final double buttonSize = 45;

  MeetingListBodyWidget(
      this.meetingList, this.size, this.index, this.isFromDetails,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return isFromDetails != null && isFromDetails!
        ? buildDetailBody(context, meetingList, index)
        : buildListBody(context, meetingList, index);
  }

  Widget buildListBody(BuildContext context, Meetings meetings, int index) {
    final startDate = meetings.startDatetime.toString();
    final endDate = meetings.endDatetime.toString();
    final timezone = PrefUtils.getTimezone();

    var mStartDate = UiHelper.getFormattedDateForCompare(
        date: meetings.startDatetime,
        timezone: PrefUtils.getTimezone());
    var mCurrentDate =
        UiHelper.getCurrentDate(timezone: PrefUtils.getTimezone());

    var mEndDate = UiHelper.getFormattedDateForCompare(
        date: meetings.endDatetime,
        timezone: PrefUtils.getTimezone());

    var label = "";
    var color = colorSecondary;
    if (meetings.status == 0) {
      if (meetings.iam == "sender") {
        if (DateTime.parse(mCurrentDate).compareTo(DateTime.parse(mStartDate)) <
            0) {
          label = "Invitation Sent";
          color = colorInvitationSent;
        } else {
          label = "Lapsed";
          color = colorDisabled;
        }
      } else {
        if (DateTime.parse(mCurrentDate).compareTo(DateTime.parse(mStartDate)) <
            0) {
          label = "Invitation Received";
          color = colorInvitationReceived;
        } else {
          label = "Lapsed";
          color = colorLapsed;
        }
      }
    } else if (meetings.status == 1) {
      label = "";
      color = colorSecondary;
      if (DateTime.parse(mCurrentDate).compareTo(DateTime.parse(mStartDate)) >=
              0 &&
          DateTime.parse(mCurrentDate).compareTo(DateTime.parse(mEndDate)) <=
              0) {
        label = "Live";
        color = colorLive;
      } else {
        if (DateTime.parse(mCurrentDate).compareTo(DateTime.parse(mStartDate)) <
            0) {
          label = "Upcoming";
          color = colorUpcoming;
        } else if (DateTime.parse(mCurrentDate)
                .compareTo(DateTime.parse(mStartDate)) >
            0) {
          label = "Ended";
          color = colorEndCompleted;
        } else {
          label = "Upcoming";
          color = colorUpcoming;
        }
      }
    } else if (meetings.status == -1) {
      label = "Declined";
      color = colorDecline;
    }

    return GestureDetector(
      onTap: () async {
        var result =
            await controller.getMeetingDetail(requestBody: {"id": meetings.id});
        if (result["status"]) {
          Get.toNamed(MeetingDetailPage.routeName);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.v),
        padding: EdgeInsets.only(
            left: 15.adaptSize,
            right: 15.adaptSize,
            top: 9.adaptSize,
            bottom: 15.adaptSize),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(15.adaptSize),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, color: color, size: 8.adaptSize),
                    SizedBox(
                      width: 5.adaptSize,
                    ),
                    CustomTextView(
                      text: meetings.completionStatus == "1"
                          ? "completed".tr
                          : meetings.completionStatus == "-1"
                              ? "not_completed".tr
                              : label,
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                (meetings.status == 0 ||
                        meetings.status == -1 ||
                        label.toLowerCase() == "ended" ||
                        label.toLowerCase() == "live")
                    ? const SizedBox()
                    : SizedBox(
                        width: 68.adaptSize,
                        height: 28.adaptSize,
                        child: AddCalenderWidget(
                          onTap: () {
                            Add2Calendar.addEvent2Cal(
                              controller.buildEvent(sessions: meetings),
                            );
                          },
                        ),
                      )
              ],
            ),
            const SizedBox(height: 7),
            CustomTextView(
              text: UiHelper.displayDatetimeSuffix(
                  startDate: startDate, endDate: endDate, timezone: timezone),
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: colorGray,
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    controller.userDetailController.getUserDetailApi(
                        meetings.user?.id ?? "", meetings.user?.role ?? "");
                  },
                  child: CustomImageWidget(
                    imageUrl: meetings.user?.avatar ?? "",
                    shortName: meetings.user?.shortName,
                    size: 36.adaptSize,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 10.adaptSize),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextView(
                        text: meetings.user?.name ?? "",
                        textAlign: TextAlign.start,
                        color: colorSecondary,
                        fontSize: 16,
                        maxLines: 1,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomTextView(
                        text: "${meetings.user?.position ?? ""} "
                            "${meetings.user?.company ?? ""}",
                        textAlign: TextAlign.start,
                        color: colorGray,
                        fontSize: 14,
                        maxLines: 1,
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14.adaptSize,
                  color: colorSecondary,
                ),
              ],
            ),
             Divider(
              height: 20,
              thickness: 0.5,
              color: colorLightGray,
            ),
            Row(
              children: [
                Skeleton.shade(
                    child: SvgPicture.asset(
                  ImageConstant.icLocationSession,
                  height: 15,
                )),
                SizedBox(
                  width: 12.h,
                ),
                CustomTextView(
                  text: meetings.location ?? "",
                  color: colorGray,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
            const SizedBox(height: 2),
            label.toLowerCase() == "lapsed" || label.toLowerCase() == "live"
                ? const SizedBox(
                    height: 0,
                  )
                : label.toLowerCase() == "ended"
                    ? meetings.iam == "sender" &&
                            meetings.completionStatus.toString() == "0"
                        ? CommonMaterialButton(
                            color: colorLightGray,
                            textColor: colorSecondary,
                            height: buttonSize.adaptSize,
                            textSize: 16,
                            weight: FontWeight.w500,
                            text: "mark_meeting_status".tr,
                            onPressed: () {
                              controller.showMarkMeetingDialog(
                                  context: context,
                                  content:
                                      "Are you sure you want to ${"mark_meeting_status".tr} this meeting?",
                                  meetings: meetings,
                                  isFromDetail: isFromDetails);
                            },
                          )
                        : (meetings.completionStatus.toString() == "1" ||
                                meetings.completionStatus.toString() == "-1")
                            ? attendNotAttendWidget(
                                meetings.completionStatus.toString(),
                                meetings.completionMessage?.isNotEmpty ?? false)
                            : const SizedBox(
                                height: 0,
                              )
                    : meetings.iam == "sender"
                        ? senderSideButton(meetings, label, context)
                        : receiverSideButton(meetings, label, context)
          ],
        ),
      ),
    );
  }

  Widget attendNotAttendWidget(String status, bool isNotes) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.v),
      decoration: BoxDecoration(
        color: colorLightGray,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
           CustomTextView(
            text: "Status: ",
            color: colorGray,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          Expanded(
            child: CustomTextView(
              text: status == "1" ? "Attended" : "Not Attended",
              color: colorSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          isNotes
              ? SvgPicture.asset(
                  ImageConstant.status_notes,
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget buildDetailBody(BuildContext context, Meetings meetings, int index) {
    var label = getMeetingLabel(
        meetings, PrefUtils.getTimezone() ?? "Asia/Kolkata");
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.adaptSize),
      padding: EdgeInsets.symmetric(
          vertical: 12.adaptSize, horizontal: 12.adaptSize),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.all(
          Radius.circular(15.adaptSize),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               CustomTextView(
                text: "Meeting with :",
                color: colorGray,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                textAlign: TextAlign.start,
              ),
              (meetings.status == 0 ||
                      meetings.status == -1 ||
                      label.toLowerCase() == "ended" ||
                      label.toLowerCase() == "live")
                  ? const SizedBox()
                  : AddCalenderWidget(
                      onTap: () {
                        Add2Calendar.addEvent2Cal(
                          controller.buildEvent(sessions: meetings),
                        );
                      },
                    )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  controller.userDetailController.getUserDetailApi(
                      meetings.user?.id ?? "", meetings.user?.role ?? "");
                },
                child: CustomImageWidget(
                  imageUrl: meetings.user?.avatar ?? "",
                  shortName: meetings.user?.shortName,
                  size: 45.adaptSize,
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 10.adaptSize),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextView(
                      text: meetings.user?.name ?? "",
                      textAlign: TextAlign.start,
                      color: colorSecondary,
                      fontSize: 16,
                      maxLines: 1,
                      fontWeight: FontWeight.w500,
                    ),
                    CustomTextView(
                      text: "${meetings.user?.position ?? ""} "
                          "${meetings.user?.company ?? ""}",
                      textAlign: TextAlign.start,
                      color: colorGray,
                      fontSize: 14,
                      maxLines: 1,
                      fontWeight: FontWeight.normal,
                    ),
                  ],
                ),
              ),
            ],
          ),
          label.toLowerCase() == "lapsed" || label.toLowerCase() == "live"
              ? SizedBox(
                  height: buttonSize.adaptSize,
                )
              : label.toLowerCase() == "ended"
                  ? meetings.iam == "sender" &&
                          meetings.completionStatus.toString() == "0"
                      ? CommonMaterialButton(
                          color: colorLightGray,
                          textColor: colorSecondary,
                          height: buttonSize.adaptSize,
                          textSize: 16,
                          weight: FontWeight.w500,
                          text: "mark_meeting_status".tr,
                          onPressed: () {
                            controller.showMarkMeetingDialog(
                                context: context,
                                content:
                                    "Are you sure you want to ${"mark_meeting_status".tr} this meeting?",
                                meetings: meetings,
                                isFromDetail: isFromDetails);
                          },
                        )
                      : (meetings.completionStatus.toString() == "1" ||
                              meetings.completionStatus.toString() == "-1")
                          ? attendNotAttendWidget(
                              meetings.completionStatus.toString(),
                              meetings.completionMessage?.isNotEmpty ?? false)
                          : const SizedBox()
                  : meetings.iam == "sender"
                      ? senderSideButton(meetings, label, context)
                      : receiverSideButton(meetings, label, context),
        ],
      ),
    );
  }

  Widget senderSideButton(
      Meetings meetings, String label, BuildContext context) {
    return meetings.status == 0
        ? CommonMaterialButton(
            color: colorLightGray,
            textColor: colorSecondary,
            height: buttonSize.adaptSize,
            textSize: 16,
            weight: FontWeight.w500,
            text: "revoke_request".tr,
            onPressed: () {
              var body = {
                "id": meetings.id,
                "user_id": meetings.user?.id ?? "",
                "status": -2,
                "start_datetime": meetings.startDatetime,
                "end_datetime": meetings.endDatetime
              };
              controller.showActionMeetingDialog(
                  context: context,
                  isFromDetail: isFromDetails,
                  title: "revoke".tr,
                  confirmButtonText: "revoke".tr,
                  logo: ImageConstant.icRevokeRequest,
                  content:
                      "Are you sure you want to ${"revoke".tr} this request?",
                  body: body);
            },
          )
        : meetings.status == 1
            ? Row(
                children: [
                  Expanded(
                    child: CommonMaterialButton(
                      color: colorLightGray,
                      textColor: colorSecondary,
                      height: buttonSize.adaptSize,
                      textSize: 16,
                      weight: FontWeight.w500,
                      svgIcon: "assets/svg/reject.svg",
                      text: "cancel".tr,
                      onPressed: () {
                        var body = {
                          "id": meetings.id,
                          "user_id": meetings.user?.id ?? "",
                          "status": 2,
                          "start_datetime": meetings.startDatetime,
                          "end_datetime": meetings.endDatetime
                        };
                        controller.showActionMeetingDialog(
                            context: context,
                            title: "cancel_meeting".tr,
                            confirmButtonText: "cancel".tr,
                            isFromDetail: isFromDetails,
                            logo: ImageConstant.icCancelRequest,
                            content:
                                "Are you sure you want to ${"cancel".tr} this meeting?",
                            body: body);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: CommonMaterialButton(
                      color: colorLightGray,
                      textColor: colorSecondary,
                      height: buttonSize.adaptSize,
                      textSize: 16,
                      weight: FontWeight.w500,
                      svgIcon: "assets/svg/ic_reset_icon.svg",
                      text: "Reschedule",
                      onPressed: () async {
                        UserDetailController userDetailManager = Get.find();
                        userDetailManager.commonChatMeetingController
                            .showScheduleDialog(
                                context,
                                meetings.user?.id ?? "",
                                meetings.user?.name ?? "",
                                meetings.user?.avatar ?? "",
                                meetings.user?.shortName ?? "",
                                meetings.user?.role ?? "",
                                meetings.id ?? "");
                      },
                    ),
                  )
                ],
              )
            : const SizedBox();
  }

  Widget receiverSideButton(
      Meetings meetings, String label, BuildContext context) {
    return meetings.status == 0
        ? Row(
            children: [
              Expanded(
                child: CommonMaterialButton(
                  color: colorLightGray,
                  textColor: colorSecondary,
                  height: buttonSize.adaptSize,
                  textSize: 16,
                  weight: FontWeight.w500,
                  text: "reject".tr,
                  svgIcon: "assets/svg/reject.svg",
                  // iconHeight: 10,
                  onPressed: () {
                    var body = {
                      "id": meetings.id,
                      "user_id": meetings.user?.id ?? "",
                      "status": -1,
                      "start_datetime": meetings.startDatetime,
                      "end_datetime": meetings.endDatetime
                    };
                    controller.showActionMeetingDialog(
                        context: context,
                        title: "reject_request".tr,
                        confirmButtonText: "reject".tr,
                        isFromDetail: isFromDetails,
                        logo: ImageConstant.icCancelRequest,
                        content:
                            "Are you sure you want to ${"reject".tr} this request?",
                        body: body);
                  },
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: CommonMaterialButton(
                  color: colorLightGray,
                  textColor: colorSecondary,
                  height: buttonSize.adaptSize,
                  textSize: 16,
                  weight: FontWeight.w500,
                  text: "accept".tr,
                  svgIcon: "assets/svg/accept.svg",
                  onPressed: () {
                    var body = {
                      "id": meetings.id,
                      "user_id": meetings.user?.id ?? "",
                      "status": 1,
                      "start_datetime": meetings.startDatetime,
                      "end_datetime": meetings.endDatetime
                    };
                    controller.showActionMeetingDialog(
                        context: context,
                        title: "accept_request".tr,
                        confirmButtonText: "accept".tr,
                        isFromDetail: isFromDetails,
                        logo: ImageConstant.icAcceptRequest,
                        content:
                            "Are you sure you want to ${"accept".tr} this request?",
                        body: body);
                  },
                ),
              )
            ],
          )
        : (meetings.status == 1 && label.toLowerCase() == "upcoming")
            ? Row(
                children: [
                  Expanded(
                    child: CommonMaterialButton(
                      color: colorLightGray,
                      textColor: colorSecondary,
                      height: buttonSize.adaptSize,
                      textSize: 16,
                      weight: FontWeight.w500,
                      text: "cancel".tr,
                      svgIcon: "assets/svg/reject.svg",
                      onPressed: () {
                        var body = {
                          "id": meetings.id,
                          "user_id": meetings.user?.id ?? "",
                          "status": 2,
                          "start_datetime": meetings.startDatetime,
                          "end_datetime": meetings.endDatetime
                        };
                        controller.showActionMeetingDialog(
                            context: context,
                            title: "cancel_meeting".tr,
                            confirmButtonText: "cancel".tr,
                            isFromDetail: isFromDetails,
                            logo: ImageConstant.icCancelRequest,
                            content:
                                "Are you sure you want to ${"cancel".tr} this meeting?",
                            body: body);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: CommonMaterialButton(
                      color: colorLightGray,
                      textColor: colorSecondary,
                      height: buttonSize.adaptSize,
                      textSize: 16,
                      weight: FontWeight.w500,
                      svgIcon: "assets/svg/ic_reset_icon.svg",
                      iconHeight: 14.adaptSize,
                      text: "reschedule".tr,
                      onPressed: () {
                        UserDetailController userDetailManager = Get.find();
                        userDetailManager.commonChatMeetingController
                            .showScheduleDialog(
                                context,
                                meetings.user?.id ?? "",
                                meetings.user?.name ?? "",
                                meetings.user?.avatar ?? "",
                                meetings.user?.shortName ?? "",
                                meetings.user?.role ?? "",
                                meetings.id ?? "");
                      },
                    ),
                  )
                ],
              )
            : const SizedBox();
  }

  String getMeetingLabel(Meetings meetings, String timezone) {
    var mStartDate = UiHelper.getFormattedDateForCompare(
        date: meetings.startDatetime, timezone: timezone);
    var mCurrentDate = UiHelper.getCurrentDate(timezone: timezone);
    var mEndDate = UiHelper.getFormattedDateForCompare(
        date: meetings.endDatetime, timezone: timezone);

    if (meetings.status == 0) {
      if (meetings.iam == "sender") {
        return DateTime.parse(mCurrentDate)
                    .compareTo(DateTime.parse(mStartDate)) <
                0
            ? "Invitation Sent"
            : "Lapsed";
      } else {
        return DateTime.parse(mCurrentDate)
                    .compareTo(DateTime.parse(mStartDate)) <
                0
            ? "Invitation Received"
            : "Lapsed";
      }
    } else if (meetings.status == 1) {
      if (DateTime.parse(mCurrentDate).compareTo(DateTime.parse(mStartDate)) >=
              0 &&
          DateTime.parse(mCurrentDate).compareTo(DateTime.parse(mEndDate)) <=
              0) {
        return "Live";
      } else if (DateTime.parse(mCurrentDate)
              .compareTo(DateTime.parse(mStartDate)) <
          0) {
        return "Upcoming";
      } else {
        return "Ended";
      }
    } else if (meetings.status == -1) {
      return "Declined";
    }

    return "";
  }
}

class LoadingMeetingListBodyWidget extends GetView<MeetingController> {
  LoadingMeetingListBodyWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DashWidget(
                  length: 60.v,
                  dashLength: 3,
                  dashColor: colorGray,
                  direction: Axis.vertical,
                ),
                CustomTextView(
                    text: "21 april 2024",
                    textAlign: TextAlign.center,
                    fontSize: 12.fSize,
                    color: colorGray),
                const Icon(Icons.radio_button_unchecked),
                DashWidget(
                  dashLength: 3,
                  length: 60.v,
                  dashColor: colorGray,
                  direction: Axis.vertical,
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 20,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 9),
            padding: EdgeInsets.symmetric(
                vertical: 14.adaptSize, horizontal: 14.adaptSize),
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: borderColor, width: 0),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, color: colorSecondary, size: 10),
                        SizedBox(
                          width: 6,
                        ),
                        CustomTextView(
                          text: "upcoming",
                          color: colorSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ],
                ),
                 CustomTextView(
                  text: "Hall 1 - Boot no. 2",
                  color: colorGray,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: CustomImageWidget(imageUrl: "", shortName: "Guest"),
                  title:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextView(
                        text: "Guest",
                        textAlign: TextAlign.start,
                        color: colorSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  subtitle:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextView(
                        text: "Guest at dreamcast",
                        textAlign: TextAlign.start,
                        color: colorGray,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: CustomIconButton(
                      decoration: BoxDecoration(
                          color: colorLightGray,
                          border:
                              Border.all(color: Colors.transparent, width: 1),
                          borderRadius: BorderRadius.circular(6)),
                      width: context.width,
                      height: 45.v,
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextView(
                            text: "Cancel",
                            color: colorSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          )
                        ],
                      ),
                      onTap: () {},
                    )),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                        child: CustomIconButton(
                      decoration: BoxDecoration(
                          color: colorLightGray,
                          border:
                              Border.all(color: Colors.transparent, width: 1),
                          borderRadius: BorderRadius.circular(6)),
                      width: context.width,
                      height: 45.v,
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextView(
                            text: "Reschedule",
                            color: colorSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          )
                        ],
                      ),
                    )),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
