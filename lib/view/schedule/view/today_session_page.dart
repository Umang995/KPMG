import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/schedule/view/watch_session_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/image_constant.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/customImageWidget.dart';
import '../../../widgets/textview/customTextView.dart';
import '../../../widgets/home_widget/event_info_header.dart';
import '../../dashboard/dashboard_controller.dart';
import '../../home/controller/home_controller.dart';
import '../../speakers/controller/speakersController.dart';
import '../controller/session_controller.dart';
import '../model/scheduleModel.dart';

class TodaySessionPage extends GetView<HomeController> {
  TodaySessionPage({super.key});
  final AuthenticationManager authenticationManager = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: GetX<HomeController>(
        builder: (controller) {
          return Skeletonizer(
            enabled: controller.isLiveSessionLoading.value,
            child: controller.isLiveSessionLoading.value
                ? ListTile(
                    title: Text("notification_description".tr,
                        style: const TextStyle(color: Colors.transparent)),
                    subtitle: Text(
                      "notification_description_notification".tr,
                      style: const TextStyle(color: Colors.transparent),
                    ),
                  )
                : controller.todaySessionList.isEmpty &&
                        (controller.isLiveSessionLoading.value == false &&
                            controller.isFirstLoading.value == false)
                    ? controller.eventStatus.value == 1
                        ? _buildEventLiveBanner()
                        : _buildEventEndBanner()
                    : ListView.separated(
                      padding: EdgeInsets.zero,
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          height: 15,color: borderColor,
                        );
                      },
                      itemCount: controller.todaySessionList.length,
                      itemBuilder: (context, index) {
                        SessionsData session =
                            controller.todaySessionList[index];
                        return GestureDetector(
                          onTap: (){
                            openSessionDetail(session);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: CustomTextView(
                                      text: UiHelper.displayDatetimeSuffix(
                                          startDate: session.startDatetime
                                              .toString(),
                                          endDate:
                                              session.endDatetime.toString(),
                                          timezone: PrefUtils
                                              .getTimezone()),
                                      color: colorGray,
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              CustomTextView(
                                text: session.label ?? "",
                                textAlign: TextAlign.start,
                                color: colorSecondary,
                                maxLines: 2,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              buildSpeakerListview(context, session),
                              SizedBox(
                                height: index ==
                                        controller.todaySessionList.length - 1
                                    ? 8
                                    : 0,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          );
        },
      ),
    );
  }

  Widget buildSpeakerListview(BuildContext context, dynamic session) {
    var length = session!.speakers!.length > 3 ? 3 : session!.speakers!.length;
    bool hasSpeakers = length > 0;
    return Container(
      margin: hasSpeakers ? EdgeInsets.zero : const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Conditionally place the arrow widget at the start or end based on the presence of speakers
          // The speaker list or empty container based on presence of speakers
          hasSpeakers
              ? Expanded(
                  child: Container(
                    color: Colors.transparent,
                    height: 50.v,
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          for (var i = 0; i < length; i++)
                            Positioned(
                              left: (i * (1 - .4) * 34).toDouble(),
                              child: i != 2
                                  ? GestureDetector(
                                      child: CustomImageWidget(
                                        imageUrl:
                                            session.speakers[i].avatar ?? "",
                                        shortName:
                                            session.speakers[i].shortName ??
                                                "",
                                        size: 34.adaptSize,
                                        borderWidth: 0,color: white,fontSize: 12,
                                      ),
                                    )
                                  : InkWell(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 0.h),
                                        child: circularDottedImage(
                                            url: "",
                                            shortName:
                                                "+${session.speakers!.length - 2}",
                                            size: 32.adaptSize),
                                      ),
                                    ),
                            ),
                        ],
                      ),
                    ),
                  ),
                )
              : SvgPicture.asset(ImageConstant.noSpeakerLive),
          // Optionally, you can add more widgets here
          arrowWidget(session),
        ],
      ),
    );
  }

  Widget circularDottedImage({url, shortName, size}) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(ImageConstant.circular_dot_img),
          CustomTextView(
            text: shortName ?? "",
            textAlign: TextAlign.center,
          )
        ],
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
              border: Border.all(color: colorGray)),
          child: Center(
              child: CustomTextView(
            text: shortName ?? "",
            textAlign: TextAlign.center,
          )),
        ),
      ),
    );
  }

  arrowWidget(dynamic session) {
    return GestureDetector(
      onTap: () {
        openSessionDetail(session);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Row(
          children: [
            CustomTextView(
              text: "know_more".tr,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(
              width: 4,
            ),
             Icon(
              Icons.arrow_forward_ios,
              color: colorSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  openSessionDetail(dynamic session) async {
    if (Get.isRegistered<SessionController>()) {
      SessionController sessionController = Get.find();
      controller.loading(true);
      var apiResult = await sessionController
          .getSessionDetail(requestBody: {"id": session.id});
      controller.loading(false);
      if (apiResult["status"]) {
        sessionController.sessionDetailBody.speakers = session.speakers;
        var result = await Get.to(() => WatchDetailPage(
              sessions: sessionController.sessionDetailBody,
            ));
        if (result != null && result) {
          controller.update();
          controller.todaySessionList.refresh();
        } else {}
      }
    } else {
      debugPrint("session controller missing");
    }
  }

  Widget _buildEventLiveBanner() {
    var live = controller.configDetailBody.value.countdownBanner?.live;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            height: 120,
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: live?.image != null && live!.image!.isNotEmpty
                ? CachedNetworkImage(
                    height: 120,
                    imageUrl: live?.image ?? "",
                    fit: BoxFit.contain,
                  )
                : SvgPicture.asset(ImageConstant.no_live_session)),
        // SvgPicture.asset(ImageConstant.no_live_session),
        SizedBox(
          height: 12.adaptSize,
        ),
        CustomTextView(
          text: live?.description ?? "",
          color: colorSecondary,
          fontSize: 16,
          maxLines: 3,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.center,
        ),
        // SizedBox(
        //   height: 41.adaptSize,
        // ),
      ],
    );
  }

  Widget _buildEventEndBanner() {
    var end = controller.configDetailBody.value.countdownBanner?.end;
    controller.eventRemainingTime.refresh();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            height: 120,
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: end?.image != null && end!.image!.isNotEmpty
                ? CachedNetworkImage(
                    height: 120,
                    imageUrl: end?.image ?? "",
                    fit: BoxFit.contain,
                  )
                : SvgPicture.asset(ImageConstant.no_live_session)),
        // SvgPicture.asset(ImageConstant.no_live_session),
        SizedBox(
          height: 12.adaptSize,
        ),
        CustomTextView(
          text: end?.description ?? "",
          color: colorSecondary,
          fontSize: 16,
          maxLines: 3,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
