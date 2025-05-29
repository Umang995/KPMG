import 'package:dreamcast/api_repository/app_url.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/Notes/controller/my_notes_controller.dart';
import 'package:dreamcast/view/Notes/view/notes_dashboard.dart';
import 'package:dreamcast/view/account/controller/setting_controller.dart';
import 'package:dreamcast/view/account/model/profileModel.dart';
import 'package:dreamcast/view/account/view/settingPage.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/breifcase/controller/common_document_controller.dart';
import 'package:dreamcast/view/breifcase/view/breifcase_page.dart';
import 'package:dreamcast/view/myFavourites/view/favourite_dashboard.dart';
import 'package:dreamcast/view/myFavourites/view/for_you_dashboard.dart';
import 'package:dreamcast/view/schedule/controller/session_controller.dart';
import 'package:dreamcast/view/skeletonView/profile_skeleton.dart';
import 'package:dreamcast/view/travelDesk/view/travelDeskPage.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/widgets/custom_profile_image.dart';
import 'package:dreamcast/widgets/profile_bio_widget.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:dreamcast/view/profileSetup/view/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/app_decoration.dart';
import '../../../utils/image_constant.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/button/common_material_button.dart';
import '../../../widgets/button/custom_icon_button.dart';
import '../../../widgets/company_position_widget.dart';
import '../../../widgets/dialog/custom_dialog_widget.dart';
import '../../../widgets/flow_widget.dart';
import '../../../widgets/linkedin_aibutton.dart';
import '../../../widgets/loading.dart';
import '../../bestForYou/view/aiMatch_dashboard_page.dart';
import '../../dashboard/dashboard_controller.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../meeting/view/meeting_dashboard_page.dart';
import '../../menu/controller/menuController.dart';
import '../../profileSetup/controller/linkedInSetupController.dart';
import '../../profileSetup/controller/profileSetupController.dart';
import '../../qrCode/view/qr_dashboard_page.dart';
import '../controller/account_controller.dart';

class AccountPage extends GetView<AccountController> {
  static const routeName = "/account_page";

  AccountPage({Key? key}) : super(key: key);

  AuthenticationManager authenticationManager = Get.find();
  final DashboardController dashboardController = Get.find();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(builder: (_) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          height: 62.v,
          leadingWidth: 45.h,
          title: Padding(
            padding: const EdgeInsets.only(left: 13.0),
            child: ToolbarTitle(title: "profile".tr),
          ),
          backgroundColor: colorLightGray,
          dividerHeight: 0,
          actions: [
            InkWell(
              onTap: () {
                if (Get.isRegistered<SettingController>()) {
                  Get.delete<SettingController>();
                }
                Get.toNamed(SettingPage.routeName);
              },
              child: Container(
                height: 31.v,
                width: 44.h,
                padding: EdgeInsets.symmetric(horizontal: 13.h, vertical: 6.h),
                decoration: AppDecoration.decorationActionButton,
                child: SvgPicture.asset(ImageConstant.setting_icon,
                    width: 13,
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.onSurface,
                        BlendMode.srcIn)),
              ),
            ),
            SizedBox(
              width: 11.h,
            ),
            if (authenticationManager.isLogin())
              InkWell(
                onTap: () async {
                  var result = await Get.toNamed(ProfileEditPage.routeName);
                  if (result != null) {
                    controller.callDefaultApi();
                  }
                },
                child: Container(
                  height: 31.v,
                  width: 44.h,
                  padding:
                      EdgeInsets.symmetric(horizontal: 13.h, vertical: 6.h),
                  decoration: AppDecoration.decorationActionButton,
                  child: SvgPicture.asset(ImageConstant.ic_edit_icon,
                      width: 13,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.onSurface,
                          BlendMode.srcIn)),
                ),
              ),
            SizedBox(
              width: 15.h,
            ),
          ],
        ),
        body: Container(
          width: context.width,
          decoration: BoxDecoration(
              color: colorLightGray, borderRadius: BorderRadius.circular(0)),
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.only(top: 15),
          child: GetX<AccountController>(
            builder: (controller) {
              final signupPage =
                  authenticationManager.configModel.body?.pages?.signup;
              final hasWhatsApp = signupPage?.whatsApp?.isNotEmpty ?? false;
              final hasUrl = signupPage?.url?.isNotEmpty ?? false;
              return Stack(
                children: [
                  RefreshIndicator(
                      color: white,
                      backgroundColor: colorPrimary,
                      strokeWidth: 1.0,
                      onRefresh: () {
                        return Future.delayed(
                          const Duration(seconds: 1),
                          () {
                            controller.callDefaultApi();
                          },
                        );
                      },
                      child: SizedBox(
                        width: context.width,
                        height: double.infinity,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.zero,
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: controller.isLoading.value
                              ? SizedBox(
                                  child: Skeletonizer(
                                      enabled: true, child: ProfileSkeleton()),
                                )
                              : controller.profileBody?.id != null
                                  ? Stack(
                                      fit: StackFit.loose,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 53.v),
                                          decoration: AppDecoration
                                              .roundedBoxDecoration,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              SizedBox(
                                                height: 70.v,
                                              ),
                                              profileNameWidget(),
                                              SizedBox(
                                                height: 10.v,
                                              ),
                                              Obx(() => AICustomButton(
                                                  title: controller
                                                          .linkedInSetupController
                                                          .aiButtonText
                                                          .value ??
                                                      "",
                                                  onTap: () async {
                                                    controller
                                                        .linkedInSetupController
                                                        .takeTheActionStatus(
                                                            context);
                                                  })),
                                              SizedBox(
                                                height: 18.adaptSize,
                                              ),
                                              SizedBox(
                                                height: controller
                                                        .profileMenu.isEmpty
                                                    ? 10.adaptSize
                                                    : 20.adaptSize,
                                              ),
                                              controller.profileMenu.isEmpty
                                                  ? const SizedBox()
                                                  : exploreMenuWidget(context),
                                              infoWidget(
                                                  controller.profileBody?.info),
                                              aiGeneratedWidget(
                                                  controller.profileBody),
                                              SizedBox(
                                                height: 24.v,
                                              ),
                                              aiMatchKeywordsWidget(
                                                  controller.profileBody
                                                          ?.virtual?.params ??
                                                      [],
                                                  controller.profileBody
                                                          ?.virtual?.label
                                                          ?.toUpperCase() ??
                                                      ""),
                                              controller.profileBody?.virtual
                                                              ?.params !=
                                                          null &&
                                                      controller
                                                          .profileBody!
                                                          .virtual!
                                                          .params!
                                                          .isNotEmpty
                                                  ? SizedBox(
                                                      height: 24.v,
                                                    )
                                                  : const SizedBox(),
                                              (hasWhatsApp || hasUrl)
                                                  ? deleteWidget(context)
                                                  : const SizedBox(),
                                              SizedBox(
                                                height: 30.v,
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: appVersionWidget(),
                                              ),
                                              SizedBox(
                                                height: 20.v,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: CustomProfileImage(
                                            profileUrl:
                                                controller.profilePicUrl.value,
                                            shortName: controller
                                                    .profileBody?.shortName ??
                                                "",
                                            borderColor: colorLightGray,
                                            isAiProfile: controller.profileBody
                                                        ?.aiProfile ==
                                                    1
                                                ? true
                                                : false,
                                            isAccountPage: true,
                                          ),
                                        )
                                      ],
                                    )
                                  : const SizedBox(),
                        ),
                      )),
                  controller.isHubLoading() ||
                          controller.linkedInSetupController.isLoading.value ||
                          authenticationManager.loading.value
                      ? const Loading()
                      : const SizedBox(),
                ],
              );
            },
          ),
        ),
      );
    });
  }

  deleteWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: CommonMaterialButton(
        text: "Delete Account",
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogWidget(
                title: "Delete Account?",
                logo: ImageConstant.icDelete,
                description: "Are you sure you want to delete your account?",
                buttonAction: "Yes, Delete",
                buttonCancel: "Cancel",
                onCancelTap: () {
                  print("cancel tapped=====");
                },
                onActionTap: () async {
                  print("delete tapped====");
                  authenticationManager.deleteYourAccount();
                },
              );
            },
          );
        },
        color: white,
        borderWidth: 1,
        height: 45,
        weight: FontWeight.w500,
        radius: 50,
        textColor: colorPrimary,
        borderColor: colorPrimary,
        textSize: 16,
      ),
    );
  }

  exploreMenuWidget(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.14),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: controller.profileMenu.length,
        itemBuilder: (context, index) {
          var data = controller.profileMenu[index];
          return GestureDetector(
            onTap: () {
              HubController hubController = Get.find();
              hubController.commonMenuRouting(menuData: data);
            },
            child: Container(
              margin: EdgeInsets.only(right: 22.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 68.v,
                    width: 68.h,
                    decoration: BoxDecoration(
                      color: colorLightGray,
                      shape: BoxShape.rectangle,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: SvgPicture.network(
                        data.icon ?? "",
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onSurface,
                            BlendMode.srcIn),
                        height: 34.adaptSize,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.v,
                  ),
                  CustomTextView(
                      text: data.label ?? "",
                      maxLines: 1,
                      color: colorSecondary,
                      fontWeight: FontWeight.normal,
                      fontSize: 12)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ///email,country code,mobile,website
  infoWidget(Info? info) {
    return Container(
      padding: EdgeInsets.only(left: 15.h, right: 15.h, top: 12, bottom: 6),
      decoration: AppDecoration.profileCardDecoration(
          color: colorLightGray,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          commonLabelField(label: info?.text ?? ""),
          ListView.separated(
            itemCount: info?.params?.length ?? 0,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var item = info?.params?[index];
              return Container(
                padding: EdgeInsets.symmetric(vertical: 12.v, horizontal: 2.h),
                child: Row(
                  children: [
                    SizedBox(
                      width: context.width * .15,
                      child: CustomTextView(
                        text: "${item?.label ?? ""}:",
                        maxLines: 2,
                        color: colorGray,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: 5.h,
                    ),
                    CustomTextView(
                      text: item?.value ?? "",
                      maxLines: 2,
                      color: colorSecondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                height: 1,
                color: borderColor,
              );
            },
          ),
        ],
      ),
    );
  }

  profileNameWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextView(
            maxLines: 1,
            fontSize: 22,
            color: colorSecondary,
            fontWeight: FontWeight.w600,
            text: controller.profileBody?.name ?? ""),
        CompanyPositionWidget(
          company: controller.profileBody?.position ?? "",
          position: controller.profileBody?.company ?? "",
        ),
      ],
    );
  }

  buildSocialMediaWidget(List<dynamic> params, String title) {
    return params.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
                commonLabelField(label: title.capitalize ?? ""),
                const SizedBox(
                  height: 8,
                ),
                Wrap(
                  spacing: 10,
                  children: <Widget>[
                    for (var item in params ?? [])
                      Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: InkWell(
                                onTap: () {
                                  UiHelper.inAppBrowserView(
                                      Uri.parse(item.value.toString()));
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(1),
                                    child: SvgPicture.asset(
                                      UiHelper.getSocialIcon(
                                          item.label.toString().toLowerCase()),
                                    ))),
                          )),
                  ],
                )
              ])
        : const SizedBox();
  }

  ///bio,keywords.insight,social media
  aiGeneratedWidget(ProfileBody? profileBody) {
    final bioParams = profileBody?.bio?.params;
    final socialMediaParams = profileBody?.socialMedia?.params;
    return ((bioParams?.isNotEmpty ??
            false || socialMediaParams!.isNotEmpty ??
            false))
        ? Column(
            children: [
              SizedBox(
                height: 24.v,
              ),
              Stack(
                children: [
                  Container(
                    decoration: AppDecoration.aiBioDecoration,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 12.h, right: 12.h, bottom: 12.h),
                      decoration: AppDecoration.profileCardDecoration(
                          color: colorLightGray,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12))),
                      margin: const EdgeInsets.only(
                          top: 25, left: 4, right: 4, bottom: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: bioParams?.length,
                            itemBuilder: (context, index) {
                              var about = bioParams?[index];
                              return about?.value is List?
                                  ? aiKeywordsBody(
                                      about?.value ?? [], about?.label ?? "")
                                  : ProfileBioWidget(
                                      title: about?.label ?? "",
                                      content: about?.value ?? "",
                                    );
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          buildSocialMediaWidget(
                              socialMediaParams ?? [],
                              profileBody?.socialMedia?.text?.toUpperCase() ??
                                  ""),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  profileBody?.aiProfile.toString() == "1"
                      ? Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8, top: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(ImageConstant.ai_star),
                                const SizedBox(
                                  width: 6,
                                ),
                                CustomTextView(
                                  text: "ai_generated".tr,
                                  color: white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ],
          )
        : const SizedBox();
  }

  aiMatchKeywordsWidget(List<dynamic> params, String title) {
    return Container(
      decoration: BoxDecoration(
          color: colorLightGray,
          border: Border.all(color: borderColor, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: params.isNotEmpty
          ? ListView.separated(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.symmetric(horizontal: 12.h),
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(width: 6);
              },
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: params.length ?? 0,
              itemBuilder: (context, index) {
                var data = params[index];
                return aiKeywordsBody(data.value, data.label);
              },
            )
          : const SizedBox(),
    );
  }

  commonLabelField({required String label}) {
    return CustomTextView(
      text: label ?? "",
      textAlign: TextAlign.start,
      color: colorSecondary,
      fontSize: 19,
      fontWeight: FontWeight.w500,
    );
  }

  aiKeywordsBody(List<dynamic>? value, label) {
    return value != null && value.isNotEmpty
        ? ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: commonLabelField(label: label ?? ""),
            subtitle: Wrap(
              spacing: 6,
              children: <Widget>[
                for (var item in value)
                  MyFlowWidget(item ?? "", isBgColor: true),
              ],
            ),
          )
        : const SizedBox();
  }

  notesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextView(
          text: "my_notes".tr,
          maxLines: 100,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: colorSecondary,
        ),
        SizedBox(
          height: 8.v,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  if (controller.notesData.value.speaker != null &&
                      controller.notesData.value.speaker! > 0) {
                    if (Get.isRegistered<MyNotesController>()) {
                      Get.delete<MyNotesController>();
                    }
                    Get.toNamed(NotesDashboard.routeName,
                        arguments: {"role": MyConstant.speakers});
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: colorLightGray,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextView(
                            text:
                                "${controller.notesData.value.speaker ?? ""} Notes",
                            maxLines: 100,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: colorSecondary,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextView(
                        text: "speakers".tr,
                        maxLines: 100,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  if (controller.notesData.value.user != null &&
                      controller.notesData.value.user! > 0) {
                    Get.toNamed(NotesDashboard.routeName,
                        arguments: {"role": MyConstant.attendee});
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: colorLightGray,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextView(
                            text:
                                "${controller.notesData.value.user ?? ""} Notes",
                            maxLines: 100,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: colorSecondary,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextView(
                        text: "attendee".tr,
                        maxLines: 100,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 8.v,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  if (controller.notesData.value.exhibitor != null &&
                      controller.notesData.value.exhibitor! > 0) {
                    Get.toNamed(NotesDashboard.routeName,
                        arguments: {"role": MyConstant.exhibitor});
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: colorLightGray,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextView(
                            text:
                                "${controller.notesData.value.exhibitor ?? ""} Notes",
                            maxLines: 100,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: colorSecondary,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextView(
                        text: "exhibitors".tr,
                        maxLines: 100,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            const Expanded(
              flex: 1,
              child: SizedBox(),
            )
          ],
        )
      ],
    );
  }

  appVersionWidget() {
    return Column(
      children: [
        CustomTextView(
          text: "Version ${authenticationManager.currAppVersion}",
          fontWeight: FontWeight.normal,
          color: colorPrimary,
          textAlign: TextAlign.start,
        ),
        CustomTextView(
          text: AppUrl.topicName == "STAGING_EVENTAPP_IMC2024"
              ? "staging_mode".tr
              : "",
          fontWeight: FontWeight.normal,
          color: colorPrimary,
          textAlign: TextAlign.start,
        )
      ],
    );
  }
}
