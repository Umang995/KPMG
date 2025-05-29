import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/dashboard/showLoadingPage.dart';
import 'package:dreamcast/view/home/screen/pdfViewer.dart';
import 'package:dreamcast/view/travelDesk/controller/flightController.dart';
import 'package:dreamcast/view/travelDesk/controller/travelSaveFormController.dart';
import 'package:dreamcast/view/travelDesk/controller/travelDeskController.dart';
import 'package:dreamcast/view/travelDesk/view/travelSaveFormPage.dart';
import 'package:dreamcast/view/travelDesk/view/travelDeskPage.dart';
import 'package:dreamcast/view/travelDesk/widget/flightDataWidget.dart';
import 'package:dreamcast/view/travelDesk/widget/noData.dart';
import 'package:dreamcast/view/travelDesk/widget/noDataFoundWidget.dart';
import 'package:dreamcast/widgets/button/common_material_button.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../model/travelFlightGetModel.dart';

class FlightDetailsWidget extends GetView<FlightController> {
  FlightDetailsWidget({super.key});

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  AuthenticationManager authenticationManager = Get.find();
  TravelDeskController travelDeskController = Get.find();

  // Function to simulate data fetching
  Future<void> _refreshData() async {
    await Future.delayed(
        const Duration(seconds: 1)); // Simulating network request
    controller.travelFlightGetApi(requestBody: {}, isRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    return GetX<FlightController>(builder: (controller) {
      var details = controller.travelFlightDetails.value.body?.flightInfo;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refreshData,
          color: colorPrimary,
          child: Skeletonizer(
            enabled: controller.loader.value,
            child: ListView(
              children: [
                details != null &&
                        details.arrival != null &&
                        details.arrival != ""
                    ? FlightDataWidget(
                        slug: MyConstant.flightArrival,
                        title: "arrivalDetails".tr,
                        data: details.arrival!)
                    : NoData(
                        heading: "arrivalDetails".tr,
                        title: "noDetailsFound".tr,
                        description: controller.travelFlightDetails.value.body?.message ?? "fillDetailsBelowButton".tr,
                        image: ImageConstant.noDataFound,
                        slug: MyConstant.flightArrival,
                        isAddButton:
                            controller.travelFlightDetails.value.body?.isAdd ==
                                    true
                                ? true
                                : true,
                      ),

                ///**************************************************************************************************
                const SizedBox(height: 20),

                details != null &&
                        details.departure != null &&
                        details.departure != ""
                    ? FlightDataWidget(
                        title: "departureDetails".tr,
                        slug: MyConstant.flightDeparture,
                        data: details.departure.toString().isEmpty
                            ? Arrival()
                            : details.departure)
                    : NoData(
                        heading: "departureDetails".tr,
                        title: "noDetailsFound".tr,
                        description: controller.travelFlightDetails.value.body?.message ?? "fillDetailsBelowButton".tr,
                        image: ImageConstant.noDataFound,
                        slug: MyConstant.flightDeparture,
                        isAddButton:
                            controller.travelFlightDetails.value.body?.isAdd ==
                                    true
                                ? true
                                : true,
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    });
  }
}
