import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/travelDesk/controller/travelDeskController.dart';
import 'package:dreamcast/view/travelDesk/view/cabDetailsPage.dart';
import 'package:dreamcast/view/travelDesk/view/flightDetailsPage.dart';
import 'package:dreamcast/view/travelDesk/view/hotelDetailsPage.dart';
import 'package:dreamcast/view/travelDesk/view/passportDetailsPage.dart';
import 'package:dreamcast/view/travelDesk/view/visaDetailsPage.dart';
import 'package:dreamcast/widgets/app_bar/appbar_leading_image.dart';
import 'package:dreamcast/widgets/app_bar/custom_app_bar.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/my_constant.dart';

class TravelDashboardPage extends GetView<TravelDeskController> {
  TravelDashboardPage({super.key});

  static const routeName = "/TravelDeskPage";
  final travelDeskController = Get.put(TravelDeskController());

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
        title: ToolbarTitle(title: "travelDesk".tr),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: DefaultTabController(
          initialIndex: 0,
          length: controller.tabList.length,
          child: Scaffold(
            appBar: TabBar(
              dividerColor: Colors.transparent,
              isScrollable: true,
              labelColor: colorPrimary,
              indicatorColor: Colors.transparent,
              tabAlignment: TabAlignment.start,
              onTap: (index) {
                controller.callApi(index, false);
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
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                ...List.generate(
                  controller.tabList.length,
                  (index) => controller.tabList[index] == "Flight Details"
                      ? FlightDetailsWidget()
                      : controller.tabList[index] == "Cab Details"
                          ? CabDetailsWidget()
                          : controller.tabList[index] == "Hotel Details"
                              ? HotelDetailsWidget()
                              : controller.tabList[index] == "Visa Details"
                                  ? VisaDetailsWidget()
                                  : controller.tabList[index] == "Passport"
                                      ? PassportWidget()
                                      : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
