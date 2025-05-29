import 'dart:convert';

import 'package:dreamcast/utils/dialog_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/account/controller/account_controller.dart';
import 'package:dreamcast/view/account/view/account_page.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:dreamcast/view/profileSetup/view/draft_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signin_with_linkedin/signin_with_linkedin.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../model/common_model.dart';
import '../../../model/erro_code_model.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/image_constant.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/button/common_material_button.dart';
import '../../../widgets/dialog/custom_animated_dialog_widget.dart';
import '../../../widgets/dialog/custom_dialog_widget.dart';
import '../../account/model/createProfileModel.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../beforeLogin/signup/model/city_res_model.dart';
import '../../beforeLogin/signup/model/state_res_model.dart';
import '../../../widgets/textview/customTextView.dart';
import '../../dashboard/dashboard_page.dart';
import '../model/ai_profile_data_model.dart';
import '../model/profile_update_model.dart';

class LinkedInSetupController extends GetxController {
  final AuthenticationManager _authManager = Get.find();
  //show loading
  var isLoading = false.obs;
  var isFirstLoading = false.obs;
  //for the name field
  var linkedProfileUrl = "".obs;
  var aiButtonText = "".obs;
  var aiButtonAction = "".obs;

  ///Generate,Regenerate,Ready,Progress,Connect
  //Generate=>
  @override
  void onInit() {
    super.onInit();
    _authManager.linkedinSetupDynamic();
  }

  ///used for the generate and re generate the linkedin profile
  Future<void> updateLinkedInUrl(BuildContext? context, String url) async {
    var jsonRequest = {"linkedin": url};
    isLoading(true);
    var response = await apiService.dynamicPostRequest(
        url: AppUrl.updateLinkedin, body: jsonRequest);

    CommonModel responseModel = CommonModel.fromJson(json.decode(response));
    isLoading(false);
    if (responseModel!.status!) {
      PrefUtils.saveLinkedUrl(url);
      Get.dialog(
          barrierDismissible: false,
          CustomAnimatedDialogWidget(
            title: "",
            logo: ImageConstant.ai_profile_avtar,
            description: responseModel.message ?? "",
            buttonAction: "explore_now".tr,
            buttonCancel: "cancel".tr,
            isHideCancelBtn: true,
            onCancelTap: () {},
            onActionTap: () async {
              openDashboardPage();
            },
          ));
    } else {
      UiHelper.showFailureMsg(context, responseModel.message ?? "");
    }
  }

  openDashboardPage() {
    Get.until((route) => Get.currentRoute == DashboardPage.routeName);
    if (Get.isRegistered<DashboardController>()) {
      DashboardController controller = Get.find();
      controller?.changeTabIndex(0);
    }
  }

  ///show the connect dialog
  showLinkedinConnectDialog({title, content, context}) async {
    var result = await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(), // to push the close button to the right
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon:  Icon(
                      Icons.close,
                      color: colorGray,
                    ),
                    onPressed: () => Get.back(result: ""),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: borderColor,
                ),
                child: SvgPicture.asset(
                  ImageConstant.connectLinkedin,
                  height: 40,
                  width: 40,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Center(
                  child: CustomTextView(
                    text: content,
                    maxLines: 4,
                    fontSize: 16,
                    color: colorSecondary,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: CommonMaterialButton(
                  borderWidth: 1,
                  borderColor: colorSecondary,
                  color: white,
                  svgIcon: "assets/svg/linkedin.svg",
                  iconHeight: 15,
                  height: 52.v,
                  text: "connect_linked_account".tr,
                  textSize: 15,
                  textColor: colorSecondary,
                  weight: FontWeight.w500,
                  onPressed: () async {
                    Get.back(result: true);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (result == true) {
      await connectFunctionWithLinkedIn(context);
    }
  }

  ///open the linkedin sdk to get the profile token
  connectFunctionWithLinkedIn(BuildContext context) {
    if (_authManager.linkedInConfig != null) {
      try {
        SignInWithLinkedIn.logout();
        SignInWithLinkedIn.signIn(
          context,
          config: _authManager.linkedInConfig!,
          onGetUserProfile: (tokenData, user) {
            print('Auth token data: ${tokenData.accessToken}');
            getLinkedInProfileUrl(requestBody: {"code": tokenData.accessToken});
            print('LinkedIn User: ${user.toJson()}');
          },
          onSignInError: (error) {
            print('Error on sign in: $error');
            //UiHelper.showFailureMsg(context, 'Error on sign in: $error');
          },
        );
      } catch (exception) {
        debugPrint("exception ${exception}");
      }
    }
  }

  Future<void> getLinkedInProfileUrl({required requestBody}) async {
    try {
      isLoading(true);
      var response = await apiService.dynamicPostRequest(
          body: requestBody, url: AppUrl.connectToLinkedin);

      isLoading(false);
      CommonModel? model = CommonModel.fromJson(json.decode(response));

      Get.dialog(
          barrierDismissible: false,
          CustomAnimatedDialogWidget(
            title: "",
            logo: ImageConstant.icSuccessAnimated,
            description: model.message ?? "",
            buttonAction: "explore_now".tr,
            buttonCancel: "cancel".tr,
            isHideCancelBtn: true,
            onCancelTap: () {},
            onActionTap: () async {
              openDashboardPage();
            },
          ));
    } catch (e) {
      print(e.toString());
    }
  }

  takeTheActionStatus(BuildContext context) async {
    print("@@@ ${aiButtonAction.value}");
    switch (aiButtonAction.value) {
      case "Generate":
        if (linkedProfileUrl.value.isNotEmpty) {
          updateLinkedInUrl(context, linkedProfileUrl.value);
        }
        break;
      case "Regenerate":
        FocusManager.instance.primaryFocus?.unfocus();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogWidget(
              title: "are_you_sure".tr,
              logo: ImageConstant.ic_question_confirm,
              description: "ai_regenerated_message".tr,
              buttonAction: "Yes, Proceed",
              buttonCancel: "cancel".tr,
              isShowBtnCancel: true,
              onCancelTap: () {},
              onActionTap: () async {
                if (linkedProfileUrl.value.isNotEmpty) {
                  updateLinkedInUrl(context, linkedProfileUrl.value);
                }
              },
            );
          },
        );
        break;
      case "Ready":
        Get.to(
            const DraftProfilePage()); //new page open of publish to call the api of
        break;
      case "Progress":
        Get.dialog(
            barrierDismissible: false,
            CustomAnimatedDialogWidget(
              title: "",
              logo: ImageConstant.ai_profile_avtar,
              description: "explore_message".tr,
              buttonAction: "explore_more".tr,
              buttonCancel: "cancel".tr,
              isHideCancelBtn: true,
              onCancelTap: () {},
              onActionTap: () async {
                openDashboardPage();
              },
            ));
        break;
      case "Connect":
        showLinkedinConnectDialog(
            title: "title".tr, content: "connect".tr, context: context);

        ///initial stage of ai profile
        break;
    }
  }
}
