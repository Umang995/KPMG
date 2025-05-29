import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/pref_utils.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/dashboard/showLoadingPage.dart';
import 'package:dreamcast/view/travelDesk/controller/hotelController.dart';
import 'package:dreamcast/view/travelDesk/controller/travelDeskController.dart';
import 'package:dreamcast/view/travelDesk/widget/noData.dart';
import 'package:dreamcast/view/travelDesk/widget/commonImageOrPdfWidget.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../widgets/button/common_material_button.dart';
import '../../../widgets/textview/customTextView.dart';

class HotelDetailsWidget extends GetView<HotelController> {
  HotelDetailsWidget({super.key});

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  AuthenticationManager authenticationManager = Get.find();
  TravelDeskController travelDeskController = Get.find();

  // Function to simulate data fetching
  Future<void> _refreshData() async {
    await Future.delayed(
        const Duration(seconds: 1)); // Simulating network request
    controller.travelHotelGetApi(requestBody: {}, isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return GetX<HotelController>(builder: (controller) {
      var details = controller.travelHotelDetails.value.body;
      return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        color: colorPrimary,
        child: Skeletonizer(
            enabled: controller.loader.value,
            child: ListView(
              children: [
                details != null
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        margin: EdgeInsets.symmetric(horizontal: 16.h),
                        decoration: BoxDecoration(
                          color: colorLightGray,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.v),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 16.v,
                                        ),
                                        CustomTextView(
                                          text: "Hotel Name" ?? "",
                                          fontSize: 14,
                                          maxLines: 10,
                                          color: colorGray,
                                          textAlign: TextAlign.start,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        CustomTextView(
                                          text: details.name ?? "",
                                          fontSize: 18,
                                          maxLines: 10,
                                          color: colorSecondary,
                                          textAlign: TextAlign.start,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        CustomTextView(
                                          text: details.bookingId ?? "",
                                          fontSize: 14,
                                          maxLines: 10,
                                          color: colorGray,
                                          textAlign: TextAlign.start,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: InkWell(
                                      onTap: () {
                                        UiHelper.inAppBrowserView(Uri.parse(
                                            details.locationUrl ?? ""));
                                      },
                                      child: SvgPicture.asset(
                                        ImageConstant.ic_location_pointer,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            UiHelper.commonDivider(),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.v),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomTextView(
                                        text: "Check-in" ?? "",
                                        fontSize: 14,
                                        maxLines: 10,
                                        color: colorGray,
                                        textAlign: TextAlign.start,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      CustomTextView(
                                        text: UiHelper.formatDateWithTimezone(
                                            date: details.checkinDate
                                                    .toString() ??
                                                "",
                                            timeZone: PrefUtils
                                                .getTimezone()),
                                        fontSize: 18,
                                        maxLines: 10,
                                        color: colorSecondary,
                                        textAlign: TextAlign.start,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      CustomTextView(
                                        text: UiHelper.formatTimeWithTimezone(
                                            date: details.checkinDate
                                                    .toString() ??
                                                "",
                                            timeZone: PrefUtils
                                                .getTimezone()),
                                        fontSize: 14,
                                        maxLines: 10,
                                        color: colorSecondary,
                                        textAlign: TextAlign.start,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      CustomTextView(
                                        text: "Check-out" ?? "",
                                        fontSize: 14,
                                        maxLines: 10,
                                        color: colorGray,
                                        textAlign: TextAlign.start,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      CustomTextView(
                                        text: UiHelper.formatDateWithTimezone(
                                            date: details.checkoutDate
                                                    .toString() ??
                                                "",
                                            timeZone: PrefUtils
                                                .getTimezone()),
                                        fontSize: 18,
                                        maxLines: 10,
                                        color: colorSecondary,
                                        textAlign: TextAlign.start,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      CustomTextView(
                                        text: UiHelper.formatTimeWithTimezone(
                                            date: details.checkoutDate
                                                    .toString() ??
                                                "",
                                            timeZone: PrefUtils
                                                .getTimezone()),
                                        fontSize: 14,
                                        maxLines: 10,
                                        color: colorSecondary,
                                        textAlign: TextAlign.start,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            UiHelper.commonDivider(),
                            if (details.bookedFor != null &&
                                details.bookedFor != "")
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.v),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomTextView(
                                        text: "Accompanied By" ?? "",
                                        fontSize: 14,
                                        maxLines: 10,
                                        color: colorGray,
                                        textAlign: TextAlign.start,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      CustomTextView(
                                        text: details.bookedFor ?? "",
                                        fontSize: 18,
                                        maxLines: 10,
                                        color: colorSecondary,
                                        textAlign: TextAlign.start,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  )),
                            if (details.bookedFor != null &&
                                details.bookedFor != "")
                              UiHelper.commonDivider(),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.v),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomTextView(
                                          text: "Room No." ?? "",
                                          fontSize: 14,
                                          maxLines: 10,
                                          color: colorGray,
                                          textAlign: TextAlign.start,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        CustomTextView(
                                          text: details.roomNumber ?? "",
                                          fontSize: 18,
                                          maxLines: 10,
                                          color: colorSecondary,
                                          textAlign: TextAlign.start,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        CustomTextView(
                                          text: "No. of Person" ?? "",
                                          fontSize: 14,
                                          maxLines: 10,
                                          color: colorGray,
                                          textAlign: TextAlign.start,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        CustomTextView(
                                          text: details.personCount ?? "",
                                          fontSize: 18,
                                          maxLines: 10,
                                          color: colorSecondary,
                                          textAlign: TextAlign.start,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            UiHelper.commonDivider(),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.v),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextView(
                                      text: "Address" ?? "",
                                      fontSize: 14,
                                      maxLines: 10,
                                      color: colorGray,
                                      textAlign: TextAlign.start,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    CustomTextView(
                                      text: details.address ?? "",
                                      fontSize: 18,
                                      maxLines: 10,
                                      color: colorSecondary,
                                      textAlign: TextAlign.start,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                )),
                            if (controller.travelHotelDetails.value.body
                                        ?.hotelPdf !=
                                    null &&
                                controller.travelHotelDetails.value.body
                                        ?.hotelPdf !=
                                    "")
                              SizedBox(
                                height: 10.v,
                              ),
                            if (controller.travelHotelDetails.value.body
                                        ?.hotelPdf !=
                                    null &&
                                controller.travelHotelDetails.value.body
                                        ?.hotelPdf !=
                                    "")
                              CommonImageOrPdfWidget(
                                fileUrl: details.hotelPdf ?? "",
                                title: "Hotel Details",
                              ),
                            if (false)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 31),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: CommonMaterialButton(
                                    color: colorPrimary,
                                    isLoading: false,
                                    text: "download_hotel_details".tr,
                                    textSize: 16,
                                    iconHeight: 19,
                                    svgIcon: ImageConstant.download_icon,
                                    onPressed: () {
                                      // Add your functionality here
                                      travelDeskController.pdfDownload(
                                          fileName: "Hotel Details",
                                          networkPath: controller
                                                  .travelHotelDetails
                                                  .value
                                                  .body
                                                  ?.hotelPdf ??
                                              "");
                                    },
                                  ),
                                ),
                              ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ))
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.h),
                        child: NoData(
                          heading: "Hotel Details",
                          title: "noDetailsFound".tr,
                          description:
                              controller.travelHotelDetails.value.message ?? "",
                          image: ImageConstant.noDataFound,
                          slug: MyConstant.hotel,
                          isAddButton: false,
                        ),
                      ),
              ],
            )),
      );
    });
  }
}
