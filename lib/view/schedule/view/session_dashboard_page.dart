import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/bestForYou/controller/aiMatchController.dart';
import 'package:dreamcast/view/schedule/view/session_list_page.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_decoration.dart';
import '../../../utils/dialog_constant.dart';
import '../../bestForYou/view/aiMatch_session_page.dart';
import '../../myFavourites/view/favourite_session_page.dart';
import '../controller/session_controller.dart';

import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/bestForYou/controller/aiMatchController.dart';
import 'package:dreamcast/view/schedule/view/session_list_page.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_decoration.dart';
import '../../../utils/dialog_constant.dart';
import '../../bestForYou/view/aiMatch_session_page.dart';
import '../../myFavourites/view/favourite_session_page.dart';
import '../controller/session_controller.dart';
import 'booking_session_page.dart';

class SessionDashboardPage extends GetView<SessionController> {
  SessionDashboardPage({super.key});

  static const routeName = "/SessionList";

  @override
  final controller = Get.put(SessionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: AppDecoration.commonTabPadding(),
        child: buildSessionTab(context),
      ),
    );
  }

  buildSessionTab(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() => TabBar(
              controller: controller.tabController,
              isScrollable: true,
              dividerColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              tabAlignment: TabAlignment.start,
              tabs: List.generate(controller.tabList.length, (index) {
                final tab = controller.tabList[index];
                final isSelected = controller.selectedTabIndex.value == index;
                if (tab.value == "aiSessions") {
                  return Tab(
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style.copyWith(
                              fontSize: 24.fSize,
                              fontWeight: FontWeight.w600,
                            ),
                        children: [
                          TextSpan(
                            text: "AI ",
                            style: TextStyle(
                              fontSize: 24.fSize,
                              fontWeight: FontWeight.w600,
                              foreground: Paint()
                                ..shader = LinearGradient(
                                  colors: [gradientBegin, gradientEnd],
                                  begin: Alignment.bottomRight,
                                  end: Alignment.topRight,
                                ).createShader(
                                    const Rect.fromLTWH(0, 0, 100, 40)),
                            ),
                          ),
                          TextSpan(
                            text: "recommended".tr,
                            style: TextStyle(
                              fontSize: 24.fSize,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? colorPrimary : colorGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Tab(text: tab.label?.tr ?? '');
                }
              }),
            )),
      ),
      body: Obx(() => TabBarView(
            controller: controller.tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: controller.tabList.map((tab) {
              switch (tab.value) {
                case "sessions":
                  return SessionListPage();
                case "aiSessions":
                  return AiMatchSessionPage();
                case "mySessions":
                  return FavouriteSessionPage(isFromBookmarkSection: false);
                case "myBookings":
                  return BookingSessionPage();
                default:
                  return Center(child: Text("Unknown tab"));
              }
            }).toList(),
          )),
    );
  }
}
