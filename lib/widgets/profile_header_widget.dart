import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/account/controller/setting_controller.dart';
import 'package:dreamcast/view/meeting/view/meeting_dashboard_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../view/account/controller/account_controller.dart';
import '../view/account/model/privacyProfileModel.dart';
import '../view/dashboard/dashboard_controller.dart';
import '../view/qrCode/view/qr_dashboard_page.dart';
import 'button/custom_icon_button.dart';
import 'custom_profile_image.dart';
import 'dialog/custom_dialog_widget.dart';

class ProfileHeaderWidget extends GetView<AccountController> {
  static const routeName = "/account_page";
  ProfileHeaderWidget({Key? key}) : super(key: key);

  AuthenticationManager authenticationManager = Get.find();
  final DashboardController dashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(builder: (_) {
      return GetX<AccountController>(
        builder: (controller) {
          return Stack(
            children: [
              _profileHeader(context),
            ],
          );
        },
      );
    });
  }

  _profileHeader(BuildContext context) {
    var image = controller.profileBody?.avatar ?? "";
    var shortName = controller.profileBody?.shortName;
    bool isAiProfile = controller.profileBody?.aiProfile == 1 ? true : false;

    return Skeletonizer(
        enabled: controller.isLoading.value,
        child: Container(
          padding: const EdgeInsets.only(top: 18, left: 8, right: 8, bottom: 9),
          decoration: BoxDecoration(
              color: colorLightGray, borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: CustomProfileImage(
                      profileUrl: image,
                      shortName: shortName ?? "",
                      borderColor: white,
                      isAiProfile: isAiProfile,
                      isAccountPage: false,
                    ),
                  ),
                  const SizedBox(
                    width: 22,
                  ),
                  Expanded(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextView(
                        textAlign: TextAlign.start,
                        text: controller.profileBody?.name ?? "",
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                      controller.profileBody?.position != null &&
                              controller.profileBody!.position!.isEmpty
                          ? const SizedBox()
                          : CustomTextView(
                              text: controller.profileBody?.position ?? "",
                              color: colorSecondary,
                              fontSize: 14,
                              maxLines: 1,
                              fontWeight: FontWeight.normal,
                              textAlign: TextAlign.start,
                            ),
                      CustomTextView(
                        text: controller.profileBody?.company ?? "",
                        color: colorSecondary,
                        fontSize: 14,
                        maxLines: 1,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextView(
                            text: "open_networking".tr,
                            color: colorSecondary,
                            fontSize: 16,
                            maxLines: 1,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start,
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: () async {
                                await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialogWidget(
                                        logo: ImageConstant.block,
                                        title: "Confirmation",
                                        description:
                                            "Are you sure you want to ${controller.isSelectedSwitch.value ? "close" : "open"} the networking.",
                                        buttonAction: "Confirm",
                                        buttonCancel: "Cancel",
                                        onCancelTap: () {},
                                        onActionTap: () async {
                                          SettingController settingController =
                                              Get.isRegistered<
                                                      SettingController>()
                                                  ? Get.find()
                                                  : Get.put(
                                                      SettingController());

                                          controller.isSelectedSwitch(
                                              !controller
                                                  .isSelectedSwitch.value);
                                          settingController
                                              .updateProfile(context, [
                                            ProfileFieldData(
                                                name: "is_meeting",
                                                value: controller
                                                        .isSelectedSwitch.value
                                                    ? "1"
                                                    : "0"),
                                            ProfileFieldData(
                                                name: "is_chat",
                                                value: controller
                                                        .isSelectedSwitch.value
                                                    ? "1"
                                                    : "0"),
                                            ProfileFieldData(
                                              name: "is_public_profile",
                                              value: controller
                                                  .profileBody?.isPublicProfile
                                                  .toString(),
                                            ),
                                            ProfileFieldData(
                                                name: "is_notification_mute",
                                                value: authenticationManager
                                                        .isMuteNotification
                                                        .value
                                                    ? "1"
                                                    : "0")
                                          ]);
                                        },
                                      );
                                    });
                              },
                              child: SvgPicture.asset(
                                  colorFilter: ColorFilter.mode(
                                      controller.isSelectedSwitch.value == true
                                          ? colorPrimary
                                          : colorGray,
                                      BlendMode.srcIn),
                                  controller.isSelectedSwitch.value
                                      ? ImageConstant.toggleOn
                                      : ImageConstant.toggleOff),
                            ),
                          )
                        ],
                      )
                    ],
                  )),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomIconButton(
                      onTap: () {
                        Get.toNamed(QRDashboardPage.routeName,
                            arguments: {"tab_index": 2});
                      },
                      height: 52.adaptSize,
                      decoration: BoxDecoration(
                          color: white,
                          border: Border.all(color: colorGray, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      width: context.width,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/svg/ic_contact.svg",
                              width: 34.adaptSize,
                              colorFilter: ColorFilter.mode(
                                  Theme.of(context).colorScheme.onSurface,
                                  BlendMode.srcIn)),
                          const SizedBox(
                            width: 6,
                          ),
                          Flexible(
                            child: CustomTextView(
                              text: "myContact".tr,
                              fontSize: 14,
                              maxLines: 1,
                              fontWeight: FontWeight.w500,
                              color: colorSecondary,
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 12.adaptSize, color: colorSecondary)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    flex: 1,
                    child: CustomIconButton(
                      onTap: () {
                        Get.toNamed(MyMeetingList.routeName,
                            arguments: {MyConstant.titleKey: "myMeetings".tr});
                      },
                      height: 52.adaptSize,
                      decoration: BoxDecoration(
                          color: white,
                          border: Border.all(color: colorGray, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      width: context.width,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/svg/ic_meeting.svg",
                              width: 34.adaptSize,
                              colorFilter: ColorFilter.mode(
                                  Theme.of(context).colorScheme.onSurface,
                                  BlendMode.srcIn)),
                          const SizedBox(
                            width: 6,
                          ),
                          Flexible(
                            child: CustomTextView(
                              text: "myMeetings".tr,
                              color: colorSecondary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12.adaptSize,
                            color: colorSecondary,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
