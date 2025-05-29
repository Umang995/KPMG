import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/alert/controller/alert_controller.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/image_constant.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/loading.dart';
import '../../dashboard/deep_linking_controller.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../skeletonView/ListDocumentSkeleton.dart';
import '../model/notification_model.dart';

class AlertGeneralPage extends GetView<AlertController> {
  AlertGeneralPage({super.key});

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  var showPopup = false.obs;
  // Set to keep track of items already displayed
  Set<String> displayedItems = {};

  @override
  Widget build(BuildContext context) {
    return GetX<AlertController>(builder: (controller) {
      return Stack(
        children: [
          RefreshIndicator(
              key: _refreshIndicatorKey,
              child: Skeletonizer(
                enabled: controller.isFirstLoading.value,
                child: controller.isFirstLoading.value
                    ? const ListDocumentSkeleton()
                    : ListView.separated(
                        itemCount: controller.broadcastAlertList.length,
                        itemBuilder: (context, index) {
                          return childListItem(index, context, false);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            height: 1,
                            color: Colors.transparent,
                          );
                        },
                      ),
              ),
              onRefresh: () async {
                displayedItems.clear();
                controller.initNotificationRef();
              }),
          _progressEmptyWidget()
        ],
      );
    });
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.loading.value
          ? const Loading()
          : controller.broadcastAlertList.isEmpty &&
                  !controller.isFirstLoading.value
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox.shrink(),
    );
  }

  Widget buildAlertPopup(BuildContext context) {
    return SizedBox(
      width: 132.adaptSize,
      child: Card(
          color: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: colorGray, width: 1),
          ),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    controller.titleAllMessage.value = "All Messages";
                    showPopup(false);
                    controller.getAllMessages(isPersonal: true);
                  },
                  child: CustomTextView(
                    text: "All Messages",
                    fontWeight: FontWeight.w600,
                    color: controller.titleAllMessage.value == "All Messages"
                        ? colorSecondary
                        : colorGray,
                    fontSize: 14,
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 5.v,
                ),
                InkWell(
                  onTap: () async {
                    controller.titleAllMessage.value = "Unread Messages";
                    showPopup(false);
                    controller.getUnreadMessages(isPersonal: true);
                  },
                  child: CustomTextView(
                    text: "Unread Messages",
                    fontWeight: FontWeight.w600,
                    color: controller.titleAllMessage.value == "Unread Messages"
                        ? colorSecondary
                        : colorGray,
                    fontSize: 14,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget childListItem(int index, BuildContext context, bool isPersonal) {
    final NotificationModel message = controller.broadcastAlertList[index];
    try {
      var displayDate = UiHelper.displayDateFormat2(
          date: message.datetime ?? "",
          timezone: PrefUtils.getTimezone());
      if (!displayedItems.contains(displayDate)) {
        displayedItems.add(displayDate);
        message.showDate = true;
      }
    } catch (exception) {
      print(exception.toString());
    }
    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          message.showDate == true
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 6),
                  child: CustomTextView(
                    text: UiHelper.displayDateFormat2(
                        date: message.datetime ?? "",
                        timezone: PrefUtils.getTimezone()),
                    fontWeight: FontWeight.w600,
                    color: colorGray,
                    fontSize: 22,
                  ),
                )
              : const SizedBox(),
          InkWell(
            onTap: () {
              openPageClick(index);
            },
            child: Container(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                  color: true ? white : Colors.black.withOpacity(0.1),
                  border: Border.all(color: borderColor, width: 0.7),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextView(
                      text: UiHelper.displayCommonDateTime(
                          date: message.datetime ?? "",
                          timezone: PrefUtils.getTimezone()),
                      textAlign: TextAlign.start,
                      fontSize: 14,
                      maxLines: 3,
                      fontWeight: FontWeight.normal,
                      color: colorGray,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    CustomTextView(
                      text: message.title ?? "",
                      textAlign: TextAlign.start,
                      fontSize: 18,
                      maxLines: 10,
                      fontWeight: FontWeight.w500,
                      color: colorSecondary,
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HtmlWidget(
                        textStyle: TextStyle(
                          color: colorSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        message.body ?? "")
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  openPageClick(int index) {
    final NotificationModel message = controller.broadcastAlertList[index];
    print(message.data?.page ?? "");
    print(message.data?.id ?? "");
    if (Get.isRegistered<DeepLinkingController>()) {
      DeepLinkingController deepLinkingController = Get.find();
      AuthenticationManager authenticationManager = Get.find();
      authenticationManager.pageRouteName = message.data?.page ?? "";
      authenticationManager.pageRouteId = message.data?.id ?? "";
      authenticationManager.pageRouteTitle = message.title ?? "";
      deepLinkingController.navigatePageAsPerNotification();
      if ({"session", "networking", "profile", "home"}
          .contains(message.data?.page?.toString())) {
        Get.back();
      }
    }
  }
}
