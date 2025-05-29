import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/schedule/controller/session_controller.dart';
import 'package:dreamcast/view/schedule/view/watch_session_page.dart';
import 'package:dreamcast/view/schedule/widget/manage_session_booking_widget.dart';
import 'package:dreamcast/view/speakers/controller/speakersController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/animatedBookmark/AnimatedBookmarkWidget.dart';
import '../../../widgets/customImageWidget.dart';
import '../../../widgets/textview/customTextView.dart';
import '../../../widgets/foundational_track_widget.dart';
import '../../../widgets/loading.dart';
import '../model/scheduleModel.dart';
import '../widget/session_status_widget.dart';

class SessionListBody extends GetView<SessionController> {
  SessionsData session;
  bool isFromBookmark = false;
  bool? apiLoading = false;
  int index;
  int size;

  SessionListBody(
      {super.key,
      required this.session,
      required this.isFromBookmark, // this is not used currently
      required this.index,
      required this.size,
      this.apiLoading});

  var isViewExpend = false.obs;

  AuthenticationManager authenticationManager = Get.find();
  @override
  Widget build(BuildContext context) {
    final startDate = session.startDatetime.toString();
    final endDate = session.endDatetime.toString();
    final timezone = PrefUtils.getTimezone();
    return SizedBox(
      width: context.width,
      child: GestureDetector(
        onTap: () => watchSessionPage(false),
        child: Container(
          padding: EdgeInsets.all(14.v),
          margin: EdgeInsets.only(bottom: 16.v),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: UiHelper.getColorByHexCode(session.status?.color ?? ""),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  session.keywords is List && session.keywords?.isNotEmpty ??
                          false
                      ? ConstrainedBox(
                          constraints:
                              BoxConstraints(maxWidth: context.width * 0.50),
                          child: buildTracksListview(context))
                      : const SizedBox(),
                  Row(
                    children: [
                      SessionStatusWidget(
                          statusColor: UiHelper.getColorByHexCode(
                              session.status?.color ?? ""),
                          title: session.status?.text ?? ""),
                      const SizedBox(
                        width: 10,
                      ),
                      apiLoading != null && apiLoading == true
                          ? const SizedBox()
                          : Obx(
                              () => Stack(
                                alignment: Alignment.center,
                                children: [
                                  controller.isBookmarkLoaded.value
                                      ? AnimatedBookmarkWidget(
                                          id: session.id ?? "",
                                          bookMarkIdsList:
                                              controller.bookMarkIdsList,
                                          padding: const EdgeInsets.all(6),
                                          onTap: () async {
                                            await controller.bookmarkToSession(
                                                id: session.id);
                                          },
                                        )
                                      : const FavLoading(),
                                ],
                              ),
                            ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextView(
                text: UiHelper.displayDatetimeSuffix(
                    startDate: startDate, endDate: endDate, timezone: timezone),
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: colorGray,
              ),
              SizedBox(
                height: 8.v,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextView(
                      text: session.label ?? "",
                      textAlign: TextAlign.start,
                      color: colorSecondary,
                      maxLines: 2,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SvgPicture.asset(
                    ImageConstant.ic_arrow,
                    height: 14.h,
                    width: 8.v,
                  ),
                ],
              ),
              Divider(
                height: 20,
                thickness: 0.5,
                color: colorLightGray,
              ),
              if (session.auditorium?.text != null &&
                  session.auditorium!.text!.isNotEmpty)
                Row(
                  children: [
                    SvgPicture.asset(
                      ImageConstant.icLocationSession,
                      height: 20.h,
                      width: 16.v,
                    ),
                    SizedBox(
                      width: 14.v,
                    ),
                    Flexible(
                        child: CustomTextView(
                      maxLines: 2,
                      color: colorGray,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.start,
                      text: session.auditorium!.text ?? "",
                    )),
                  ],
                ),
              const SizedBox(
                height: 5,
              ),
              buildSpeakerListview(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget circularImage({url, shortName, size}) {
    return SizedBox(
      height: size,
      width: size,
      child: CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colorGray, width: 1),
            image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
          ),
        ),
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: white,
            border: Border.all(color: colorGray),
          ),
          child: Center(
            child: CustomTextView(
              text: shortName ?? "",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget circularDottedImage(
      {url,
      shortName,
      required double size,
      required double fontSize,
      required BuildContext context}) {
    return SizedBox(
      height: size.adaptSize,
      width: size.adaptSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(ImageConstant.circular_dot_img),
          CustomTextView(
            text: shortName ?? "",
            textAlign: TextAlign.center,
            fontSize: fontSize,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          )
        ],
      ),
    );
  }

  Widget buildSpeakerListview(BuildContext context) {
    var length = session.speakers!.length > 3 ? 3 : session.speakers!.length;
    bool hasSpeakers = length > 0;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // The speaker list or empty container based on presence of speakers
          hasSpeakers
              ? Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 34.adaptSize),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          for (var i = 0; i < length; i++)
                            Positioned(
                              left: (i * (1 - .4) * 34).toDouble(),
                              child: i != 2
                                  ? GestureDetector(
                                      onTap: () async {
                                        if (Get.isRegistered<
                                            SpeakersDetailController>()) {
                                          SpeakersDetailController
                                              speakerController = Get.find();
                                          controller.loading(true);
                                          await speakerController
                                              .getSpeakerDetail(
                                            speakerId: session.speakers![i].id,
                                            role: MyConstant.speakers,
                                            isSessionSpeaker: true,
                                          );
                                          controller.loading(false);
                                        }
                                      },
                                      child: CustomImageWidget(
                                        imageUrl:
                                            session.speakers![i].avatar ?? "",
                                        shortName:
                                            session.speakers![i].shortName ??
                                                "",
                                        size: 34.adaptSize,
                                        fontSize: 14,
                                        borderWidth: 0,
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        watchSessionPage(false);
                                      },
                                      child: Container(
                                        child: circularDottedImage(
                                            url: "",
                                            shortName:
                                                "+${session.speakers!.length - 2}",
                                            size: 34.adaptSize,
                                            fontSize: 14,
                                            context: context),
                                      ),
                                    ),
                            ),
                        ],
                      ),
                    ),
                  ),
                )
              : SvgPicture.asset(
                  ImageConstant.noSpeakerIcon,
                  height: 34.adaptSize,
                  width: 34.adaptSize,
                ),
          // Optionally, you can add more widgets here
          arrowWidget(context),
        ],
      ),
    );
  }

  Widget buildTracksListview(BuildContext context) {
    return Stack(
      children: [
        Container(
            margin: const EdgeInsets.only(
              right: 20.0,
            ),
            child: FoundationalTrackWidget(
              title: session.keywords?[0].toString(),
              color: const Color(0xffCF138A),
            )),
        session.keywords!.length == 1
            ? const SizedBox()
            : Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.only(left: 0.h),
                  child: circularDottedImage(
                      url: "",
                      shortName: "+${session.keywords!.length - 1}",
                      size: 25.adaptSize,
                      fontSize: 12,
                      context: context),
                ),
              ),
      ],
    );
  }

  Widget arrowWidget(BuildContext context) {
    bool isSeatBooked = session.isSeatBooked?.toString() == "1";
    bool requiresApproval =
        session.isBooking == BookingType.admin_assign.name ||
            session.isBooking == BookingType.admin_approval.name ||
            session.isBooking == BookingType.auto_approval.name;
    bool canWatchLive =
        session.isOnlineStream != null && session.isOnlineStream == 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        canWatchLive && (requiresApproval == false || isSeatBooked)
            ? GestureDetector(
                onTap: () => watchSessionPage(true),
                child: Container(
                  height: 34.adaptSize,
                  // width: 34.adaptSize,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.adaptSize,
                    vertical: 6.adaptSize,
                  ),
                  decoration: BoxDecoration(
                    color: colorLightGray,
                    borderRadius:
                        BorderRadius.all(Radius.circular(5.adaptSize)),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          ImageConstant.ic_play_icon,
                          height: 20.adaptSize,
                          width: 19.adaptSize,
                          colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.onSurface,
                              BlendMode.srcIn),
                        ),
                        const SizedBox(width: 6),
                        CustomTextView(
                          text: "watch".tr,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        SizedBox(
          width: session.isOnlineStream != null && session.isOnlineStream == 1
              ? 8
              : 0,
        ),
        session.status?.value == 0 && requiresApproval == false
            ? GestureDetector(
                onTap: () {
                  Add2Calendar.addEvent2Cal(
                    controller.buildEvent(sessions: session),
                  );
                },
                child: Container(
                  height: 34.adaptSize,
                  // width: 34.adaptSize,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.adaptSize,
                    vertical: 6.adaptSize,
                  ),
                  decoration: BoxDecoration(
                    color: colorLightGray,
                    borderRadius:
                        BorderRadius.all(Radius.circular(5.adaptSize)),
                  ),
                  // child: SvgPicture.asset("assets/svg/ic_add_event.svg"),
                  child: Center(
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          ImageConstant.ic_add_event,
                          height: 20.adaptSize,
                          width: 19.adaptSize,
                          colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.onSurface,
                              BlendMode.srcIn),
                        ),
                        const SizedBox(width: 5),
                        CustomTextView(
                          text: "add".tr,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        )
                      ],
                    ),
                  ),
                ),
              )
            : ManageSessionBookingWidget(
                session: session,
                isDetail: false,
              )
      ],
    );
  }

  watchSessionPage(bool streaming) async {
    var result =
        await controller.getSessionDetail(requestBody: {"id": session.id});
    controller.isStreaming(streaming);
    if (result["status"]) {
      controller.sessionDetailBody.speakers = session.speakers;
      if (controller.bookMarkIdsList
          .contains(controller.sessionDetailBody.id)) {
        controller.sessionDetailBody.bookmark = controller.sessionDetailBody.id;
      }
      if (Get.isRegistered<SpeakersDetailController>()) {
        SpeakersDetailController speakerController = Get.find();
        if (controller.sessionDetailBody.speakers != null &&
            controller.sessionDetailBody.speakers!.isNotEmpty) {
          speakerController.userIdsList = controller.sessionDetailBody.speakers!
              .map((obj) => obj.id)
              .toList();
          await speakerController.getBookmarkAndRecommendedByIds();
        }
      } else {
        final speakerController = Get.put(SpeakersDetailController());
        if (controller.sessionDetailBody.speakers != null &&
            controller.sessionDetailBody.speakers!.isNotEmpty) {
          speakerController.userIdsList = controller.sessionDetailBody.speakers!
              .map((obj) => obj.id)
              .toList();
          await speakerController.getBookmarkAndRecommendedByIds();
        }
      }
      Get.to(() => WatchDetailPage(
            sessions: controller.sessionDetailBody,
          ));
    }
  }
}
