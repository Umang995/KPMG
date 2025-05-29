import 'dart:convert';
import 'package:dreamcast/view/account/model/privacyProfileModel.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/exhibitors/model/bookmark_common_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dreamcast/api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/image_constant.dart';
import '../../../utils/pref_utils.dart';
import '../../profileSetup/model/profile_update_model.dart';
import '../view/settingPage.dart';
import 'account_controller.dart';

class SettingController extends GetxController {
  var privacySettingList = <ProfileFieldData>[].obs;
  var isLoading = false.obs;

  final AuthenticationManager _authManager = Get.find();
  late AccountController accountController;
  var settingItemList = [];

  @override
  void onInit() {
    super.onInit();
    accountController = Get.find();
    settingItemList = [
      MenuItem.createItem(
          title: "privacy_preference".tr,
          isTrailing: true,
          color: colorSecondary,
          slug: "privacy_preference",
          leading: ImageConstant.privacy_prefrence),
      MenuItem.createItem(
          title: "time_zone".tr,
          isTrailing: true,
          color: colorSecondary,
          slug: "time_zone",
          leading: ImageConstant.timezone),
      MenuItem.createItem(
          title: "mute_notification".tr,
          isTrailing: true,
          color: colorSecondary,
          slug: "mute_notification",
          leading: ImageConstant.mute_notification),
       /*MenuItem.createItem(
          title: "Theme Settings",
          isTrailing: true,
          color: colorSecondary,
          slug: "change_theme",
          leading: ImageConstant.themeIcon),*/
      /*MenuItem.createItem(
          title: "AI Features",
          isTrailing: true,
          color: colorSecondary,
          slug: "ai_feature",
          leading: ImageConstant.themeIcon),*/
      MenuItem.createItem(
          title: _authManager.isLogin() ? "logout".tr : "login".tr,
          slug: "logout",
          isTrailing: false,
          color: const Color(0xffDE3C34),
          leading: ImageConstant.logoutSvg)
    ];
    if (_authManager.isLogin()) {
      getPrivacyPreferenceField();
    }
  }

  //create profile dynamic
  Future<void> getPrivacyPreferenceField() async {
    isLoading(true);
    var response =
        await apiService.dynamicGetRequest(url: AppUrl.getPrivacyPreference);
    PrivacyProfileModel? createProfileModel =
        PrivacyProfileModel.fromJson(json.decode(response));
    isLoading(false);
    if (createProfileModel.status! && createProfileModel.code == 200) {
      privacySettingList.clear();
      privacySettingList.addAll(createProfileModel.body ?? []);
      update();
    } else {
      print(createProfileModel.code.toString());
    }
  }

  Future<void> updateProfile(
      BuildContext context, List<ProfileFieldData> privacySettingList) async {
    var formData = <String, dynamic>{};
    for (int index = 0; index < privacySettingList.length; index++) {
      var data = privacySettingList[index];
      if (data.value != null) {
        formData["${data.name}"] = data.value.toString();
      }
    }
    isLoading(true);

    final responseModel = ProfileUpdateModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: formData, url: AppUrl.updatePrivacyPreference),
    ));

    isLoading(false);
    if (responseModel!.status!) {
      PrefUtils.savePrivacyData(
          isChat: responseModel.body?.isChat?.toString() == "1" ? true : false,
          isMeeting:
              responseModel.body?.isMeeting.toString() == "1" ? true : false,
          isProfile: false);
      if (responseModel.body?.isChat.toString() == "1" ||
          responseModel.body?.isMeeting.toString() == "1") {
        accountController.isSelectedSwitch(true);
      } else {
        accountController.isSelectedSwitch(false);
      }
      Get.back(result: "update");
      UiHelper.showSuccessMsg(context, responseModel.message ?? "");
    } else {
      UiHelper.showFailureMsg(context, responseModel.message ?? "");
    }
  }

  Future<void> muteNotification(BuildContext context) async {
    isLoading(true);

    final responseModel = BookmarkCommonModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(body: {
        "is_notification_mute":
            _authManager.isMuteNotification.value ? "0" : "1"
      }, url: AppUrl.muteNotification),
    ));
    isLoading(false);
    if (responseModel.status!) {
      _authManager.isMuteNotification(
          responseModel.body?.muteNotification.toString() == "1"
              ? true
              : false);
      UiHelper.showSuccessMsg(context, responseModel.message ?? "");
    } else {
      UiHelper.showFailureMsg(context, responseModel.message ?? "");
    }
  }
}
