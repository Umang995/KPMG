import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/home/controller/for_you_controller.dart';
import 'package:dreamcast/view/representatives/controller/user_detail_controller.dart';
import 'package:dreamcast/view/schedule/controller/session_controller.dart';
import 'package:dreamcast/view/schedule/view/watch_session_page.dart';
import 'package:dreamcast/view/skeletonView/recommendedSkeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_colors.dart';
import '../utils/pref_utils.dart';
import 'textview/customTextView.dart';
import '../routes/my_constant.dart';
import '../theme/ui_helper.dart';
import '../view/home/model/recommended_model.dart';
import 'customImageWidget.dart';

class LaunchpadAIWidget extends GetView<ForYouController> {
  LaunchpadAIWidget({super.key});

  @override
  final ForYouController controller = Get.put(ForYouController());

  @override
  Widget build(BuildContext context) {
    return controller.recommendedList.isNotEmpty
        ? buildAiAttendeeExhibitorSession(context)
        : const SizedBox();
  }

  Widget buildAiAttendeeExhibitorSession(BuildContext context) {
    return GetX<ForYouController>(builder: (controller) {
      return SizedBox(
        height:
            controller.recommendedList.isNotEmpty ? context.height * .20 : 0,
        child: Skeletonizer(
          enabled: controller.isFirstLoading.value,
          child: controller.isFirstLoading.value
              ? const Recommendedskeleton()
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    RecommendedData data = controller.recommendedList[index];
                    return data.role == MyConstant.attendee ||
                            data.role == MyConstant.representative ||
                            data.role == MyConstant.speakers
                        ? recommendedAttendeeView(data, context)
                        : recommendedSessionView(data,
                            context); /*data.role == "Session"
                            ? recommendedSessionView(data, context)
                            : recommendedExhibitorView(data, context);*/
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 17.v);
                  },
                  itemCount: controller.recommendedList.length,
                ),
        ),
      );
    });
  }

  Widget recommendedAttendeeView(RecommendedData data, BuildContext context) {
    return InkWell(
      onTap: () async {
        if (Get.isRegistered<UserDetailController>()) {
          UserDetailController controller = Get.find();
          controller.isLoading(true);
          await controller.getUserDetailApi(data.id, MyConstant.attendee);
          controller.isLoading(false);
        }
      },
      child: SizedBox(
        height: context.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 130.adaptSize,
              width: 122.adaptSize,
              child: CustomSqureImageWidget(
                imageUrl: data.avatar ?? "",
                shortName: UiHelper.shortenName(data.name ?? "", nameLimit: 5),
              ),
            ),
            SizedBox(
              height: 8.v,
            ),
            CustomTextView(
              text: data.type ?? "Attendee",
              color: colorPrimary,
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
            if (data.name != null && data.name!.isNotEmpty)
              CustomTextView(
                text: data.name ?? "",
                color: colorSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            if (data.company != null && data.company!.isNotEmpty)
              Flexible(
                child: CustomTextView(
                  text: data.company ?? "",
                  color: colorGray,
                  maxLines: 1,
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget recommendedExhibitorView(RecommendedData data, BuildContext context) {
    return SizedBox(
      height: context.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 130.adaptSize,
            width: 122.adaptSize,
            child: CustomSqureImageWidget(
                imageUrl: data.avatar ?? "", shortName: "IMC"),
          ),
          SizedBox(
            height: 8.v,
          ),
          CustomTextView(
            text: data.name ?? "",
            color: colorPrimary,
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
          Expanded(
            child: CustomTextView(
              text: data.type ?? "",
              color: colorGray,
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }

  Widget recommendedSessionView(RecommendedData data, BuildContext context) {
    return InkWell(
      onTap: () {
        openSessionDetail(data.id ?? "");
      },
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 122.adaptSize,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: colorLightGray,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset("assets/svg/ic_session_border.svg"),
                        CustomTextView(
                            text: data.startDatetime != null
                                ? UiHelper.displayDateFormat(
                                    date: data.startDatetime ?? "",
                                    timezone: PrefUtils.getTimezone())
                                : "",
                            maxLines: 1,
                            color: colorSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)
                      ],
                    ),
                    SizedBox(
                      height: 14.v,
                    ),
                    CustomTextView(
                        text:
                            "${UiHelper.displayTimeFormat(date: data.startDatetime ?? "", timezone: PrefUtils.getTimezone())}"
                            " - ${UiHelper.displayTimeFormat(date: data.endDatetime ?? "", timezone: PrefUtils.getTimezone())}",
                        color: colorSecondary,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w500,
                        maxLines: 1,
                        fontSize: 10),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8.v,
            ),
            CustomTextView(
              text: "Session",
              color: colorPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 12,
              textAlign: TextAlign.start,
            ),
            Flexible(
              child: SizedBox(
                width: 122.adaptSize,
                child: CustomTextView(
                  text: data.name ?? "",
                  color: colorSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  openSessionDetail(id) async {
    if (Get.isRegistered<SessionController>()) {
      SessionController sessionController = Get.find();
      controller.isLoading(true);
      var apiResult =
          await sessionController.getSessionDetail(requestBody: {"id": id});
      controller.isLoading(false);
      if (apiResult["status"]) {
        var result = await Get.to(() => WatchDetailPage(
              sessions: sessionController.sessionDetailBody,
            ));
        if (result != null && result) {
          sessionController.update();
          sessionController.sessionList.refresh();
        } else {}
      }
    }
  }
}
