import 'dart:io';

import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/view/account/view/account_page.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:dreamcast/view/schedule/view/session_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../utils/dialog_constant.dart';
import '../../widgets/dialog/custom_dialog_widget.dart';
import '../chat/view/chatDashboard.dart';
import '../home/screen/home_page.dart';
import '../menu/view/menuListView.dart';
import '../representatives/view/networkingPage.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({Key? key}) : super(key: key);
  static const routeName = "/home_screen";
  final AuthenticationManager _authManager = Get.find();
  final DashboardController controller = Get.find();

  List<String> bottomTitle = [
    "",
    "sessions".tr,
    "Hub",
    "Networking",
    "profile".tr, //Favourites
  ];
  var canPop = false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvoked: (bool value) async {
        if (controller.dashboardTabIndex != 0) {
          controller.changeTabIndex(0);
        } else {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogWidget(
                title: "exit_app".tr,
                logo: ImageConstant.logout,
                description: "are_you_sure_want_to_exit_app".tr,
                buttonAction: "exit".tr,
                buttonCancel: "cancel".tr,
                onCancelTap: () {
                  canPop = false;
                },
                onActionTap: () async {
                  canPop = true;
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
              );
            },
          );
        }
      },
      child: SizedBox(
        width: _authManager.dc_device == "tablet"
            ? context.width * 0.444
            : context.width,
        child: GetBuilder<DashboardController>(
          builder: (_) {
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                elevation: 0,
                toolbarHeight: (controller.dashboardTabIndex == 0 ||
                        controller.dashboardTabIndex == 4)
                    ? 0
                    : 60,
                centerTitle: false,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                iconTheme: IconThemeData(color: colorSecondary),
                shape: const Border(
                    bottom: BorderSide(color: borderColor, width: 0)),
                title: ToolbarTitle(
                  title: bottomTitle[controller.dashboardTabIndex],
                  color: colorSecondary,
                ),
                actions: [
                  buildChatLink(),
                  buildAlertLink(),
                  const SizedBox(
                    width: 3,
                  ),
                ],
              ),
              body: Stack(
                children: [
                  SafeArea(
                      child: IndexedStack(
                    index: controller.dashboardTabIndex,
                    children: [
                      HomePage(),
                      SessionDashboardPage(),
                      HubMenuPage(),
                      NetworkingPage(),
                      AccountPage(),
                    ],
                  )),
                  Obx(() => controller.loading.value
                      ? const Loading()
                      : const SizedBox()),
                ],
              ),
              bottomNavigationBar: Container(
                decoration: const BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SnakeNavigationBar.color(
                  snakeShape: SnakeShape.indicator,
                  shadowColor: Colors.black45,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  onTap: controller.changeTabIndex,
                  currentIndex: controller.dashboardTabIndex,
                  unselectedItemColor: colorGray,
                  selectedItemColor: colorPrimary,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  snakeViewColor: colorPrimary,
                  selectedLabelStyle: const TextStyle(fontSize: 10),
                  unselectedLabelStyle: const TextStyle(
                      fontSize: 10, overflow: TextOverflow.ellipsis),
                  items: [
                    BottomNavigationBarItem(
                      icon: ImageIcon(
                        AssetImage(ImageConstant.ic_home),
                        size: 25,
                      ),
                      label: "home".tr,
                    ),
                    BottomNavigationBarItem(
                      icon: ImageIcon(
                        AssetImage(ImageConstant.ic_session),
                        size: 25,
                      ),
                      label: "sessions".tr,
                    ),
                    BottomNavigationBarItem(
                      icon: ImageIcon(
                        AssetImage(ImageConstant.ic_menu),
                        size: 25,
                      ),
                      label: "menu".tr,
                    ),
                    BottomNavigationBarItem(
                      icon: ImageIcon(
                        AssetImage(ImageConstant.ic_connect),
                        size: 25,
                      ),
                      label: "networking".tr,
                    ),
                    BottomNavigationBarItem(
                      icon: ImageIcon(
                        AssetImage(ImageConstant.profileIcon),
                        size: 25,
                      ),
                      label: "Profile",
                    ),
                  ],
                ),
              ),
              resizeToAvoidBottomInset: true,
            );
          },
        ),
      ),
    );
  }

  buildAlertLink() {
    return GestureDetector(
      onTap: () async {
        controller.openAlertPage();
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            child: SvgPicture.asset(
              ImageConstant.home_alert,
              // width: 26,
              color: colorSecondary,
            ),
          ),
          Obx(() => (controller.personalCount.value > 0 ||
                  _authManager.showBadge.value)
              ? Positioned(
                  left: 25,
                  top: 15,
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
                  ),
                )
              : Container())
        ],
      ),
    );
  }

  buildChatLink() {
    return GestureDetector(
      onTap: () {
        if (!_authManager.isLogin()) {
          DialogConstantHelper.showLoginDialog(Get.context!, _authManager);
          return;
        }
        Get.toNamed(ChatDashboardPage.routeName);
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
            child: SvgPicture.asset(
              ImageConstant.icChat,
              color: colorSecondary,
            ),
          ),
          Obx(() => controller.chatCount.value != 0
              ? Positioned(
                  left: 25,
                  top: 15,
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
                    child:
                        const SizedBox() /*Text(
                      controller.chatCount.value.toString(),
                      style: const TextStyle(
                        color: white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    )*/
                    ,
                  ),
                )
              : Container())
        ],
      ),
    );
  }

  circularImage({url, shortName}) {
    return url.toString().isNotEmpty && url != null
        ? Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorLightGray,
                image: DecorationImage(
                    image: NetworkImage(url), fit: BoxFit.contain)),
          )
        : Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorLightGray,
            ),
            child: Center(
                child: CustomTextView(
              text: shortName ?? "",
              textAlign: TextAlign.center,
            )),
          );
  }
}
