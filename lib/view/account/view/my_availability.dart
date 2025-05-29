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
import '../model/createProfileModel.dart';

class MyAvailabilityPage extends GetView<SettingController> {
  static const routeName = "/setting_page";
  MyAvailabilityPage({Key? key}) : super(key: key);

  AuthenticationManager authenticationManager = Get.find();
  DashboardController dashboardController = Get.find();

  var availabilitySettingList = <ProfileFieldData>[
    ProfileFieldData(
        text: "allow_participant_to_send_message".tr,
        label: "",
        readonly: false,
        value: "1"),
    ProfileFieldData(
        text: "allow_participant_to_schedule_meetings".tr,
        label: "27 Oct, 2024",
        readonly: false,
        value: "0"),
    ProfileFieldData(
        text: "allow_participant_to_view_profile".tr,
        label: "",
        readonly: false,
        value: "0")
  ].obs;

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
        title: ToolbarTitle(title: "my_availability".tr),
      ),
      body: GetX<SettingController>(
        builder: (controller) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Stack(
              children: [
                CustomTextView(text: "select_event_date_to_schedule_meetings".tr,
                fontWeight: FontWeight.w600,fontSize: 16,maxLines: 6,textAlign: TextAlign.start,),
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: availabilitySettingList.length,
                    itemBuilder: (context, index) {
                      var createFieldBody = availabilitySettingList[index];
                      return radioBoxWidget(createFieldBody);
                    },
                  ),
                ),
                Positioned(
                  bottom: 30,left: 0,right: 0,
                  child: CommonMaterialButton(
                      text: "saveChanges".tr,
                      color: colorSecondary,
                      onPressed: () async {
                        Get.back();
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
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration:  BoxDecoration(
          color: colorLightGray,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: ListTile(
        title: CustomTextView(
          text: createFieldBody.label ?? "",
          textAlign: TextAlign.start,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: colorSecondary,
          maxLines: 2,
        ),
        leading: GestureDetector(
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
              print(createFieldBody.value);
              availabilitySettingList.refresh();
              //setState(() {});
            },
            child: SvgPicture.asset(
                createFieldBody.value == "1"
                    ? ImageConstant.ic_checkbox
                    : ImageConstant.ic_checkbox_off)),
      ),
    );
  }
}
