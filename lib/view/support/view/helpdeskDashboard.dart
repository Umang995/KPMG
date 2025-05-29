import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/support/controller/faq_controller.dart';
import 'package:dreamcast/view/support/controller/supportController.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:dreamcast/view/support/view/sos_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';
import '../../../utils/dialog_constant.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/dialog/custom_dialog_widget.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../guide/controller/info_guide_controller.dart';
import '../controller/helpdesk_dashboard_controller.dart';
import 'faq_list_page.dart';
import 'techSupportPage.dart';

class HelpDeskDashboard extends GetView<HelpdeskDashboardController> {
  static const routeName = "/HelpDeskDashboard";
  final bool showToolbar;

  HelpDeskDashboard({Key? key, required this.showToolbar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        height: 72.v,
        leadingWidth: 45.h,
        leading: AppbarLeadingImage(
          imagePath: ImageConstant.imgArrowLeft,
          margin: EdgeInsets.only(left: 7.h, top: 3),
          onTap: Get.back,
        ),
        title: ToolbarTitle(
          title: Get.arguments?[MyConstant.titleKey] ?? "helpDesk".tr,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              controller: controller.tabController,
              isScrollable: true,
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              tabAlignment: TabAlignment.start,
              tabs: List.generate(
                controller.tabList.length,
                (index) => Tab(text: controller.tabList[index]),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  FaqListPage(),
                  SOSInfoPag(),
                  TechSupportPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
