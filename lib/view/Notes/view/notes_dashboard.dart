import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/Notes/controller/my_notes_controller.dart';
import 'package:dreamcast/view/Notes/view/notes_list.dart';
import 'package:dreamcast/widgets/app_bar/appbar_leading_image.dart';
import 'package:dreamcast/widgets/app_bar/custom_app_bar.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/my_constant.dart';

class NotesDashboard extends GetView<MyNotesController> {
  NotesDashboard({super.key});

  static const routeName = "/MyNotesPage";
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
            title: Get.arguments?[MyConstant.titleKey] ?? "my_note".tr),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: buildNotesTypeTab(),
      ),
    );
  }

  buildNotesTypeTab() {
    return Obx(
      () => Stack(
        children: [
          DefaultTabController(
            length: controller.tabList.length,
            initialIndex: controller.selectedTabIndex.value,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: IgnorePointer(
                  ignoring: controller.firstLoading.value,
                  child: TabBar(
                    controller: controller.tabController,
                    dividerColor: Colors.transparent,
                    isScrollable: true,
                    padding: EdgeInsets.zero,
                    indicatorColor: Colors.transparent,
                    tabAlignment: TabAlignment.center,
                    onTap: (index) {
                      controller.selectedTabIndex(index);
                      controller.callApis(index);
                    },
                    tabs: List.generate(
                      controller.tabList.length,
                      (index) => Tab(
                        text: controller.tabList[index],
                        // All Sessions
                      ),
                    ),
                  ),
                ),
              ),
              body: TabBarView(
                physics:
                    const NeverScrollableScrollPhysics(), // Disables swipe navigation
                controller: controller.tabController,
                children: List.generate(
                    controller.tabList.length,
                    (index) => CommonNotesPage(
                          index: index,
                        )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
