import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/account/controller/setting_controller.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/button/common_material_button.dart';
import '../model/privacyProfileModel.dart';

class PrivacyPreference extends GetView<SettingController> {
  static const routeName = "/privacy_preference";
  PrivacyPreference({Key? key}) : super(key: key);

  AuthenticationManager authenticationManager = Get.find();
  DashboardController dashboardController = Get.find();

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
        centerTitle: false,
        title: ToolbarTitle(title: "privacy_preference".tr),
      ),
      body: GetX<SettingController>(
        builder: (controller) {
          return Container(
            padding: const EdgeInsets.all(15),
            child: Stack(
              children: [
                ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.privacySettingList.length,
                  itemBuilder: (context, index) {
                    var createFieldBody = controller.privacySettingList[index];
                    return createFieldBody.name=="is_notification_mute"? const SizedBox():radioBoxWidget(createFieldBody);
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CommonMaterialButton(
                      text: "saveChanges".tr,
                      color: colorPrimary,
                      onPressed: () async {
                        controller.updateProfile(context,controller.privacySettingList);
                      }),
                ),
                controller.isLoading.value ? const Loading() : const SizedBox()
              ],
            ),
          );
        },
      ),
    );
  }

  Widget radioBoxWidget(ProfileFieldData createFieldBody) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 15),
      decoration:  BoxDecoration(
        color: colorLightGray,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
              children: [
                CustomTextView(
                  text: createFieldBody.label ?? "",
                  textAlign: TextAlign.start,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorSecondary,
                  maxLines: 2,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: CustomTextView(
                    text: createFieldBody.placeholder ?? "",
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    maxLines: 7,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: GestureDetector(
              onTap: () async {
                if (createFieldBody.readonly != null &&
                    createFieldBody.readonly!) {
                  return;
                }
                if (createFieldBody.value == "1") {
                  createFieldBody.value = "0";
                } else {
                  createFieldBody.value = "1";
                }
                controller.privacySettingList.refresh();
              },
              child: SvgPicture.asset(
                height: 19,
                colorFilter: ColorFilter.mode(
                    createFieldBody.value == "1" ? colorPrimary : colorGray,
                    BlendMode.srcIn),
                createFieldBody.value == "1"
                    ? ImageConstant.toggle_button
                    : ImageConstant.toggle_off,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
