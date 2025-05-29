import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../../widgets/app_bar/custom_app_bar.dart';
import '../../../../widgets/button/custom_icon_button.dart';
import '../../controller/angelHallController.dart';
import '../../model/angelAllyModel.dart';

class AngelAllyDetailPage extends GetView<AngelHallController> {
  AngelBody sessions;
  AngelAllyDetailPage({super.key, required this.sessions});
  static const routeName = "/AngelAllyDetailPage";

  @override
  Widget build(BuildContext context) {
    /*used for header title*/
    return Scaffold(
      backgroundColor: colorLightGray,
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
        title: ToolbarTitle(title: "details".tr),
        backgroundColor: white,
        dividerHeight: 1,
      ),
      body: Container(
          width: context.width,
          height: context.height,
          color: white,
          child: GetX<AngelHallController>(
            builder: (controller) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          bodyHeader(),
                          descriptionView(),
                          SizedBox(
                            height: 120.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                  controller.loading.value ? const Loading() : const SizedBox(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                      child: CustomIconButton(
                        onTap: () {
                          if(sessions.isBooked.toString() == "1"){
                            return;
                          }
                          controller.showScheduleDialog(context);
                        },
                        height: 50,
                        width: context.width,
                        child: Container(
                          decoration: BoxDecoration(
                              color: sessions.isBooked.toString() == "1"
                                  ? colorLightGray.withOpacity(0.5)
                                  : colorPrimary,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(12))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomTextView(
                                text: "im_interested".tr,
                                color: white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          )),
    );
  }

  Widget bodyHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextView(
          text: sessions.label ?? "",
          color: colorSecondary,
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
        SizedBox(
          height: 8.v,
        ),
      ],
    );
  }

  Widget descriptionView() {
    return CustomTextView(
      text: sessions.description ?? "",
      textAlign: TextAlign.start,
      fontSize: 14,
      maxLines: 100,
      fontWeight: FontWeight.normal,
      color: colorSecondary,
    );
  }
}
