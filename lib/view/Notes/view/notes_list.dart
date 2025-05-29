import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/app_decoration.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/Notes/controller/my_notes_controller.dart';
import 'package:dreamcast/view/exhibitors/controller/exhibitorsController.dart';
import 'package:dreamcast/view/representatives/controller/user_detail_controller.dart';
import 'package:dreamcast/view/skeletonView/ListDocumentSkeleton.dart';
import 'package:dreamcast/view/speakers/controller/speakersController.dart';
import 'package:dreamcast/widgets/button/common_material_button.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../widgets/customImageWidget.dart';
import '../../../widgets/dialog/custom_animated_dialog_widget.dart';
import '../../../widgets/loading.dart';
import '../../dashboard/showLoadingPage.dart';
import '../model/common_notes_model.dart';

class CommonNotesPage extends GetView<MyNotesController> {
  CommonNotesPage({super.key, required this.index});

  int index;
  static const routeName = "/MyNotesPage";
  TextEditingController editNotesController = TextEditingController();

  ///refresh the page.
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  final controller = Get.put(MyNotesController());
  final GlobalKey<FormState> formKey = GlobalKey();
  final UserDetailController userDetailsController = Get.find();
  var _isButtonDisabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: GetX<MyNotesController>(
          builder: (controller) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: commonNotesListview(context), // Speakers Notes List
                ),
                _progressEmptyWidget(),
              ],
            );
          },
        ));
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isLoading.value
          ? const Loading()
          : controller.commonNotesList.isEmpty && !controller.firstLoading.value
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  ///*********** Attendees Notes List **************///
  commonNotesListview(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          return Future.delayed(
            const Duration(seconds: 1),
            () {
              controller.callApis(controller.selectedTabIndex.value);
            },
          );
        },
        child: Skeletonizer(
          enabled: controller.firstLoading.value,
          child: controller.firstLoading.value
              ? NotesSkeleton()
              : ListView.separated(
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 20,
                    );
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shrinkWrap: false,
                  itemCount: controller.commonNotesList.length,
                  itemBuilder: (context, index) {
                    return itemsDetailsWidget(
                        context, controller.commonNotesList[index]);
                  }),
        ),
      ),
    );
  }

  Widget buildEditDeletePopup(BuildContext context, NotesDataModel details) {
    return SizedBox(
      // width: 132.adaptSize,
      child: Card(
          color: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: colorGray, width: 1),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    editBottomSheet(context, details);
                    details.showPopup(!details.showPopup.value);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(ImageConstant.editIcon),
                      const SizedBox(width: 10),
                      CustomTextView(
                        text: "Edit Note",
                        color: colorSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    controller.showDeleteNoteDialog(
                      context: context,
                      title: "delete".tr,
                      confirmButtonText: "delete".tr,
                      logo: ImageConstant.icDelete,
                      content:
                          "Are you sure you want to ${"delete".tr} this Note?",
                      body: {
                        "item_id": details.item?.id ?? "",
                        "item_type": details.item!.type ?? "",
                        "id": details.id ?? 0,
                      },
                    );
                    details.showPopup(!details.showPopup.value);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(ImageConstant.icDelete),
                      const SizedBox(width: 10),
                      CustomTextView(
                        text: "Delete Note",
                        color: colorSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  ///************ Items Details widget *************///
  itemsDetailsWidget(BuildContext context, NotesDataModel details) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 8, bottom: 20, top: 10),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: () {
                              details.showPopup(!details.showPopup.value);
                              controller.hideAllMenu(details.id ?? "");
                            },
                            child: Container(
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorLightGray,
                              ),
                              child: const Icon(Icons.more_vert),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 50, top: 10),
                        child: CustomReadMoreText(
                          text: details.text ?? "",
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          fontSize: 18,color: colorSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // need to show the pop for delete and edit
                GestureDetector(
                  onTap: () async {
                    switch (details.item?.type ?? "") {
                      case "speaker":
                        if (Get.isRegistered<SpeakersDetailController>()) {
                          SpeakersDetailController spController = Get.find();
                          controller.isLoading(true);
                          await spController.getSpeakerDetail(
                              speakerId: details.item?.id,
                              role: details.item?.type ?? "",
                              isSessionSpeaker: true);
                          controller.isLoading(false);
                        } else {
                          SpeakersDetailController spController =
                              Get.put(SpeakersDetailController());
                          controller.isLoading(true);
                          await spController.getSpeakerDetail(
                              speakerId: details.item?.id,
                              role: details.item?.type ?? "",
                              isSessionSpeaker: true);
                          controller.isLoading(false);
                        }
                        break;
                      case "user":
                        if (Get.isRegistered<UserDetailController>()) {
                          UserDetailController userController = Get.find();
                          controller.isLoading(true);
                          await userController.getUserDetailApi(
                              details.item?.id, details.item?.type ?? "");
                          controller.isLoading(false);
                        } else {
                          UserDetailController userController =
                              Get.put(UserDetailController());
                          controller.isLoading(true);
                          await userController.getUserDetailApi(
                              details.item?.id, details.item?.type ?? "");
                          controller.isLoading(false);
                        }
                        break;
                      case "representative":
                        if (Get.isRegistered<UserDetailController>()) {
                          UserDetailController userController = Get.find();
                          controller.isLoading(true);
                          await userController.getUserDetailApi(
                              details.item?.id, details.item?.type ?? "");
                          controller.isLoading(false);
                        } else {
                          UserDetailController userController =
                              Get.put(UserDetailController());
                          controller.isLoading(true);
                          await userController.getUserDetailApi(
                              details.item?.id, details.item?.type ?? "");
                          controller.isLoading(false);
                        }
                        break;
                      case "exhibitor":
                        if (Get.isRegistered<BoothController>()) {
                          BoothController bootController = Get.find();
                          controller.isLoading(true);
                          await bootController
                              .getExhibitorsDetail(details.item?.id);
                          controller.isLoading(false);
                        } else {
                          BoothController controller =
                              Get.put(BoothController());
                          controller.isLoading(true);
                          await controller
                              .getExhibitorsDetail(details.item?.id);
                          controller.isLoading(false);
                        }
                        break;
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    height: 50,
                    decoration: BoxDecoration(
                        color: colorLightGray,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              CustomImageWidget(
                                imageUrl: details.item?.avatar ?? "",
                                shortName: UiHelper.getShortName(
                                    details.item?.name ?? ""),
                                size: 35.adaptSize,
                                borderWidth: 0,
                                color: white,
                                fontSize: 14,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: CustomTextView(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  text: details.item?.name ?? "",
                                  color: colorPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SvgPicture.asset(ImageConstant.arrowDetails,
                            color: colorPrimary),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            details.showPopup.value
                ? Positioned(
                    // width: 172.adaptSize,
                    top: 40.adaptSize,
                    right: 5,
                    child: buildEditDeletePopup(context, details),
                  )
                : const SizedBox()
          ],
        ),
      );
    });
  }

  ///********* Edit Bottom Sheet ***********///

  editBottomSheet(BuildContext context, NotesDataModel details) {
    editNotesController.text = details.text ?? "";
    showModalBottomSheet(
        context: context,
        backgroundColor: white,
        isScrollControlled:
            true, // Allows bottom sheet to adjust when keyboard opens
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextView(
                              text: "edit_note".tr,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: colorSecondary,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SvgPicture.asset(ImageConstant.icClose),
                            ),
                          ],
                        ),
                        Divider(color: colorLightGray),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                maxHeightDiskCache: 900,
                                height: 35,
                                width: 35,
                                imageUrl: details.item?.avatar ?? "",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.contain),
                                  ),
                                ),
                                placeholder: (context, url) => Center(
                                  child: Image.asset(
                                      ImageConstant.imagePlaceholder),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: CustomTextView(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  text: details.item?.name ?? "",
                                  color: colorDisabled,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Form(
                          key: formKey,
                          child: TextFormField(
                              maxLength: 1024,
                              maxLines: 2,
                              minLines: 1,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              controller: editNotesController,
                              validator: (String? value) {
                                if (value == null ||
                                    value.toString().trim().isEmpty) {
                                  return "enter_notes".tr;
                                } else if (value.length < 3) {
                                  return "notes_length_validation".tr;
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                hintText: "Enter Notes",
                                hintStyle:
                                    const TextStyle(color: colorDisabled),
                                filled: true,
                                prefixIconConstraints:
                                    const BoxConstraints(minWidth: 60),
                                enabledBorder:
                                    AppDecoration.outlineBorder(colorLightGray),
                                focusedBorder:
                                    AppDecoration.outlineBorder(colorLightGray),
                                errorBorder:
                                    AppDecoration.outlineBorder(accentColor),
                                border:
                                    AppDecoration.outlineBorder(colorLightGray),
                                focusedErrorBorder:
                                    AppDecoration.outlineBorder(accentColor),
                              )),
                        ),
                        const SizedBox(height: 15),
                        CommonMaterialButton(
                            text: "save_changes".tr,
                            color: colorPrimary,
                            onPressed: () async {
                              if (formKey.currentState?.validate() ?? false) {
                                if (_isButtonDisabled)
                                  return; // Prevent further clicks
                                _isButtonDisabled = true;
                                Future.delayed(const Duration(seconds: 2), () {
                                  _isButtonDisabled =
                                      false; // Re-enable the button after the screen is closed
                                });
                                FocusScope.of(context).unfocus();
                                if (editNotesController.text
                                    .trim()
                                    .isNotEmpty) {
                                  var postRequest = {
                                    "item_id": details.item?.id ?? "",
                                    // Attendee/Exhibitor/Speaker Id
                                    "item_type": controller
                                                .selectedTabIndex.value ==
                                            0
                                        ? MyConstant.attendee
                                        : controller.selectedTabIndex.value == 1
                                            ? MyConstant.exhibitor
                                            : MyConstant.speakers,
                                    // User type(Attendee/Exhibitor/Speaker)
                                    "text": editNotesController.text.trim(),
                                    "id": details.id,
                                  };
                                  var result = await controller
                                      .addNotesToUser(postRequest);
                                  details.text =
                                      editNotesController.text.trim();
                                  controller.commonNotesList.refresh();
                                  Future.delayed(const Duration(seconds: 0),
                                      () async {
                                    await Get.dialog(
                                        barrierDismissible: false,
                                        CustomAnimatedDialogWidget(
                                          title: "",
                                          logo: ImageConstant.icSuccessAnimated,
                                          description: result['message'],
                                          buttonAction: "okay".tr,
                                          buttonCancel: "cancel".tr,
                                          isHideCancelBtn: true,
                                          onCancelTap: () {},
                                          onActionTap: () async {
                                            Navigator.pop(context);
                                          },
                                        ));
                                  });
                                  Navigator.pop(context);
                                } else {
                                  return;
                                }
                              }
                            }),
                      ],
                    ),
                  ),
                ),
                Obx(() => controller.isLoading.value
                    ? SizedBox(height: 200.adaptSize, child: const Loading())
                    : const SizedBox()),
              ],
            ),
          );
        });
  }
}
