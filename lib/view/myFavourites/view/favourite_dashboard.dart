import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:dreamcast/view/myFavourites/controller/favourite_controller.dart';
import 'package:dreamcast/view/myFavourites/view/favourite_exhibitors_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';

import '../../../theme/app_decoration.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_search_view.dart';
import '../../../widgets/toolbarTitle.dart';
import 'favourite_attendee_page.dart';
import 'favourite_session_page.dart';
import 'favourite_speaker_page.dart';

class BookmarkDashboard extends GetView<FavouriteController> {
  BookmarkDashboard({
    super.key,
  });
  static const routeName = "/AllEventList";
  final DashboardController dashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetX<FavouriteController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: CustomAppBar(
            height: 0.v,
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
            title: ToolbarTitle(title: "favourites".tr),
            backgroundColor: colorLightGray,
            dividerHeight: 0,
          ),
          body: Padding(
            padding: AppDecoration.commonTabPadding(),
            child: DefaultTabController(
              initialIndex: controller.tabIndex.value ?? 0,
              length: controller.tabList.length,
              child: Scaffold(
                appBar: TabBar(
                  dividerColor: Colors.transparent,
                  isScrollable: true,
                  indicatorColor: Colors.transparent,
                  tabAlignment: TabAlignment.start,
                  onTap: (index) {
                    controller.tabIndex(index);
                    controller.tabIndexAndSearch(true);
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
                          FavouriteAttendeePage(),
                          FavouriteSessionPage(
                            isFromBookmarkSection: true,
                          ),
                          FavouriteSpeakerPage(),
                          FavouriteExhibitorsPage(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
          if (result.isNotEmpty) {
            FocusManager.instance.primaryFocus?.unfocus();
            controller.textController.refresh();
            controller.tabIndexAndSearch(true);
          }
        },
        onChanged: (result) {
          if (result.isEmpty) {
            Future.delayed(const Duration(seconds: 1), () {
              controller.tabIndexAndSearch(true);
            });
          }
        },
        onClear: (result) {
          FocusManager.instance.primaryFocus?.unfocus();
          controller.textController.refresh();
          controller.tabIndexAndSearch(true);
        },
        press: () async {},
      ),
    );
  }
}
