import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/bestForYou/view/aiMatch_dashboard_page.dart';
import 'package:dreamcast/view/breifcase/controller/common_document_controller.dart';
import 'package:dreamcast/view/breifcase/view/resourceCenter.dart';
import 'package:dreamcast/view/eventFeed/controller/eventFeedController.dart';
import 'package:dreamcast/view/home/controller/home_controller.dart';
import 'package:dreamcast/view/home/model/config_detail_model.dart';
import 'package:dreamcast/view/partners/controller/partnersController.dart';
import 'package:dreamcast/view/partners/view/partnersDetailPage.dart';
import 'package:dreamcast/view/quiz/view/quiz_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../routes/my_constant.dart';
import '../theme/app_colors.dart';
import '../view/eventFeed/view/feedListPage.dart';
import '../view/partners/view/partnersPage.dart';
import 'textview/customTextView.dart';

class LaunchpadMenuLabel extends GetView<HomeController> {
  String title = "";
  String trailing = "";
  String trailingIcon = "";
  int index = 0;
  LaunchpadMenuLabel({
    super.key,
    required this.title,
    required this.trailing,
    required this.index,
    required this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        // padding: EdgeInsets.only(bottom: 15.adaptSize, top: index==15?6:30.adaptSize),
        padding: EdgeInsets.only(bottom: 15.adaptSize),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomTextView(
                text: title,
                color: colorSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 22,
                textAlign: TextAlign.start,
              ),
            ),
            GestureDetector(
                onTap: () {
                  switch (index) {
                    case 1:
                      Get.toNamed(AiMatchDashboardPage.routeName);
                      break;
                    case 15:
                      Get.toNamed(AiMatchDashboardPage.routeName);
                      break;
                    case 2:
                      if (Get.isRegistered<SponsorPartnersController>()) {
                        SponsorPartnersController controller = Get.find();
                        controller.allSponsorsPartnersListApi(requestBody: {
                          "limited_mode": false,
                        }, isRefresh: true);
                      }
                      Get.toNamed(SponsorsList.routeName,
                          arguments: {MyConstant.titleKey: title});
                      break;
                    case 3:
                      if (Get.isRegistered<CommonDocumentController>()) {
                        CommonDocumentController controller = Get.find();
                        controller.getDocumentList(
                            isRefresh: false, limitedMode: false);
                      }
                      Get.toNamed(ResourceCenterListPage.routeName);
                      break;
                    case 4:
                      controller.refreshOpenSocialWall(isGotoSocialWall: true);
                      break;
                    case 5:
                      if (Get.isRegistered<EventFeedController>()) {
                        EventFeedController controller = Get.find();
                        controller.getEventFeed(isLimited: false);
                        Get.toNamed(SocialFeedListPage.routeName);
                      }
                      break;
                  }
                },
                child: trailingIcon.toString().isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(right: 5.h),
                        child: SvgPicture.asset(
                          trailingIcon,
                          height: 15,
                        ),
                      )
                    : CustomTextView(
                        text: trailing,
                        color: colorPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16))
          ],
        ));
  }
}
