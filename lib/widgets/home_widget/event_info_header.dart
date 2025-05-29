import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/home/controller/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_decoration.dart';
import '../../theme/ui_helper.dart';
import '../../utils/dialog_constant.dart';
import '../../utils/image_constant.dart';
import '../../view/beforeLogin/globalController/authentication_manager.dart';
import '../../view/chat/view/chatDashboard.dart';
import '../../view/dashboard/dashboard_controller.dart';
import '../../view/globalSearch/page/global_search_page.dart';
import '../../view/guide/view/info_faq_dashboard.dart';
import '../button/custom_outlined_button.dart';
import '../textview/customTextView.dart';

class PreEventWidget extends GetView<HomeController> {
  int eventStatus;
  PreEventWidget({super.key, required this.eventStatus});

  bool _isButtonDisabled = false;
  final DashboardController _dashboardController = Get.find();
  final AuthenticationManager authenticationManager = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) {
        return Stack(
          children: [
            Skeletonizer(
                enabled: controller.isFirstLoading.value,
                child: Container(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.15),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(14.adaptSize),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        eventStatus == 2
                            ? const SizedBox()
                            : Container(
                                height: 88.h,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.h,
                                  vertical: 3.v,
                                ),
                                decoration: AppDecoration.fillGray.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.roundedBorder10,
                                ),
                                width: context.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomTextView(
                                          text: "event_begins_in".tr,
                                          maxLines: 1,
                                          textAlign: TextAlign.start,
                                          color: colorGray,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        CustomTextView(
                                          text: controller
                                                  .eventRemainingTime.value ??
                                              "",
                                          maxLines: 1,
                                          textAlign: TextAlign.start,
                                          color: colorSecondary,
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          var url = controller.configDetailBody
                                                  .value.location?.url ??
                                              "";
                                          UiHelper.inAppBrowserView(
                                              Uri.parse(url.toString()));
                                        },
                                        child: Skeleton.shade(
                                          child: SvgPicture.asset(
                                            ImageConstant.ic_location,
                                            height: 58,
                                            width: 57,
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                        SizedBox(
                          height: eventStatus == 2 ? 0 : 14.v,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: Container(
                                  height: context.height,
                                  padding: EdgeInsets.all(16.h),
                                  decoration: AppDecoration.fillGray.copyWith(
                                    borderRadius:
                                        BorderRadiusStyle.roundedBorder10,
                                  ),
                                  width: context.width,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Skeleton.shade(
                                        child: SvgPicture.asset(
                                          ImageConstant.ic_schedule,
                                          height: 32,
                                          colorFilter: ColorFilter.mode(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              BlendMode.srcIn),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Expanded(
                                        child: CustomTextView(
                                          text: controller.configDetailBody
                                                  .value.datetime?.text ??
                                              "",
                                          textAlign: TextAlign.start,
                                          maxLines: 2,
                                          fontSize: 22,
                                          color: colorSecondary,
                                          fontWeight: FontWeight.bold,
                                          //height: 1.2,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 8,
                                            child: Text(
                                              controller.configDetailBody.value
                                                      .location?.shortText ??
                                                  "",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: colorGray,
                                                fontWeight: FontWeight.w400,
                                                //overflow: TextOverflow.clip,
                                                height: 1.2,
                                              ),
                                              maxLines: 2,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          eventStatus == 2
                                              ? const SizedBox()
                                              : Skeleton.shade(
                                                  child: InkWell(
                                                    onTap: () async {
                                                      await Add2Calendar
                                                          .addEvent2Cal(
                                                        controller.buildEvent(
                                                            controller
                                                                    .configDetailBody
                                                                    .value
                                                                    .name ??
                                                                "",
                                                            controller
                                                                    .configDetailBody
                                                                    .value
                                                                    .location
                                                                    ?.shortText ??
                                                                ""),
                                                      ).then((success) {
                                                        if (success) {
                                                          Future.delayed(
                                                              const Duration(
                                                                  seconds: 1),
                                                              () {
                                                            UiHelper.showSuccessMsg(
                                                                context,
                                                                "event_added_success"
                                                                    .tr);
                                                          });
                                                        } else {
                                                          print(
                                                              'event_added_failed'
                                                                  .tr);
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              7),
                                                      decoration: BoxDecoration(
                                                        color: white,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(7),
                                                        ),
                                                      ),
                                                      child: SvgPicture.asset(
                                                          ImageConstant
                                                              .add_event,
                                                          height: 18,
                                                          colorFilter: ColorFilter
                                                              .mode(
                                                                  Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onPrimary,
                                                                  BlendMode
                                                                      .srcIn)),
                                                      // child: const Icon(
                                                      //   Icons.add,
                                                      //   color: Colors.black,
                                                      // ),
                                                    ),
                                                  ),
                                                )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 14.h,
                            ),
                            Expanded(
                              flex: 1,
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: Container(
                                  height: context.height,
                                  decoration: AppDecoration.fillGray.copyWith(
                                    borderRadius:
                                        BorderRadiusStyle.roundedBorder10,
                                  ),
                                  width: context.width,
                                  child: Center(
                                      child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              toolbarWidget(
                                                  ImageConstant.svg_chat,
                                                  0,
                                                  context),
                                              Obx(() => _dashboardController
                                                          .chatCount.value !=
                                                      0
                                                  ? Positioned(
                                                      left: 30,
                                                      top: 1,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: accentColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                        ),
                                                        constraints:
                                                            const BoxConstraints(
                                                          minWidth: 8,
                                                          minHeight: 8,
                                                        ),
                                                        child: const SizedBox(),
                                                      ),
                                                    )
                                                  : Container())
                                            ],
                                          ),
                                          SizedBox(
                                            width: 14.v,
                                          ),
                                          toolbarWidget(ImageConstant.svg_alert,
                                              1, context)
                                        ],
                                      ),
                                      SizedBox(
                                        height: 14.v,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          toolbarWidget(ImageConstant.svg_info,
                                              2, context),
                                          SizedBox(
                                            width: 14.v,
                                          ),
                                          //ic_badge
                                          toolbarWidget(
                                              ImageConstant.svg_search,
                                              3,
                                              context)
                                        ],
                                      )
                                    ],
                                  )),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 19.v,
                        ),
                        CustomOutlinedButton(
                          height: 65.h,
                          buttonStyle: OutlinedButton.styleFrom(
                            backgroundColor: white,
                            side: BorderSide(color: colorPrimary, width: 1),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(43)),
                            ),
                          ),
                          buttonTextStyle: TextStyle(
                              fontSize: 22.fSize,
                              color: colorPrimary,
                              fontWeight: FontWeight.w600),
                          onPressed: () {
                            if (_isButtonDisabled)
                              return; // Prevent further clicks
                            _isButtonDisabled = true;
                            Future.delayed(const Duration(seconds: 4), () {
                              _isButtonDisabled =
                                  false; // Re-enable the button after the screen is closed
                            });
                            controller.getHtmlPage(
                                "myAgenda".tr, "agenda", false);
                          },
                          text: "discover_program".tr,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        );
      },
    );
  }

  Widget toolbarWidget(iconUrl, index, BuildContext context) {
    return Skeleton.leaf(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: InkWell(
                onTap: () {
                  switch (index) {
                    case 0:
                      if (!authenticationManager.isLogin()) {
                        DialogConstantHelper.showLoginDialog(
                            Get.context!, authenticationManager);
                        return;
                      }
                      Get.toNamed(ChatDashboardPage.routeName);
                      break;
                    case 1:
                      _dashboardController.openAlertPage();
                      break;
                    case 2:
                      Get.toNamed(InfoFaqDashboard.routeName);
                      break;
                    case 3:
                      Get.toNamed(GlobalSearchPage.routeName);
                      break;
                  }
                },
                child: SvgPicture.asset(
                  iconUrl,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
                  height: 21,
                )),
          ),
          index == 1 &&
                  (_dashboardController.personalCount.value > 0 ||
                      authenticationManager.showBadge.value)
              ? Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 10,
                      minHeight: 10,
                    ),
                    child: const SizedBox(),
                  ))
              : const SizedBox()
        ],
      ),
    );
  }
}
