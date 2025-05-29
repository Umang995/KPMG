import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/view/meeting/controller/meetingController.dart';
import 'package:dreamcast/view/meeting/model/meeting_filter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/meeting_list_body.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../skeletonView/meetingBodySkeleton.dart';

class ConfirmMeetingPage extends GetView<MeetingController> {
  ConfirmMeetingPage({super.key});

  var showPopup = false.obs;
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18.adaptSize),
      child: Stack(
        children: [
          GetX<MeetingController>(
            builder: (controller) {
              return Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 9,
                      ),
                      buildHeaderView(context),
                      const SizedBox(
                        height: 16,
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            RefreshIndicator(
                              key: controller.refreshCtrConfirmed,
                              child: Skeletonizer(
                                enabled: controller.isFirstLoadRunning.value,
                                child: controller.isFirstLoadRunning.value
                                    ? const MeetingListSkeleton()
                                    : ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: controller.meetingList.length,
                                        itemBuilder: (context, index) =>
                                            MeetingListBodyWidget(
                                                controller.meetingList[index],
                                                controller.meetingList.length,
                                                index,
                                                false),
                                      ),
                              ),
                              onRefresh: () {
                                return Future.delayed(
                                  const Duration(seconds: 1),
                                  () {
                                    controller.selectedOption.value =
                                        Options(id: "", name: "");
                                    controller.getMeetingList(requestBody: {
                                      "page": "1",
                                      "filters": {
                                        "status": controller.confirmStatus.value
                                      },
                                    }, isRefresh: false);
                                  },
                                );
                              },
                            ),
                            _progressEmptyWidget(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  showPopup.value
                      ? Positioned(
                          top: 45.v,
                          right: 0,
                          child: buildMeetingPopup(
                              context, controller.confirmFilterItem),
                        )
                      : const SizedBox(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String getTextById() {
    var value = "";
    for (var data in controller.confirmFilterItem ?? []) {
      if (data.id == controller.confirmStatus.value) {
        value = data.name ?? "";
      }
    }
    return value;
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.loading.value ||
              controller.userDetailController.isLoading.value
          ? const Loading()
          : controller.meetingList.isEmpty &&
                  !controller.isFirstLoadRunning.value
              ? ShowLoadingPage(
                  refreshIndicatorKey: controller.refreshCtrConfirmed,
                )
              : const SizedBox(),
    );
  }

  Widget buildMeetingPopup(
      BuildContext? context, RxList<Options> confirmFilterItem) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 145.adaptSize),
      child: Card(
        color: white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: borderColor, width: 1)),
        elevation: 6,
        child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            scrollDirection: Axis.vertical,
            itemCount: confirmFilterItem.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Options data = confirmFilterItem[index];
              return InkWell(
                onTap: () {
                  controller.confirmStatus.value = data.id.toString() ?? "";
                  controller.getMeetingList(requestBody: {
                    "page": "1",
                    "filters": {"status": controller.confirmStatus.value},
                  }, isRefresh: false);
                  showPopup(false);
                },
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: CustomTextView(
                    text: data.name ?? "",
                    fontWeight: controller.confirmStatus.value == data?.id
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: controller.confirmStatus.value == data?.id
                        ? colorSecondary
                        : colorGray,
                    fontSize: 15,
                    textAlign: TextAlign.start,
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget buildHeaderView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomTextView(
          text: "${"total_count".tr} (${controller.meetingList.length})",
          textAlign: TextAlign.start,
          fontWeight: FontWeight.w600,
          fontSize: 22,
          color: colorGray,
        ),
        InkWell(
          onTap: () {
            showPopup(!showPopup.value);
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 140.adaptSize),
            child: Container(
              //width: context.width,
              padding: EdgeInsets.only(
                  left: 11.adaptSize,
                  right: 11.adaptSize,
                  top: 7.adaptSize,
                  bottom: 7.adaptSize),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1),
                color: white,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(ImageConstant.ic_sort,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.onPrimary,
                          BlendMode.srcIn)),
                  const SizedBox(
                    width: 6,
                  ),
                  Flexible(
                    child: CustomTextView(
                      text: getTextById().toString(),
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      maxLines: 1,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
