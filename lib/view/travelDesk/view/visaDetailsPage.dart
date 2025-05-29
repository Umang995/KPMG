import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/travelDesk/controller/travelDeskController.dart';
import 'package:dreamcast/view/travelDesk/controller/visaController.dart';
import 'package:dreamcast/view/travelDesk/view/travelSaveFormPage.dart';
import 'package:dreamcast/view/travelDesk/widget/noData.dart';
import 'package:dreamcast/view/travelDesk/widget/commonImageOrPdfWidget.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../theme/ui_helper.dart';
import '../../../widgets/textview/customTextView.dart';

class VisaDetailsWidget extends GetView<VisaController> {
  VisaDetailsWidget({super.key});

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
    return GetX<VisaController>(builder: (controller) {
      return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        color: colorPrimary,
        child: Skeletonizer(
          enabled: controller.loader.value,
          child: ListView(
            children: [
              controller.travelVisaDetails.value.body != null &&
                      controller.travelVisaDetails.value.body!.visaFile !=
                          null &&
                      controller.travelVisaDetails.value.body!.visaFile != ""
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.h),
                      //padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: colorLightGray,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 25, top: 16, bottom: 16),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: CustomTextView(
                                    text: "Add Visa Details",
                                    fontSize: 18,
                                    maxLines: 10,
                                    color: colorPrimary,
                                    textAlign: TextAlign.start,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.toNamed(TravelSaveFormPage.routeName,
                                      arguments: {
                                        "type": MyConstant.visa,
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
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(color: borderColor),
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
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                if (controller.travelVisaDetails.value.body
                                            ?.visaFile !=
                                        null &&
                                    controller.travelVisaDetails.value.body
                                            ?.visaFile !=
                                        "")
                                  Column(
                                    children: [
                                      CustomTextView(
                                        text:
                                            "Your Visa is ready so you can download your copy by clicking below button" ??
                                                "",
                                        fontSize: 16,
                                        maxLines: 10,
                                        color: colorSecondary,
                                        textAlign: TextAlign.center,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      if (controller.travelVisaDetails.value
                                                  .body?.visaFile !=
                                              null &&
                                          controller.travelVisaDetails.value
                                                  .body?.visaFile !=
                                              "")
                                        CommonImageOrPdfWidget(
                                          fileUrl: controller.travelVisaDetails
                                                  .value.body?.visaFile ??
                                              "",
                                          title: "Visa Details" ?? "",
                                        ),
                                    ],
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
                        heading: "Visa Details",
                        title: "noDetailsFound".tr,
                        description:
                            controller.travelVisaDetails.value.message ??
                                "visaDescription".tr,
                        image: ImageConstant.noDataFound,
                        slug: MyConstant.visa,
                        buttonTitle: "uploadVisa".tr,
                        isAddButton:
                            controller.travelVisaDetails.value.body?.isAdd ==
                                    true
                                ? true
                                : true,
                      ),
                    ),
            ],
          ),
        ),
      );
    });
  }
}
