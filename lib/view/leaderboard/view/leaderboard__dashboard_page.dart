import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/toolbarTitle.dart';
import '../controller/leaderboard_controller.dart';
import 'criterias_page.dart';
import 'my_points_page.dart';
import 'leaderboard_home.dart';

class LeaderboardDashboardPage extends StatefulWidget {
  const LeaderboardDashboardPage({Key? key}) : super(key: key);
  static const routeName = "/LeaderBoardPage";

  @override
  State<LeaderboardDashboardPage> createState() => _LeaderboardDashboardPage();
}

class _LeaderboardDashboardPage extends State<LeaderboardDashboardPage>
    with SingleTickerProviderStateMixin {
  var tabList = ["Leaderboard", "Criteria", "My Points"];
  final LeaderboardController leaderboardController = Get.find();
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabBarTheme = Theme.of(context).tabBarTheme;
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
        title: ToolbarTitle(title: Get.arguments?[MyConstant.titleKey] ?? ""),
      ),
      body: DefaultTabController(
        length: tabList.length,
        child: Scaffold(
          appBar: TabBar(
            dividerColor: Colors.transparent,
            isScrollable: true,
            labelColor: colorSecondary,
            indicatorColor: Colors.transparent,
            tabAlignment: TabAlignment.center,
            indicatorSize: TabBarIndicatorSize.tab,
            onTap: (index) {
              leaderboardController.tabController.index = index;
              leaderboardController.selectedTabIndex(index);
              if (index == 0) {
                leaderboardController.getRankApi(isRefresh: false);
              }
              if (index == 1) {
                leaderboardController.getCriteriaApi(isRefresh: false);
              } else if (index == 2) {
                leaderboardController.getMyCriteriaApi(isRefresh: false);
              }
            },
            tabs: <Widget>[
              ...List.generate(
                tabList.length,
                (index) => Obx(
                  () => Tab(
                    child: Text(
                      tabList[index],
                      style: TextStyle(
                          color: leaderboardController.selectedTabIndex.value ==
                                  index
                              ? colorPrimary
                              : colorGray),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  child: TabBarView(
                controller: leaderboardController.tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const LeaderboardHome(),
                  CriteriasPage(),
                  MyPointsPage(),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
