import 'dart:io';

import 'package:dreamcast/theme/app_decoration.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/account/controller/setting_controller.dart';
import 'package:dreamcast/view/account/view/privacy_preference.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/more/widget/timezone_page.dart';
import 'package:dreamcast/widgets/dialog/custom_dialog_widget.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/dialog_constant.dart';
import '../../../utils/image_constant.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/button/common_material_button.dart';
import '../../../widgets/themeSettingsPage.dart';

class SettingPage extends GetView<SettingController> {
  static const routeName = "/setting_page";
  SettingPage({Key? key}) : super(key: key);
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
        title: ToolbarTitle(title: "profile_settings".tr),
      ),
      body: GetX<SettingController>(
        builder: (controller) {
          return Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 0),
            child: Stack(
              children: [
                ListView.separated(
                  itemCount: controller.settingItemList.length,
                  itemBuilder: (context, index) {
                    var itemData = controller.settingItemList[index];
                    return GestureDetector(
                      onTap: () async {
                        switch (controller.settingItemList[index].slug) {
                          case "privacy_preference":
                            if (!authenticationManager.isLogin()) {
                              DialogConstantHelper.showLoginDialog(
                                  Get.context!, authenticationManager);
                              return;
                            }
                            Get.toNamed(PrivacyPreference.routeName);
                            break;
                          case "time_zone":
                            if (!authenticationManager.isLogin()) {
                              DialogConstantHelper.showLoginDialog(
                                  Get.context!, authenticationManager);
                              return;
                            }
                            Get.to(() => TimezonePage());
                            break;
                          case "mute_notification":
                            if (!authenticationManager.isLogin()) {
                              DialogConstantHelper.showLoginDialog(
                                  Get.context!, authenticationManager);
                              return;
                            }
                            controller.muteNotification(context);
                            break;
                          case "change_theme":
                            Get.to(ThemeSettingsPage());
                            break;
                          case "ai_feature":
                            _openToggleDialog();
                            break;
                          case "logout":
                            if (!authenticationManager.isLogin()) {
                              DialogConstantHelper.showLoginDialog(
                                  Get.context!, authenticationManager);
                              return;
                            }
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialogWidget(
                                  title: "logout".tr,
                                  logo: ImageConstant.logout,
                                  description:
                                      "Are you sure you want to logout?",
                                  buttonAction: "Yes, Logout",
                                  buttonCancel: "Cancel",
                                  onCancelTap: () {},
                                  onActionTap: () async {
                                    authenticationManager.logoutTheUserAPi();
                                  },
                                );
                              },
                            );
                            break;
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: SvgPicture.asset(itemData.leading ?? "",
                                width: 36,
                                colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.onSurface,
                                    BlendMode.srcIn)),
                            title: CustomTextView(
                              text: itemData.title ?? "",
                              color: colorSecondary,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.start,
                              fontSize: 20,
                              maxLines: 2,
                            ),
                            trailing: itemData.isTrailing
                                ? itemData.slug == "logout"
                                    ? SvgPicture.asset(
                                        ImageConstant.common_arrow,
                                        width: 9,
                                        colorFilter: ColorFilter.mode(
                                            Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            BlendMode.srcIn))
                                    : itemData.slug == "ai_feature "
                                        ? Obx(() => Switch(
                                              value: authenticationManager
                                                  .isAiFeature.value,
                                              onChanged: (val) {
                                                authenticationManager
                                                    .isAiFeature.value = val;
                                              },
                                            ))
                                        : itemData.slug == "mute_notification"
                                            ? Obx(
                                                () => SvgPicture.asset(
                                                    colorFilter: ColorFilter.mode(
                                                        authenticationManager
                                                                    .isMuteNotification
                                                                    .value ==
                                                                true
                                                            ? colorPrimary
                                                            : colorGray,
                                                        BlendMode.srcIn),
                                                    authenticationManager
                                                            .isMuteNotification
                                                            .value
                                                        ? ImageConstant.toggleOn
                                                        : ImageConstant
                                                            .toggleOff),
                                              )
                                            : const SizedBox()
                                : null,
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      height: 6,
                      color: borderColor,
                    );
                  },
                ),
                authenticationManager.showForceUpdateDialog.value
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: updateAppWidget(),
                      )
                    : const SizedBox(),
                controller.accountController.isLoading.value ||
                        authenticationManager.loading.value ||
                        controller.isLoading.value
                    ? const Loading()
                    : const SizedBox()
              ],
            ),
          );
        },
      ),
    );
  }

  bool isLoggedIn() {
    if (!authenticationManager.isLogin()) {
      DialogConstantHelper.showLoginDialog(Get.context!, authenticationManager);
      return false;
    }
    return true;
  }

  void _openToggleDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose AI Feature'),
          content: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Enable AI Feature'),
                  Switch(
                    value: authenticationManager.isAiFeature.value,
                    onChanged: (val) {
                      authenticationManager.isAiFeature.value = val;
                      PrefUtils.setAiFeature(val);
                      Get.forceAppUpdate();
                    },
                  ),
                ],
              )),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> requestNotificationPermissions() async {
    final PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
    } else if (status.isDenied) {
      await openAppSettings();
    } else if (status.isPermanentlyDenied) {
      // Notification permissions permanently denied, open app settings
      await openAppSettings();
    }
  }

  Widget updateAppWidget() {
    return Container(
      decoration: BoxDecoration(
        color: colorLightGray,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 21),
              child: SvgPicture.asset(ImageConstant.icUpdateApp),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextView(
                  text: "batter_then_ever".tr,
                  color: colorSecondary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 6,
                ),
                CustomTextView(
                  text: "version_alert".tr,
                  color: colorSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                const SizedBox(
                  height: 6,
                ),
                SizedBox(
                  width: 131,
                  child: CommonMaterialButton(
                    text: "update_app".tr,
                    height: 40, textSize: 16,
                    color: colorPrimary,
                    onPressed: () async {
                      var url = Platform.isAndroid
                          ? authenticationManager
                                  .configModel.body?.flutter?.playStoreUrl ??
                              ""
                          : authenticationManager
                                  .configModel.body?.flutter?.appStoreUrl ??
                              "";
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    weight: FontWeight.w500, // Medium font weight
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MenuItem {
  String? title;
  String? leading;
  bool isTrailing;
  String? slug;
  Color? color;
  MenuItem.createItem(
      {required this.title,
      required this.leading,
      required this.isTrailing,
      required this.color,
      required this.slug});
}
