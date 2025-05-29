import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_decoration.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/view/profileSetup/view/profile_select_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';

import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/image_constant.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/dialog/custom_dialog_widget.dart';
import '../../../widgets/flow_widget.dart';
import '../../../widgets/button/common_material_button.dart';
import '../../../widgets/profile_form_field.dart';
import '../../account/model/createProfileModel.dart';
import '../../../widgets/toolbarTitle.dart';
import 'dart:io';

import '../controller/draftProfileController.dart';

class DraftProfilePage extends StatefulWidget {
  const DraftProfilePage({Key? key}) : super(key: key);
  static const routeName = "/draftProfilePage";
  @override
  State<DraftProfilePage> createState() => _DraftProfilePageState();
}

class _DraftProfilePageState extends State<DraftProfilePage> {
  final AuthenticationManager authenticationManager = Get.find();
  final DraftProfileController controller = Get.put(DraftProfileController());
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
        title: const ToolbarTitle(title: "AI Profile Preview"),
      ),
      body: GetX<DraftProfileController>(
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
                child: controller.isAIPublished.value == false
                    ? Row(
                        children: [
                          Expanded(
                            child: CommonMaterialButton(
                              color: white,
                              borderColor: colorSecondary,
                              text: "save_draft".tr,
                              textColor: colorSecondary,
                              onPressed: () {
                                if (socialFormKey.currentState?.validate() ??
                                    false) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  controller.updateProfile(context,
                                      isPublish: false, isLater: true);
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                              child: CommonMaterialButton(
                            color: colorPrimary,
                            text: "Publish",
                            onPressed: () {
                              if (socialFormKey.currentState?.validate() ??
                                  false) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialogWidget(
                                      title: "Are you sure?",
                                      logo: ImageConstant.ic_question_confirm,
                                      description:
                                          "you want to publish your AI-generated profile? Once published, it will update your existing profile.",
                                      buttonAction: "Yes, Proceed",
                                      buttonCancel: "Cancel",
                                      isShowBtnCancel: true,
                                      onCancelTap: () {},
                                      onActionTap: () async {
                                        controller.updateProfile(context,
                                            isPublish: true, isLater: false);
                                      },
                                    );
                                  },
                                );
                              }
                            },
                          ))
                        ],
                      )
                    : Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: colorLightGray,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: CustomTextView(
                          text: "Your AI profile has already been published!",
                          color: colorPrimary,
                        ),
                      ),
              ),
              controller.isLoading.value ? const Loading() : const SizedBox()
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
          SizedBox(
            height: 18.adaptSize,
          ),
          SizedBox(
            width: 104.h,
            height: 104.v,
            child: Stack(
              children: [
                controller.profileImage.value.path.isEmpty &&
                        controller.aiProfileImg.isNotEmpty
                    ? GradientBorderCircle(
                        imageUrl: controller.aiProfileImg,
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
      decoration: BoxDecoration(
          color: colorLightGray,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CustomTextView(
              text: "info".tr,
              fontSize: 19,
              color: colorSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.profileFieldStep2.length,
            itemBuilder: (context, index) {
              ProfileFieldData createFieldBody =
                  controller.profileFieldStep2[index];
              createFieldBody.readonly = true;
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
                          ? ProfileFormField(
                              profileFieldData: createFieldBody,
                              mobileCode: countryCode,
                            )
                          : const SizedBox();
            },
          )
        ],
      ),
    );
  }

  Widget bioProfileWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: colorSecondary,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        gradient: LinearGradient(
          colors: [gradientBegin, gradientEnd],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorLightGray,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        margin: const EdgeInsets.only(top: 20, left: 2, right: 2, bottom: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CustomTextView(
                text: "bio".tr,
                textAlign: TextAlign.start,
                fontSize: 19,
                color: colorSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
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
    );
  }

  Widget socialProfileWidget() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorLightGray,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CustomTextView(
              text: "social_media".tr,
              fontSize: 18,
              color: colorSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
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
              return (createFieldBody.name.toString().contains("linkedin"))
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
    createFieldBody.readonly = true;
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
        enabled: false,
        maxLength: 100,
        style: TextStyle(
            fontSize: 14.fSize,
            color: colorSecondary,
            fontWeight: FontWeight.normal),
        keyboardType: TextInputType.text,
        validator: (String? value) {
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
      controller.linkedProfileUrl(createFieldBody.value ?? "");
    } else {
      textAreaController.text = "";
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Obx(() => controller.linkedProfileUrl.value.isNotEmpty
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
                    controller.linkedProfileUrl.isNotEmpty
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () async {
                                await UiHelper.inAppBrowserView(Uri.parse(
                                    controller.linkedProfileUrl.value ?? ""));
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
                      "NOTE: This URL will be used to generate your AI Profile.",
                  fontSize: 12,
                  color: colorGray,
                )
              ],
            )
          : const SizedBox()),
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

  Widget buildMobileEditText(ProfileFieldData createFieldBody) {
    final TextEditingController textAreaController = TextEditingController();
    textAreaController.text = createFieldBody.value ?? "";
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextFormField(
            textInputAction: TextInputAction.done,
            controller: textAreaController,
            enabled:
                (createFieldBody.readonly != null && createFieldBody.readonly!)
                    ? false
                    : true,
            maxLength: 16,
            keyboardType: TextInputType.phone,
            validator: (String? value) {
              if (createFieldBody.rules.toString().contains("required")) {
                if (value!.trim().isEmpty) {
                  return "${createFieldBody.validationAs.toString().capitalize} required";
                } else if (value.length < 2) {
                  return "Please enter valid ${createFieldBody.validationAs.toString().capitalize}";
                } else if (createFieldBody.validationAs
                    .toString()
                    .contains("Mobile")) {
                  if (!UiHelper.isValidPhoneNumber(value.toString())) {
                    return "enter_valid_mobile".tr;
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
            decoration: AppDecoration.editFieldDecoration(
                createFieldBody: createFieldBody),
          ),
        ],
      ),
    );
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

  Widget buildTextViewWidget(ProfileFieldData createFieldBody) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: CustomTextView(
        text: createFieldBody.label ?? "",
        textAlign: TextAlign.start,
        fontSize: 16,
      ),
      subtitle: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 55,
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color:
                (createFieldBody.readonly != null && createFieldBody.readonly!)
                    ? colorLightGray
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: colorLightGray),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: CustomTextView(
              text: createFieldBody.value ?? "",
              fontSize: 16,
            ),
          )),
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
                      : Colors.white,
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

  String getTextFromValue(ProfileFieldData createFieldBody) {
    var value = "";
    for (var data in createFieldBody.options ?? []) {
      if (data.value == createFieldBody.value) {
        value = data.text ?? "";
      }
    }
    return value;
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
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [gradientBegin, gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(borderWidth),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white, // Background color inside the gradient border
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
