import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_decoration.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/widgets/linkedin_aibutton.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/view/profileSetup/view/profile_select_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';

import 'package:signin_with_linkedin/signin_with_linkedin.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/image_constant.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/button/custom_icon_button.dart';
import '../../../widgets/flow_widget.dart';
import '../../../widgets/button/common_material_button.dart';
import '../../../widgets/profile_form_field.dart';
import '../../account/model/createProfileModel.dart';
import '../../../widgets/toolbarTitle.dart';
import '../controller/profileSetupController.dart';
import 'dart:io';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);
  static const routeName = "/profilePage";
  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final AuthenticationManager authenticationManager = Get.find();
  final EditProfileController controller = Get.find();

  var countryCode = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the controllers when done
    _scrollController.dispose();
    super.dispose();
  }

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
        title: ToolbarTitle(title: "edit_profile".tr),
      ),
      body: GetX<EditProfileController>(
        builder: (controller) {
          return Skeletonizer(
            enabled: controller.isFirstLoading.value,
            child: Stack(children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: socialFormKey,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              singProfileImage(),
                              profileInitial(context),
                              const SizedBox(
                                height: 12,
                              ),
                              infoProfileWidget(context),
                              const SizedBox(
                                height: 30,
                              ),
                              bioProfileWidget(context),
                              const SizedBox(
                                height: 30,
                              ),
                              socialProfileWidget(),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ))),
              Positioned(
                bottom: 10,
                left: 16,
                right: 16,
                child: CommonMaterialButton(
                  color: colorPrimary,
                  text: "saveChange".tr,
                  onPressed: () {
                    if (socialFormKey.currentState?.validate() ?? false) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (controller.profileImage.value.path.isNotEmpty) {
                        controller.updatePicture();
                      }
                      controller.updateProfile(context,
                          isPublish: false, isLater: false);
                    }
                  },
                ),
              ),
              controller.isLoading.value ||
                      controller.linkedInSetupController.isLoading.value
                  ? const Loading()
                  : const SizedBox()
            ]),
          );
        },
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  singProfileImage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() => Skeleton.shade(
                child: AICustomButton(
                    title:
                        controller.linkedInSetupController.aiButtonText.value ??
                            "",
                    onTap: () async {
                      controller.linkedInSetupController
                          .takeTheActionStatus(context);
                    }),
              )),
          SizedBox(
            height: 18.adaptSize,
          ),
          SizedBox(
            width: 104.h,
            height: 104.v,
            child: Skeleton.shade(
              child: Stack(
                children: [
                  controller.profileImage.value.path.isEmpty &&
                          PrefUtils.getImage()!.isNotEmpty
                      ? GradientBorderCircle(
                          imageUrl: PrefUtils.getImage() ?? "",
                          size: 100,
                        )
                      : localAvtarWidget(100),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        controller.showPicker(context, 0, 0);
                      },
                      child: SvgPicture.asset(
                        ImageConstant.img_edit,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 0,
          ),
          editNameWidget(ProfileFieldData()),
        ],
      ),
    );
  }

  Widget serverAvtarWidget(double imageSize) {
    return Container(
      height: imageSize,
      width: imageSize,
      decoration: BoxDecoration(
        color: colorSecondary,
        shape: BoxShape.circle,
        image: DecorationImage(
            image: NetworkImage(PrefUtils.getImage() ?? ""),
            fit: BoxFit.contain),
        border: Border.all(
          color: colorGray,
          width: 1.0,
        ),
      ),
    );
  }

  Widget localAvtarWidget(double imageSize) {
    return controller.profileImage.value.path.isNotEmpty
        ? Container(
            height: imageSize,
            width: imageSize,
            decoration: BoxDecoration(
              color: colorSecondary,
              shape: BoxShape.circle,
              image: DecorationImage(
                image: FileImage(File(controller.profileImage.value.path)),
                fit: BoxFit.cover,
              ),
              border: Border.all(
                color: colorGray,
                width: 1.0,
              ),
            ),
          )
        : Container(
            height: imageSize,
            width: imageSize,
            decoration: AppDecoration.shortNameImageDecoration(),
            child: Center(
                child: CustomTextView(
              text: PrefUtils.getUsername() ?? "",
              fontSize: 28,
              color: colorSecondary,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            )),
          );
  }

  Widget profileInitial(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.profileFieldStep1.length,
      itemBuilder: (context, index) {
        ProfileFieldData createFieldBody = controller.profileFieldStep1[index];
        return createFieldBody.name.toString().contains('avatar')
            ? const SizedBox()
            : ProfileFormField(
                profileFieldData: createFieldBody,
              );
      },
    );
  }

  Widget infoProfileWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: AppDecoration.profileCardDecoration(
          color: colorLightGray,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          commonHeaderWidget(title: "info".tr),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.profileFieldStep2.length,
            itemBuilder: (context, index) {
              ProfileFieldData createFieldBody =
                  controller.profileFieldStep2[index];
              if (createFieldBody.name == "country_code") {
                countryCode = createFieldBody.value;
                return const SizedBox();
              }
              return createFieldBody.type == "input"
                  ? ProfileFormField(
                      profileFieldData: createFieldBody,
                      mobileCode: countryCode,
                    )
                  : createFieldBody.type == "checkbox"
                      ? checkBoxWidget(createFieldBody)
                      : createFieldBody.type == "select"
                          ? _buildDropdownWidget(createFieldBody)
                          : const SizedBox();
            },
          )
        ],
      ),
    );
  }

  Widget bioProfileWidget(BuildContext context) {
    return Skeleton.leaf(
      child: Container(
        decoration: AppDecoration.aiBioDecoration,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: AppDecoration.profileCardDecoration(
            color: colorLightGray,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commonHeaderWidget(title: "bio".tr),
              ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 0,
                    child: Container(
                      color: colorLightGray,
                    ),
                  );
                },
                itemCount: controller.profileFieldStep3.length,
                itemBuilder: (context, index) {
                  ProfileFieldData createFieldBody =
                      controller.profileFieldStep3[index];
                  return createFieldBody.type == "checkbox"
                      ? _buildEditTextSearch(createFieldBody)
                      : buildTextArea(createFieldBody);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget commonHeaderWidget({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 16),
      child: CustomTextView(
        text: title,
        textAlign: TextAlign.start,
        fontSize: 19,
        color: colorSecondary,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget socialProfileWidget() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorLightGray,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          commonHeaderWidget(title: "social_media".tr),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 0,
                child: Container(
                  color: colorLightGray,
                ),
              );
            },
            itemCount: controller.profileFieldStep4.length,
            itemBuilder: (context, index) {
              ProfileFieldData createFieldBody =
                  controller.profileFieldStep4[index];
              return (createFieldBody.name.toString().contains("linkedin")) &&
                      PrefUtils.getAiFeatures()
                  ? buildLinkedinWidget(createFieldBody)
                  : buildEditFieldSocialMedia(createFieldBody);
            },
          )
        ],
      ),
    );
  }

  // Create a ScrollController to control the scroll position
  final ScrollController _scrollController = ScrollController();

  // Method to scroll to the bottom of the page
  void _scrollToEnd() {
    // Scroll to the maximum scroll extent
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, // Max scroll extent
      duration: const Duration(milliseconds: 700), // Animation duration
      curve: Curves.fastOutSlowIn, // Animation curve
    );
  }

  final GlobalKey<FormState> socialFormKey = GlobalKey();

  Widget buildEditFieldSocialMedia(ProfileFieldData createFieldBody) {
    final TextEditingController textAreaController = TextEditingController();
    textAreaController.text = createFieldBody.value ?? "";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        onTap: () {
          Future.delayed(const Duration(milliseconds: 800), _scrollToEnd);
        },
        textInputAction: TextInputAction.done,
        controller: textAreaController,
        enabled: (createFieldBody.readonly != null && createFieldBody.readonly!)
            ? false
            : true,
        maxLength: 100,
        style: TextStyle(
            fontSize: 14.fSize,
            color: colorSecondary,
            fontWeight: FontWeight.normal),
        keyboardType: TextInputType.text,
        validator: (String? value) {
          if (createFieldBody.name == "facebook") {
            if (createFieldBody.rules.toString().contains("required") ||
                value!.trim().isNotEmpty) {
              if (!UiHelper.isValidFacebookUrl(value ?? "")) {
                return "Please enter the correct the link";
              }
            }
          } else if (createFieldBody.name == "twitter") {
            if (createFieldBody.rules.toString().contains("required") ||
                value!.trim().isNotEmpty) {
              if (!UiHelper.isValidTwitterUrl(value ?? "")) {
                return "Please enter the correct the link";
              }
            }
          }
          return null;
        },
        onChanged: (value) {
          if (value.isNotEmpty) {
            createFieldBody.value = textAreaController.text;
          } else {
            createFieldBody.value = "";
          }
        },
        decoration:
            AppDecoration.editFieldDecoration(createFieldBody: createFieldBody),
      ),
    );
  }

  Widget buildLinkedinWidget(ProfileFieldData createFieldBody) {
    final TextEditingController textAreaController = TextEditingController();
    if (createFieldBody.value?.isNotEmpty ?? false) {
      textAreaController.text = createFieldBody.value ?? "";
      controller.linkedInSetupController
          .linkedProfileUrl(createFieldBody.value ?? "");
    } else {
      textAreaController.text = createFieldBody.value ?? "";
      controller.linkedInSetupController
          .linkedProfileUrl(createFieldBody.value ?? "");
    }
    print("@@@ ${createFieldBody.value ?? ""}");
    print(
        "@@@ linked url${controller.linkedInSetupController.linkedProfileUrl}");
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Obx(() => controller
              .linkedInSetupController.linkedProfileUrl.value.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    TextFormField(
                      onTap: () {
                        Future.delayed(
                            const Duration(milliseconds: 800), _scrollToEnd);
                      },
                      textInputAction: TextInputAction.done,
                      controller: textAreaController,
                      enabled: false,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 14.fSize,
                          color: colorSecondary,
                          fontWeight: FontWeight.normal),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          if (createFieldBody.name == "linkedin") {
                            PrefUtils.saveLinkedUrl(createFieldBody.value);
                          }
                          createFieldBody.value = textAreaController.text;
                        } else {
                          createFieldBody.value = "";
                        }
                      },
                      decoration: AppDecoration.editLinkedinDecoration(
                          createFieldBody: createFieldBody),
                    ),
                    controller
                            .linkedInSetupController.linkedProfileUrl.isNotEmpty
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () async {
                                await UiHelper.inAppBrowserView(Uri.parse(
                                    controller.linkedInSetupController
                                            .linkedProfileUrl.value ??
                                        ""));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8, right: 12, left: 12),
                                child: SvgPicture.asset(
                                    ImageConstant.linked_arrow_icon),
                              ),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
                CustomTextView(
                  text:
                      "Note : This URL will be used to generate your AI Profile.",
                  fontSize: 12,
                  color: colorPrimary,
                )
              ],
            )
          : CommonMaterialButton(
              borderWidth: 1,
              borderColor: colorSecondary,
              color: white,
              svgIcon: "assets/svg/linkedin.svg",
              iconHeight: 15,
              height: 52.v,
              text: "connect_linked_account".tr,
              textSize: 16,
              textColor: colorSecondary,
              weight: FontWeight.w500,
              onPressed: () async {
                SignInWithLinkedIn.logout();
                SignInWithLinkedIn.signIn(
                  context,
                  config: authenticationManager.linkedInConfig!,
                  onGetUserProfile: (tokenData, user) {
                    controller.linkedInSetupController
                        .connectFunctionWithLinkedIn(context);
                  },
                  onSignInError: (error) {
                    print('Error on sign in: $error');
                  },
                );
              },
            )),
    );
  }

  Widget editNameWidget(ProfileFieldData createFieldBody) {
    final TextEditingController textAreaController = TextEditingController();
    textAreaController.text = controller.userName;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  controller: textAreaController,
                  maxLength: 30,
                  enabled: false,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: colorSecondary,
                      fontWeight: FontWeight.w600),
                  keyboardType: TextInputType.text,
                  validator: (String? value) {
                    if (createFieldBody.rules.toString().contains("required")) {
                      if (value!.trim().isEmpty) {
                        return "${createFieldBody.validationAs.toString().capitalize} required";
                      } else if (value.length < 2) {
                        return "Please enter valid ${createFieldBody.validationAs.toString().capitalize}";
                      }
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      controller.userName = textAreaController.text;
                    } else {
                      controller.userName = "";
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    counter: const Offstage(),
                    fillColor: Colors.transparent,
                    hintText: createFieldBody.placeholder ?? "",
                    labelStyle: TextStyle(color: colorSecondary, fontSize: 16),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildTextArea(ProfileFieldData createFieldBody) {
    final TextEditingController textAreaController = TextEditingController();
    textAreaController.text = createFieldBody.value.toString().trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: TextFormField(
            textAlign: TextAlign.start,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            controller: textAreaController,
            style: TextStyle(
                fontSize: 15.fSize,
                color: colorSecondary,
                fontWeight: FontWeight.normal),
            onChanged: (value) {
              if (value.isNotEmpty) {
                createFieldBody.value = textAreaController.text.trim();
              } else {
                createFieldBody.value = "";
              }
            },
            validator: (String? value) {
              if (createFieldBody.rules.toString().contains("required")) {
                if (value!.trim().isEmpty || value.trim() == null) {
                  return "Please enter ${createFieldBody.validationAs.toString().capitalize}";
                }
              }
              return null;
            },
            decoration: AppDecoration.editFieldDecoration(
                createFieldBody: createFieldBody),
            minLines: 3,
            maxLines: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownWidget(ProfileFieldData createFieldBody) {
    // Current selected value
    String? selectedValue = createFieldBody.value ?? "";
    List<Options> optionData = createFieldBody.options ?? [];
    return createFieldBody.name == "country_code"
        ? const SizedBox()
        : Stack(
            alignment: Alignment.center,
            children: [
              TextFormField(
                controller: TextEditingController(text: " "),
                textInputAction: TextInputAction.done,
                enabled: false,
                keyboardType: TextInputType.phone,
                decoration: AppDecoration.editFieldDecorationDropdown(
                    createFieldBody: createFieldBody),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton2<dynamic>(
                  isExpanded: true,
                  items: optionData
                      ?.map(
                        (option) => DropdownMenuItem<String>(
                          value: option.value,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: CustomTextView(
                              text: option.text ?? "",
                              fontSize: 14, fontWeight: FontWeight.w500,
                              color: selectedValue.toString() == option.value
                                  ? colorSecondary // Selected text color
                                  : colorGray, // Prevents text overflow
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  value: selectedValue.toString().isNotEmpty
                      ? selectedValue.toString().replaceAll("+", "")
                      : null,
                  onChanged: (newValue) {
                    createFieldBody.value = newValue;
                    controller.profileFieldStep2.refresh();
                  },
                  iconStyleData: IconStyleData(
                    icon: const Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.arrow_drop_down,
                      ),
                    ),
                    iconSize: 22,
                    iconEnabledColor: colorSecondary,
                    iconDisabledColor: colorSecondary,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    //width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: white,
                    ),
                    offset: const Offset(0, -5),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: WidgetStateProperty.all<double>(6),
                      thumbVisibility: WidgetStateProperty.all<bool>(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 35,
                    padding: EdgeInsets.only(left: 14, right: 14),
                  ),
                ),
              ),
            ],
          );
  }

  Widget checkBoxWidget(ProfileFieldData createFieldBody) {
    return GestureDetector(
      onTap: () async {
        if (createFieldBody.readonly != null && createFieldBody.readonly!) {
          return;
        }
        var result = await Get.to(() => ProfileSelectDialog(
              createFieldBody: createFieldBody,
            ));
        if (result != null) {
          createFieldBody = result;
          setState(() {});
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: CustomTextView(
              text: createFieldBody.label ?? "",
              textAlign: TextAlign.start,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            subtitle: Container(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 15, left: 20, right: 10),
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  color: (createFieldBody.readonly != null &&
                          createFieldBody.readonly!)
                      ? colorLightGray
                      : white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: colorGray),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    createFieldBody.value != null &&
                            createFieldBody.value.isNotEmpty &&
                            createFieldBody.value is List
                        ? _dynamicFilterWidget(createFieldBody.value, true)
                        : CustomTextView(
                            text: createFieldBody.value.toString() == "[]"
                                ? ""
                                : createFieldBody.value ?? "",
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                    const Icon(Icons.arrow_drop_down)
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget _buildEditTextSearch(ProfileFieldData createFieldBody) {
    final TextEditingController textAreaController = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 5, bottom: 0),
          child: TextFormField(
            textInputAction: TextInputAction.done,
            controller: textAreaController,
            enabled:
                (createFieldBody.readonly != null && createFieldBody.readonly!)
                    ? false
                    : true,
            keyboardType: TextInputType.text,
            validator: (String? value) {
              if (createFieldBody.rules.toString().contains("required")) {
                if (value!.trim().isEmpty) {
                  return "${createFieldBody.validationAs.toString().capitalize} required";
                } else if (value.length < 2) {
                  return "Please enter ${createFieldBody.validationAs.toString().capitalize}";
                }
              }
              return null;
            },
            style: TextStyle(
                fontSize: 14.fSize,
                color: colorSecondary,
                fontWeight: FontWeight.normal),
            onFieldSubmitted: (value) {
              if (value.isNotEmpty && createFieldBody.value is List) {
                createFieldBody.value.add(value);
                textAreaController
                    .clear(); // Clear the text field after submission
                controller.profileFieldStep3.refresh();
              }
            },
            decoration: AppDecoration.editFieldDecoration(
                createFieldBody: createFieldBody),
          ),
        ),
        createFieldBody.value.isNotEmpty
            ? _dynamicSearchFilterWidget(createFieldBody)
            : const SizedBox(),
        SizedBox(
          height: 10.v,
        ),
      ],
    );
  }

  Widget _dynamicSearchFilterWidget(ProfileFieldData createFieldBody) {
    return Wrap(
      spacing: 10,
      children: <Widget>[
        for (var item in createFieldBody.value)
          MyFlowWidgetCross(
            item ?? "",
            press: () {
              controller.profileFieldStep3.refresh();
            },
            createFieldBody: createFieldBody,
          ),
      ],
    );
  }

  Widget _dynamicFilterWidget(List<dynamic>? value, isBg) {
    return Expanded(
        child: Wrap(
      spacing: 10,
      children: <Widget>[
        for (var item in value!) MyFlowWidget(item ?? "", isBgColor: isBg),
      ],
    ));
  }
}

class GradientBorderCircle extends StatelessWidget {
  final String imageUrl;
  final double size;
  final double borderWidth;

  const GradientBorderCircle({
    Key? key,
    required this.imageUrl,
    this.size = 100.0,
    this.borderWidth = 5.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: AppDecoration.aiRoundedBoxDecoration,
      child: Padding(
        padding: EdgeInsets.all(borderWidth),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: white, // Background color inside the gradient border
          ),
          child: ClipOval(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, size: 50);
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }
}
