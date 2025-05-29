import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/home/controller/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../routes/my_constant.dart';
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
import '../../view/home/model/config_detail_model.dart';
import '../../view/schedule/view/today_session_page.dart';
import '../button/custom_outlined_button.dart';
import '../textview/customTextView.dart';

class LiveEventWidget extends GetView<HomeController> {
  int eventStatus;
  LiveEventWidget({super.key, required this.eventStatus});

  bool _isButtonDisabled = false;
  final DashboardController _dashboardController = Get.find();
  final AuthenticationManager authenticationManager = Get.find();

  @override
  Widget build(BuildContext context) {
    CountdownBanner? countdownBanner =
        controller.configDetailBody.value.countdownBanner;
    return GetX<HomeController>(
      builder: (controller) {
        return Stack(
          children: [
            Skeletonizer(
                enabled: controller.isFirstLoading.value,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(Get.context!).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Theme.of(context)
                                  .shadowColor
                                  .withOpacity(0.15),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxHeight: 280.adaptSize, // Minimum height
                                ),
                                padding: const EdgeInsets.only(
                                    top: 20, bottom: 10, left: 16, right: 16),
                                decoration: BoxDecoration(
                                    color: colorLightGray,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12))),
                                width: context.width,
                                child: TodaySessionPage(),
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 24.h),
                                height: 70,
                                decoration: BoxDecoration(
                                    color: colorLightGray,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12))),
                                width: context.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        toolbarWidget(
                                            ImageConstant.svg_chat, 0, context),
                                        Obx(() => _dashboardController
                                                    .chatCount.value !=
                                                0
                                            ? Positioned(
                                                left: 30,
                                                top: 1,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color: accentColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
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
                                    toolbarWidget(
                                        ImageConstant.svg_alert, 1, context),
                                    toolbarWidget(
                                        ImageConstant.svg_info, 2, context),
                                    //ic_badge
                                    toolbarWidget(
                                        ImageConstant.svg_search, 3, context)
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 19.adaptSize,
                              ),
                              CustomOutlinedButton(
                                height: 65.h,
                                buttonStyle: OutlinedButton.styleFrom(
                                  backgroundColor: white,
                                  side:
                                      BorderSide(color: colorPrimary, width: 1),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                ),
                                buttonTextStyle: TextStyle(
                                    fontSize: 22.fSize,
                                    color: colorPrimary,
                                    fontWeight: FontWeight.w600),
                                onPressed: () {
                                  if (_isButtonDisabled)
                                    return; // Prevent further clicks
                                  _isButtonDisabled = true;
                                  Future.delayed(const Duration(seconds: 4),
                                      () {
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
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: SizedBox(
                            height: 20.adaptSize,
                            child: Material(
                              elevation: 1,
                              color: white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                child: CustomTextView(
                                  text: controller.eventStatus.value == 1
                                      ? countdownBanner?.live?.title ?? ""
                                      : countdownBanner?.end?.title ?? "",
                                  textAlign: TextAlign.center,
                                  fontSize: 12,
                                  color: colorSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        );
      },
    );
  }

  Widget toolbarWidget(iconUrl, index, BuildContext context) {
    return Stack(
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
              child: SvgPicture.asset(iconUrl,
                  height: 21,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onSurface,
                      BlendMode.srcIn))),
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
    );
  }
}
