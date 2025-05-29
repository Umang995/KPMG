import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../theme/ui_helper.dart';
import '../../utils/image_constant.dart';
import '../textview/customTextView.dart';
import '../location_map_view.dart';

class HomeLocationWidget extends GetView<HomeController> {
  const HomeLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) {
        return Container(
          margin: const EdgeInsets.only(top: 45),
          padding: EdgeInsets.all(15.adaptSize),
          width: context.width,
          decoration:  BoxDecoration(
            color: colorLightGray,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextView(
                          text: "venue".tr,
                          color: colorSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 6.v,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                      ImageConstant.venue,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12.h,
                                  ),
                                  Expanded(
                                    child: CustomTextView(
                                      text: controller.configDetailBody.value
                                              .location?.text ??
                                          "",
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                      color: colorSecondary,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              child: GestureDetector(
                                  onTap: () {
                                    UiHelper.inAppBrowserView(Uri.parse(
                                        controller.configDetailBody.value
                                                .location?.url ??
                                            ""));
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(6),
                                      child: SvgPicture.asset(
                                        ImageConstant.ic_location_pointer,
                                      ))),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 14.v,
              ),
              SizedBox(
                  height: 300.adaptSize,
                  child: controller.configDetailBody.value.location?.map !=
                              null &&
                          controller
                              .configDetailBody.value.location!.map!.isNotEmpty
                      ? LocationMapViewWidget(
                          key: UniqueKey(),
                          url:
                              controller.configDetailBody.value.location?.map ??
                                  "")
                      : const SizedBox())
            ],
          ),
        );
      },
    );
  }
}
