import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/alert/controller/alert_controller.dart';
import 'package:dreamcast/view/alert/pages/alert_general_page.dart';
import 'package:dreamcast/view/alert/pages/alert_personal_page.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/toolbarTitle.dart';

class AlertDashboard extends GetView<AlertController> {
  AlertDashboard({Key? key}) : super(key: key);
  static const routeName = "/alert";

  @override
  final controller = Get.put(AlertController());
  var tabList = ["General", "Personal"];

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
        title: ToolbarTitle(title: "notification".tr),
      ),
      body: GetX<DashboardController>(
        builder: (dashboardController) {
          return DefaultTabController(
            initialIndex: controller.tabIndex.value,
            length: tabList.length,
            child: Scaffold(
              appBar: TabBar(
                dividerColor: colorLightGray,
                isScrollable: false,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: colorPrimary,
                unselectedLabelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: colorGray),
                labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: colorPrimary),
                onTap: (index) {
                  controller.tabController.index = index;
                  controller.tabIndex(index);
                  controller.reverseTheList(index);
                },
                tabs: <Widget>[
                  ...List.generate(
                    tabList.length,
                    (index) => Tab(
                        height: 52,
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 20.0, top: 0, left: 20),
                              child: CustomTextView(
                                text: tabList[index],
                                fontSize: 21,
                                color: controller.tabIndex.value == index
                                    ? colorPrimary
                                    : colorGray,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            dashboardController.personalCount.value > 0 &&
                                    index == 1
                                ? Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: borderColor,
                                          shape: BoxShape.circle,
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 16,
                                          minHeight: 16,
                                        ),
                                        child: Text(
                                          dashboardController
                                              .personalCount.value
                                              .toString(),
                                          style: TextStyle(
                                            color: colorPrimary,
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center,
                                        )),
                                  )
                                : const SizedBox.shrink()
                          ],
                        )),
                  ),
                ],
              ),
              body: TabBarView(
                controller: controller.tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  AlertGeneralPage(),
                  AlertPersonalPage(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
