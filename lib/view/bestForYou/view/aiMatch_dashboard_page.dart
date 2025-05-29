import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/bestForYou/view/aiMatch_session_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';

import '../../../routes/my_constant.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_search_view.dart';
import '../../../widgets/toolbarTitle.dart';
import '../controller/aiMatchController.dart';
import 'aiMatch_speakers_page.dart';
import 'aiMatches_exhibitor_page.dart';
import 'aiMatches_user_page.dart';

class AiMatchDashboardPage extends GetView<AiMatchController> {
  const AiMatchDashboardPage({super.key});
  static const routeName = "/AiMatchDashboard";

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
        title: ToolbarTitle(
            title: Get.arguments?[MyConstant.titleKey] ?? "aimatches".tr),
      ),
      body: GetX<AiMatchController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: DefaultTabController(
              initialIndex:
                  controller.dashboardController.selectedAiMatchIndex.value,
              length: controller.tabList.length,
              child: Scaffold(
                appBar: TabBar(
                  dividerColor: Colors.transparent,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  onTap: (index) {
                    controller.getDataByIndexPage(index);
                    controller.dashboardController.selectedAiMatchIndex(index);
                  },
                  tabs: <Widget>[
                    ...List.generate(
                      controller.tabList.length,
                      (index) => Tab(
                        text: controller.tabList[index],
                      ),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    searchViewWidget(),
                    Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          AiMatchUserPage(),
                          AiMatchExhibitorPage(),
                          AiMatchesSpeakerPage(),
                          AiMatchSessionPage(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget searchViewWidget() {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 6, bottom: 6),
      margin: EdgeInsets.only(
        left: 0.h,
        right: 0.h,
      ),
      child: NewCustomSearchView(
        isShowFilter: false,
        hintText: "search_here".tr,
        controller: controller.textController.value,
        onSubmit: (result) {
          controller.textController.refresh();
          if (result.isNotEmpty) {
            FocusManager.instance.primaryFocus?.unfocus();
            controller.getDataByIndexPage(
                controller.dashboardController.selectedAiMatchIndex.value);
          }
        },
        onClear: (result) {
          controller.textController.refresh();
          FocusManager.instance.primaryFocus?.unfocus();
          controller.getDataByIndexPage(
              controller.dashboardController.selectedAiMatchIndex.value);
        },
        press: () async {},
      ),
    );
  }
}
