import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:dreamcast/view/home/controller/home_controller.dart';
import 'package:dreamcast/view/myFavourites/view/for_you_dashboard.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../routes/my_constant.dart';
import '../../theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../view/account/controller/account_controller.dart';
import '../../view/account/view/account_page.dart';
import '../../view/bestForYou/view/aiMatch_dashboard_page.dart';
import '../../view/meeting/view/meeting_dashboard_page.dart';
import '../../view/menu/model/menu_data_model.dart';
import '../../view/myFavourites/view/favourite_dashboard.dart';
import '../../view/qrCode/view/qr_dashboard_page.dart';
import 'home_menu_widget.dart';

class HomeHeaderMenuWidget extends GetView<HomeController> {
  HomeHeaderMenuWidget({super.key});
  DashboardController _dashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Skeletonizer(
            enabled: controller.menuHorizontalHome.isEmpty ? true : false,
            child: GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.menuHorizontalHome.isNotEmpty
                  ? controller.menuHorizontalHome.length
                  : 4,
              itemBuilder: (context, index) {
                if (controller.menuHorizontalHome.isEmpty) {
                  return HomeMenuSkeleton();
                }
                MenuData data = controller.menuHorizontalHome[index];
                return HomeMenuWidget(menuData: data);
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 5 / 7,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 22),
            )),
      ],
    );
  }
}
