import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/view/meeting/controller/meetingController.dart';
import 'package:dreamcast/widgets/meeting_list_body.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/image_constant.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../representatives/controller/user_detail_controller.dart';
import '../model/meeting_model.dart';

class MeetingDetailPage extends GetView<MeetingController> {
  MeetingDetailPage({Key? key}) : super(key: key);
  static const routeName = "/MeetingDetailPage";
  final AuthenticationManager _authManager = Get.find();
  UserDetailController repController = Get.find();
  var actionDone = false.obs;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        height: 72.v,
        leadingWidth: 45.h,
        leading: AppbarLeadingImage(
          imagePath: ImageConstant.imgArrowLeft,
          margin: EdgeInsets.only(
            left: 7.h,
            top: 3,
            // bottom: 12.v,
          ),
          onTap: () {
            Get.back();
          },
        ),
        title: ToolbarTitle(title: "meetings_detail".tr),
      ),
      body: Container(
        height: context.height,
        width: context.width,
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        child: GetX<MeetingController>(
          builder: (controller) {
            final startDate =
                controller.meetingDetailBody.startDatetime.toString();
            final endDate = controller.meetingDetailBody.endDatetime.toString();
            final timezone = PrefUtils.getTimezone();
            return Stack(
              children: [
                RefreshIndicator(
                  key: controller.refreshKey,
                  triggerMode: RefreshIndicatorTriggerMode.anywhere,
                  onRefresh: () async {
                    await controller.getMeetingDetail(
                        requestBody: {"id": controller.meetingDetailBody.id},isRefresh: false);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomTextView(
                                text:
                                    controller.meetingDetailBody.location ?? "",
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                textAlign: TextAlign.start,
                              ),
                              buildManageStatus(
                                  controller.meetingDetailBody, context)
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: CustomTextView(
                              text: UiHelper.displayDatetimeSuffix(
                                  startDate: startDate,
                                  endDate: endDate,
                                  timezone: timezone),
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.h,
                              color: colorGray,
                            ),
                          ),
                        ),
                        MeetingListBodyWidget(
                            controller.meetingDetailBody, 1, 1, true),
                        controller.meetingDetailBody.message?.isNotEmpty == true
                            ? ListTile(
                                contentPadding: EdgeInsets.zero,
                                title:  CustomTextView(
                                  text: "Meeting Notes",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  textAlign: TextAlign.start,
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: CustomTextView(
                                    text:
                                        controller.meetingDetailBody.message ??
                                            "",
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 6),
                        controller.meetingDetailBody.completionMessage
                                        ?.isNotEmpty ==
                                    true &&
                                ["1", "-1"].contains(controller
                                    .meetingDetailBody.completionStatus)
                            ? ListTile(
                                contentPadding: EdgeInsets.zero,
                                title:  CustomTextView(
                                  text: "Message",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  textAlign: TextAlign.start,
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: CustomTextView(
                                    text: controller.meetingDetailBody
                                            .completionMessage ??
                                        "",
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                controller.loading.value ? const Loading() : const SizedBox()
              ],
            );
          },
        ),
      ),
    );
  }

  buildManageStatus(Meetings meetings, BuildContext context) {
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
          label = "invitation_sent".tr;
          color = colorInvitationSent;
        } else {
          label = "lapsed".tr;
          color = colorLapsed;
        }
      } else {
        if (DateTime.parse(mCurrentDate).compareTo(DateTime.parse(mStartDate)) <
            0) {
          label = "invitation_received".tr;
          color = colorInvitationReceived;
        } else {
          label = "lapsed".tr;
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
        label = "live".tr;
        color = colorLive;
      } else {
        if (DateTime.parse(mCurrentDate).compareTo(DateTime.parse(mStartDate)) <
            0) {
          label = "upcoming".tr;
          color = colorUpcoming;
        } else if (DateTime.parse(mCurrentDate)
                .compareTo(DateTime.parse(mStartDate)) >
            0) {
          label = "ended".tr;
          color = colorEndCompleted;
        } else {
          label = "upcoming".tr;
          color = colorUpcoming;
        }
      }
    } else if (meetings.status == -1) {
      label = "declined".tr;
      color = colorDecline;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        meetings.completionStatus == "1" ||
                meetings.completionStatus == "-1" ||
                label.isNotEmpty
            ? Icon(Icons.circle, color: color, size: 10)
            : const SizedBox(),
        const SizedBox(
          width: 6,
        ),
        CustomTextView(
          text: meetings.completionStatus == "1"
              ? "completed".tr
              : meetings.completionStatus == "-1"
                  ? "not_completed".tr
                  : label,
          color: color,
          fontSize: 14.adaptSize,
          fontWeight: FontWeight.normal,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
