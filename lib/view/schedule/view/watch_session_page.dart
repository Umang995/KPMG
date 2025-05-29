import 'dart:io';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dreamcast/theme/app_decoration.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/polls/controller/pollsController.dart';
import 'package:dreamcast/view/schedule/widget/common_track_list_widget.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/view/schedule/controller/session_controller.dart';
import 'package:dreamcast/view/speakers/view/speakerListBody.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../api_repository/app_url.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/image_constant.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/add_calender_widget.dart';
import '../../../widgets/animatedBookmark/AnimatedBookmarkWidget.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/button/custom_icon_button.dart';
import '../../../widgets/streemingPlayer/better_player.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/dashboard_controller.dart';
import '../../askQuestion/view/ask_question_page.dart';
import '../../polls/view/pollsPage.dart';
import '../../quiz/view/feedback_page.dart';
import '../model/scheduleModel.dart';
import '../widget/manage_session_booking_widget.dart';
import '../widget/session_speaker_list.dart';
import '../widget/session_status_widget.dart';

class WatchDetailPage extends GetView<SessionController> {
  final DashboardController dashboardController = Get.find();
  SessionsData sessions;
  WatchDetailPage({Key? key, required this.sessions}) : super(key: key);
  static const routeName = "/ScheduleDetailPage";

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
        title: ToolbarTitle(title: "session_detail".tr),
        backgroundColor: white,
        // dividerHeight: 1,
        actions: [
          Obx(
            () => AnimatedBookmarkWidget(
              height: 22,
              id: controller.mSessionDetailBody.value.id ?? "",
              bookMarkIdsList: controller.bookMarkIdsList,
              padding: const EdgeInsets.all(6),
              onTap: () async {
                await controller.bookmarkToSession(
                    id: controller.mSessionDetailBody.value.id);
              },
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          GestureDetector(
            onTap: () {
              controller.shareTheSession();
            },
            child: SvgPicture.asset(
              ImageConstant.share_icon,
              width: 18,
              color: colorSecondary,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: GetX<SessionController>(
        builder: (controller) {
          return SizedBox(
            width: context.width,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.isStreaming.value
                        ? _buildBannerView()
                        : const SizedBox(
                            height: 0,
                          ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (controller
                                  .mSessionDetailBody.value.keywords.isNotEmpty)
                                CommonTrackListWidget(
                                    keywordsList: controller
                                        .mSessionDetailBody.value.keywords),
                              _bodyHeader(context),
                              _bodyMenuView(context),
                              controller.sessionDetailBody.speakers != null &&
                                      controller.sessionDetailBody.speakers!
                                          .isNotEmpty
                                  ? _buildSpeakerView(context)
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ManageSessionBookingWidget(
                      session: controller.mSessionDetailBody.value,
                      isDetail: true,
                    ),
                  ],
                ),
                controller.loading.value ? const Loading() : const SizedBox()
              ],
            ),
          );
        },
      ),
    );
  }

  buildManageWatchBookingButton() {
    bool isSeatBooked =
        controller.mSessionDetailBody.value.isSeatBooked?.toString() == "1";
    bool requiresApproval = controller.mSessionDetailBody.value.isBooking ==
            BookingType.admin_approval.name ||
        controller.mSessionDetailBody.value.isBooking ==
            BookingType.admin_assign.name ||
        controller.mSessionDetailBody.value.isBooking ==
            BookingType.auto_approval.name;
    bool canWatchLive =
        controller.mSessionDetailBody.value.isOnlineStream == 1 &&
            !controller.isStreaming.value;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: AppDecoration.outlineBlack,
      child: isSeatBooked || requiresApproval == false
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (requiresApproval)
                  Expanded(
                    child: ManageSessionBookingWidget(
                      session: controller.mSessionDetailBody.value,
                      isDetail: true,
                    ),
                  ),
                const SizedBox(width: 12),
                if (canWatchLive && (requiresApproval == false || isSeatBooked))
                  Expanded(
                    child: CustomIconButton(
                      height: 50,
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorPrimary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomTextView(
                              text: "watch_live".tr,
                              color: white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.play_arrow, color: white, size: 18),
                          ],
                        ),
                      ),
                      onTap: () {
                        controller.isStreaming(!controller.isStreaming.value);
                      },
                    ),
                  ),
              ],
            )
          : ManageSessionBookingWidget(
              session: controller.mSessionDetailBody.value,
              isDetail: true,
            ),
    );
  }

  _buildSpeakerView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 12,
        ),
        CustomTextView(
          text: "Speakers",
          textAlign: TextAlign.start,
          color: colorGray,
          fontWeight: FontWeight.w600,
          fontSize: 22,
        ),
        const SizedBox(
          height: 12,
        ),
        SessionSpeakerList(
          speakerList: controller.sessionDetailBody.speakers ?? [],
        ),
        //const Divider(),
      ],
    );
  }

  _buildBannerView() {
    SessionsData sessionDetail = controller.sessionDetailBody;
    return sessionDetail.isOnlineStream == 1 &&
            sessionDetail.embed != null &&
            sessionDetail.embed!.isNotEmpty
        ? Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 220.adaptSize),
                child: Stack(
                  children: [
                    sessionDetail.embedPlayer == "m3u8"
                        ? buildBetterPlayer()
                        : buildYoutubePlayer(),
                    Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            controller
                                .isStreaming(!controller.isStreaming.value);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              ImageConstant.icCloseCircle,
                              height: 30,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              if (sessionDetail.auditorium?.emoticons != null &&
                  sessionDetail.auditorium!.emoticons!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: _buildReactionView(35),
                )
            ],
          )
        : Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image:
                      NetworkImage(sessionDetail.auditorium?.thumbnail ?? ""),
                  fit: BoxFit.fill),
            ),
          );
  }

  buildYoutubePlayer() {
    SessionsData sessionDetail = controller.sessionDetailBody;
    return _buildVideo(meetingUrl: sessionDetail.embed ?? "");
  }

  buildBetterPlayer() {
    SessionsData sessionDetail = controller.sessionDetailBody;
    return BetterPlayerScreen(
      url: sessionDetail.embed.toString(),
    );
  }

  _bodyHeader(BuildContext context) {
    // label = controller.mSessionDetailBody.value.status?.text ?? "";
    final startDate = controller.sessionDetailBody.startDatetime.toString();
    final endDate = controller.sessionDetailBody.endDatetime.toString();
    final timezone = PrefUtils.getTimezone();
    var statusColor = UiHelper.getColorByHexCode(
        controller.mSessionDetailBody.value.status?.color ?? "");
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 10),
      decoration: BoxDecoration(
        color: colorLightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: controller.mSessionDetailBody.value.status?.value ==
                            1 ||
                        controller.mSessionDetailBody.value.status?.value == 2
                    ? 10
                    : 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SessionStatusWidget(
                    statusColor: statusColor,
                    title:
                        controller.mSessionDetailBody.value.status?.text ?? ""),
                controller.mSessionDetailBody.value.status?.value == 0
                    ? AddCalenderWidget(
                        onTap: () {
                          Add2Calendar.addEvent2Cal(
                            controller.buildEventDetail(
                                sessions: controller.mSessionDetailBody.value),
                          );
                        },
                      )
                    : const SizedBox()
              ],
            ),
          ),
          CustomTextView(
            text: UiHelper.displayDatetimeSuffix(
                startDate: startDate, endDate: endDate, timezone: timezone),
            color: colorSecondary,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                ImageConstant.ic_location_icon,
                height: 17,
              ),
              const SizedBox(
                width: 6,
              ),
              Flexible(
                child: CustomTextView(
                  text: controller.mSessionDetailBody.value.auditorium?.text ??
                      "",
                  color: colorGray,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextView(
            text: controller.sessionDetailBody.label ?? "",
            fontSize: 20,
            textAlign: TextAlign.start,
            maxLines: 10,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(
            height: 6,
          ),
          CustomReadMoreText(
            text: controller.sessionDetailBody.description ?? "",
            textAlign: TextAlign.start,
            fontSize: 14,
            color: colorSecondary,
            fontWeight: FontWeight.normal,
          ),
        ],
      ),
    );
  }

  _buildVideo({meetingUrl}) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(meetingUrl)),
      onEnterFullscreen: (controller) async {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      },
      onExitFullscreen: (controller) async {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitDown,
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      },
      initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            mediaPlaybackRequiresUserGesture: false,
          ),
          ios: IOSInAppWebViewOptions(
            allowsInlineMediaPlayback: true,
          )),
      androidOnPermissionRequest: (InAppWebViewController controller,
          String origin, List<String> resources) async {
        await Permission.camera.request();
        await Permission.microphone.request();
        return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT);
      },
    );
  }

  _bodyMenuView(BuildContext context) {
    //its have a booking features
    final bool allowSeatBooking = [
      BookingType.admin_assign.name,
      BookingType.admin_approval.name,
      BookingType.auto_approval.name,
    ].contains(controller.mSessionDetailBody.value.isBooking);

    bool isSeatBooked =
        controller.mSessionDetailBody.value.isSeatBooked?.toString() == "1";

    List<String> controlList =
        controller.sessionDetailBody.auditorium?.controls ?? [];

    var showTheMenu = (allowSeatBooking == false || isSeatBooked);

    return controlList.isNotEmpty && showTheMenu
        ? Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: controller.menuParentItemList.length,
              itemBuilder: (context, index) {
                var data = controller.menuParentItemList[index];
                return controlList.contains(data.id?.toLowerCase())
                    ? InkWell(
                        onTap: () async {
                          switch (index) {
                            case 0:
                              if (Get.isRegistered<PollController>()) {
                                Get.delete<PollController>();
                              }
                              Get.toNamed(PollsPage.routeName, arguments: {
                                "item_type": "webinar",
                                "item_id":
                                    controller.mSessionDetailBody.value.id ?? ""
                              });
                              break;
                            case 1:
                              Get.toNamed(AskQuestionPage.routeName,
                                  arguments: {
                                    "name": controller
                                            .mSessionDetailBody.value.label ??
                                        "",
                                    "image": controller.mSessionDetailBody.value
                                            .thumbnail ??
                                        "",
                                    "item_id": controller
                                            .mSessionDetailBody.value.id ??
                                        "",
                                    "item_type": "webinar",
                                  });
                              break;
                            case 3:
                              Get.toNamed(FeedbackPage.routeName, arguments: {
                                "item_id":
                                    controller.mSessionDetailBody.value.id,
                                MyConstant.titleKey: "Session Feedback",
                                "type": "webinar"
                              });
                              break;
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 3),
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: white,
                            shape: BoxShape.rectangle,
                            border: Border.all(color: borderColor, width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                controller.menuParentItemList[index].iconUrl ??
                                    "",
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              CustomTextView(
                                text: controller
                                        .menuParentItemList[index].title ??
                                    "",
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox();
              },
            ),
          )
        : const SizedBox();
  }

  rectangleImage({url, shortName, size}) {
    return SizedBox(
      height: size,
      width: size,
      child: url != null && url.toString().isNotEmpty
          ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                image:
                    DecorationImage(image: NetworkImage(url), fit: BoxFit.fill),
                border: Border.all(color: colorGray),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: white,
                border: Border.all(color: colorGray),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: CustomTextView(
                    text: shortName ?? "",
                    fontSize: 10,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildReactionView(double size) {
    Map<int, AnimationController> controllers = {};
    Map<int, Animation<double>> bounceAnimations = {};
    Map<int, Animation<double>> scaleAnimations = {};

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 40),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount:
            controller.sessionDetailBody.auditorium?.emoticons?.length ?? 0,
        itemBuilder: (context, index) {
          Emoticons? emoticons =
              controller.sessionDetailBody.auditorium?.emoticons?[index];

          return StatefulBuilder(
            builder: (context, setState) {
              controllers[index] ??= AnimationController(
                duration: const Duration(milliseconds: 500),
                reverseDuration: const Duration(milliseconds: 600),
                vsync: Navigator.of(context),
              );

              bounceAnimations[index] ??=
                  Tween<double>(begin: 0.0, end: -35.0).animate(
                CurvedAnimation(
                    parent: controllers[index]!, curve: Curves.easeOutBack),
              );

              scaleAnimations[index] ??=
                  Tween<double>(begin: 1.0, end: 2.0).animate(
                CurvedAnimation(
                    parent: controllers[index]!, curve: Curves.easeOutSine),
              );

              return GestureDetector(
                onTap: () {
                  String selectedType = emoticons?.value.toString() ?? "";
                  bool isAlreadySelected =
                      controller.emoticonsSelected.value == selectedType;

                  HapticFeedback.heavyImpact();
                  controller.playSound(); // Haptic feedback

                  if (isAlreadySelected) {
                    // If already reacted, animate first and then remove selection
                    controllers[index]!.forward(from: 0.0).then((_) {
                      controllers[index]!.reverse().then((_) {
                        controller
                            .emoticonsSelected(""); // Deselect after animation
                      });
                    });
                  } else {
                    // If new reaction, animate and mark as selected
                    controller.emoticonsSelected(selectedType);
                    controllers[index]!.forward(from: 0.0).then((_) {
                      controllers[index]!
                          .reverse(); // Smooth return but stay reacted
                    });
                  }

                  var requestBody = {
                    "auditorium_id":
                        controller.mSessionDetailBody.value.auditorium?.value ??
                            "",
                    "auditorium_session_id":
                        controller.mSessionDetailBody.value.id ?? "",
                    "type": isAlreadySelected
                        ? ""
                        : selectedType, // Clear if unselected
                  };

                  controller.sendEmoticonsRequest(
                    requestBody: requestBody,
                    previousSelection: selectedType,
                  );

                  setState(() {}); // Update UI
                },
                child: Obx(() {
                  bool isSelected = controller.emoticonsSelected.value ==
                      emoticons?.value.toString();

                  return AnimatedBuilder(
                    animation: controllers[index]!,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                            0, isSelected ? bounceAnimations[index]!.value : 0),
                        child: Transform.scale(
                          scale:
                              isSelected ? scaleAnimations[index]!.value : 1.0,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                isSelected ? Colors.transparent : white,
                                BlendMode.color,
                              ),
                              child: Text(
                                emoticons?.text.toString() ?? "",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color:
                                      isSelected ? Colors.blue : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              );
            },
          );
        },
      ),
    );
  }
}
