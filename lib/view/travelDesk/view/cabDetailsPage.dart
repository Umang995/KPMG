import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/dashboard/showLoadingPage.dart';
import 'package:dreamcast/view/travelDesk/controller/cabController.dart';
import 'package:dreamcast/view/travelDesk/controller/travelDeskController.dart';
import 'package:dreamcast/view/travelDesk/widget/noData.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CabDetailsWidget extends GetView<CabController> {
  CabDetailsWidget({super.key});

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Function to simulate data fetching
  Future<void> _refreshData() async {
    await Future.delayed(
        const Duration(seconds: 1)); // Simulating network request
    controller.travelCabGetApi(requestBody: {}, isRefresh: true);
  }

  TravelDeskController travelDeskController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetX<CabController>(builder: (controller) {
      var isNoData =
      controller.travelCabDetails.value.body != null ? true : false;
      var details = controller.travelCabDetails.value.body;
      return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        color: colorPrimary,
        child: Skeletonizer(
          enabled: controller.loader.value,
          child: ListView(
            children: [
              details !=null &&
                  details.pickupCabNumber !=null &&
                  details.pickupName !=null
                  ? Container(
                margin: EdgeInsets.symmetric(horizontal: 16.h),
                decoration: BoxDecoration(
                  color: colorLightGray,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                     Padding(
                      padding: EdgeInsets.only(
                          left: 25, top: 16, bottom: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomTextView(
                          text: "Pickup Details" ?? "",
                          fontSize: 18,
                          maxLines: 10,
                          color: colorPrimary,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    UiHelper.commonDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(
                                vertical: 8),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                   CustomTextView(
                                    text: "Contact Person" ??
                                        "",
                                    fontSize: 16,
                                    maxLines: 10,
                                    color: colorGray,
                                    textAlign:
                                    TextAlign.start,
                                    fontWeight:
                                    FontWeight.normal,
                                  ),
                                  CustomTextView(
                                    text: details.pickupName ??
                                        "",
                                    fontSize: 18,
                                    maxLines: 10,
                                    color: colorSecondary,
                                    textAlign:
                                    TextAlign.start,
                                    fontWeight:
                                    FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          UiHelper.commonDivider(),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(
                                vertical: 8),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                   CustomTextView(
                                    text: "Cab Number" ?? "",
                                    fontSize: 14,
                                    maxLines: 10,
                                    color: colorGray,
                                    textAlign:
                                    TextAlign.start,
                                    fontWeight:
                                    FontWeight.w500,
                                  ),
                                  CustomTextView(
                                    text: details.pickupCabNumber ??
                                        "",
                                    fontSize: 18,
                                    maxLines: 10,
                                    color: colorSecondary,
                                    textAlign:
                                    TextAlign.start,
                                    fontWeight:
                                    FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          UiHelper.commonDivider(),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(
                                vertical: 8),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                   CustomTextView(
                                    text: "Contact Number" ??
                                        "",
                                    fontSize: 14,
                                    maxLines: 10,
                                    color: colorGray,
                                    textAlign:
                                    TextAlign.start,
                                    fontWeight:
                                    FontWeight.w500,
                                  ),
                                  CustomTextView(
                                    text: details.pickupNumber ??
                                        "",
                                    fontSize: 18,
                                    maxLines: 10,
                                    color: colorSecondary,
                                    textAlign:
                                    TextAlign.start,
                                    fontWeight:
                                    FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: NoData(
                      heading: "Pickup Details",
                      title: "noDetailsFound".tr,
                description: controller.travelCabDetails.value.message ?? "",
                image: ImageConstant.noDataFound,
                      slug: MyConstant.cab,
                      isAddButton: false,
                    ),
            ),
              details !=null &&
                  details.dropoffCabNumber !=null &&
                  details.dropoffNumber !=null
                  ? Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorLightGray,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                     Padding(
                      padding: EdgeInsets.only(
                          left: 25, top: 16, bottom: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomTextView(
                          text: "Drop Off Details" ?? "",
                          fontSize: 18,
                          maxLines: 10,
                          color: colorPrimary,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    UiHelper.commonDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(
                                vertical: 8),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                   CustomTextView(
                                    text: "Contact Person" ??
                                        "",
                                    fontSize: 16,
                                    maxLines: 10,
                                    color: colorGray,
                                    textAlign:
                                    TextAlign.start,
                                    fontWeight:
                                    FontWeight.normal,
                                  ),
                                  CustomTextView(
                                    text: details.dropoffName ??
                                        "",
                                    fontSize: 18,
                                    maxLines: 10,
                                    color: colorSecondary,
                                    textAlign:
                                    TextAlign.start,
                                    fontWeight:
                                    FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          UiHelper.commonDivider(),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(
                                vertical: 8),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                   CustomTextView(
                                    text: "Cab Number" ?? "",
                                    fontSize: 14,
                                    maxLines: 10,
                                    color: colorGray,
                                    textAlign:
                                    TextAlign.start,
                                    fontWeight:
                                    FontWeight.w500,
                                  ),
                                  CustomTextView(
                                    text: details.dropoffCabNumber ??
                                        "",
                                    fontSize: 18,
                                    maxLines: 10,
                                    color: colorSecondary,
                                    textAlign:
                                    TextAlign.start,
                                    fontWeight:
                                    FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          UiHelper.commonDivider(),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(
                                vertical: 8),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                   CustomTextView(
                                    text: "Contact Number" ??
                                        "",
                                    fontSize: 14,
                                    maxLines: 10,
                                    color: colorGray,
                                    textAlign:
                                    TextAlign.start,
                                    fontWeight:
                                    FontWeight.w500,
                                  ),
                                  CustomTextView(
                                    text: details.dropoffNumber ??
                                        "",
                                    fontSize: 18,
                                    maxLines: 10,
                                    color: colorSecondary,
                                    textAlign:
                                    TextAlign.start,
                                    fontWeight:
                                    FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
                  : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: NoData(
                                    heading: "Drop Off Details",
                                    title: "noDetailsFound".tr,
                                    description: controller.travelCabDetails.value.message ?? "",
                                    image: ImageConstant.noDataFound,
                                    slug: MyConstant.cab,
                                    isAddButton: false,
                                  ),
                  ),
            ],
          )
        ),
      );
    });
  }

}
