
import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/travelDesk/controller/passportController.dart';
import 'package:dreamcast/view/travelDesk/controller/travelDeskController.dart';
import 'package:dreamcast/view/travelDesk/view/travelSaveFormPage.dart';
import 'package:dreamcast/view/travelDesk/widget/noData.dart';
import 'package:dreamcast/view/travelDesk/widget/commonImageOrPdfWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../utils/pref_utils.dart';
import '../../../widgets/textview/customTextView.dart';

class PassportWidget extends GetView<PassportController> {
  PassportWidget({super.key});

  AuthenticationManager authenticationManager = Get.find();
  TravelDeskController travelDeskController = Get.find();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Function to simulate data fetching
  Future<void> _refreshData() async {
    await Future.delayed(
        const Duration(seconds: 1)); // Simulating network request
    controller.callApi(true);
  }

  @override
  Widget build(BuildContext context) {
    return GetX<PassportController>(builder: (controller) {
      var details = controller.travelPassportDetails.value.body?.passportInfo;
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
                          margin: EdgeInsets.symmetric(horizontal: 16.h),
                          decoration: BoxDecoration(
                            color: colorLightGray,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                   Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 17),
                                    child: CustomTextView(
                                      text: "Passport Details" ?? "",
                                      fontSize: 18,
                                      maxLines: 10,
                                      color: colorPrimary,
                                      textAlign: TextAlign.start,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(TravelSaveFormPage.routeName,
                                          arguments: {
                                            "type": MyConstant.passport,
                                          });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 25, top: 16, bottom: 16),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 14),
                                          decoration: BoxDecoration(
                                            color: white,
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            border: Border.all(
                                                color: borderColor),
                                          ),
                                          child: SvgPicture.asset(
                                            ImageConstant.editIcon,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              UiHelper.commonDivider(),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 25.h, right: 25.h, bottom: 25.v),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                         CustomTextView(
                                          text: "Name" ?? "",
                                          fontSize: 16,
                                          maxLines: 10,
                                          color: colorGray,
                                          textAlign: TextAlign.start,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        CustomTextView(
                                          text: details.passportName ?? "",
                                          fontSize: 18,
                                          maxLines: 10,
                                          color: colorSecondary,
                                          textAlign: TextAlign.start,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                    UiHelper.commonDivider(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                             CustomTextView(
                                              text: "Passport Number" ?? "",
                                              fontSize: 14,
                                              maxLines: 10,
                                              color: colorGray,
                                              textAlign: TextAlign.start,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            CustomTextView(
                                              text: details.number ?? "",
                                              fontSize: 18,
                                              maxLines: 10,
                                              color: colorSecondary,
                                              textAlign: TextAlign.start,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    UiHelper.commonDivider(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                               CustomTextView(
                                                text: "Valid From" ?? "",
                                                fontSize: 14,
                                                maxLines: 10,
                                                color: colorGray,
                                                textAlign: TextAlign.start,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              CustomTextView(
                                                text:
                                                UiHelper.formatDateWithTimezone(
                                              date: details.validFrom !=null
                                                  ? details.validFrom.toString() : "",
                                              timeZone: PrefUtils.getTimezone())
                                                ,
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
                                                CrossAxisAlignment.start,
                                            children: [
                                               CustomTextView(
                                                text: "Valid Till" ?? "",
                                                fontSize: 14,
                                                maxLines: 10,
                                                color: colorGray,
                                                textAlign: TextAlign.start,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              CustomTextView(
                                                text: UiHelper.formatDateWithTimezone(
                                              date: details.validTill !=null ? details.validTill.toString() : "",
                                              timeZone: PrefUtils.getTimezone()),
                                                fontSize: 18,
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
                                  ],
                                ),
                              ),
                              if((details.frontFile != null && details.frontFile != "") ||
                                  (details.backFile != null && details.backFile != ""))
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 25.h, right: 25.h, bottom: 25.v),
                                child: Column(
                                  children: [
                                      if(details.frontFile != null && details.frontFile != "")
                                        CommonImageOrPdfWidget(
                                      fileUrl: details.frontFile ?? "",
                                      title: "Passport Front Details" ?? "",
                                    ),
                                    if (details.backFile != null && details.backFile != "")
                                    SizedBox(
                                      height: 20.v,
                                    ),
                                    if (details.backFile != null && details.backFile != "")
                                      CommonImageOrPdfWidget(
                                        fileUrl: details.backFile ?? "",
                                      title: "Passport Back Details" ?? "",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                        : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.h),
                          child: NoData(
                            heading: "Passport Details",
                            title: "noDetailsFound".tr,
                            description: controller.travelPassportDetails.value.body?.message ?? "Please fill your details by clicking below button",
                            image: ImageConstant.noDataFound,
                            slug: MyConstant.passport,
                            isAddButton: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
    });
  }
}
