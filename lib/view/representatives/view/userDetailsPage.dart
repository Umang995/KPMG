import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/Notes/controller/my_notes_controller.dart';
import 'package:dreamcast/view/Notes/model/common_notes_model.dart';
import 'package:dreamcast/view/account/model/notes_model.dart';
import 'package:dreamcast/view/representatives/dialog/connect_chat_dialog.dart';
import 'package:dreamcast/view/representatives/model/user_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';

import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../api_repository/app_url.dart';
import '../../../theme/app_decoration.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/animatedBookmark/AnimatedBookmarkWidget.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/company_position_widget.dart';
import '../../../widgets/customImageWidget.dart';
import '../../../widgets/button/custom_icon_button.dart';
import '../../../widgets/custom_linkfy.dart';
import '../../../widgets/dialog/custom_animated_dialog_widget.dart';
import '../../../widgets/flow_widget.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../chat/controller/roomController.dart';
import '../../chat/model/user_model.dart';
import '../../chat/view/chat_detail.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../commonController/view/common_chat_dialog.dart';
import '../../meeting/view/meeting_dashboard_page.dart';
import '../../reportUser/userReportPage.dart';
import '../controller/user_detail_controller.dart';

class UserDetailPage extends GetView<UserDetailController> {
  UserDetailPage({Key? key}) : super(key: key);
  static const routeName = "/RepresentativeDetailPage";
  var pageTitle = "".obs;
  final AuthenticationManager _authManager = Get.find();
  final roomController = Get.put(RoomController());

  final GlobalKey<FormState> formKey = GlobalKey();

  Color? chatBorderColor = colorGray;
  Color? chatTextColor = colorSecondary;
  Color chatHintTextColor = colorSecondary;
  String chatText = "Chat";
  String chatHintText = "";

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) {
        if (controller.notesEdtController.text.trim().isNotEmpty &&
            controller.notesEdtController.text.trim() !=
                controller.notesData.value.text!.trim()) {
          controller.saveEditNotesApi(context);
        }
      },
      canPop: true,
      child: Scaffold(
        backgroundColor: colorLightGray,
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
          title: Obx(() => ToolbarTitle(title: controller.pageTitle.value)),
          backgroundColor: colorLightGray,
          dividerHeight: 0,
          actions: [
            Obx(
              () => Stack(
                alignment: Alignment.center,
                children: [
                  controller.isBlocked.value == false
                      ? AnimatedBookmarkWidget(
                          height: 22,
                          id: controller.userDetailBody.value.id ?? "",
                          bookMarkIdsList: controller.bookMarkIdsList ?? [],
                          padding: const EdgeInsets.all(6),
                          onTap: () {
                            controller.bookmarkToUser(
                                controller.userDetailBody.value.id,
                                controller.userDetailBody.value.role,
                                context);
                          },
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            GestureDetector(
                onTap: () {
                  controller.shareEvent(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: SvgPicture.asset(
                    ImageConstant.share_icon,
                    width: 18,
                    color: colorSecondary,
                  ),
                )),
            _authManager.configModel.body?.reportOptions?.isNetworking ?? false
                ? GestureDetector(
              onTap: () {
                Get.to(UserReportPage(
                  itemId: controller.userDetailBody.value.id ?? "",
                  itemType: controller.userDetailBody.value.role ?? "",
                ));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: SvgPicture.asset(
                  ImageConstant.reportPost,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onSurface, BlendMode.srcIn),
                ),
              ),
            ) : const SizedBox()
          ],
        ),
        body: SizedBox(
          height: context.height,
          width: context.width,
          child: GetX<UserDetailController>(
            builder: (controller) {
              UserDetailBody? personalObject = controller.userDetailBody.value;
              return Stack(
                children: [
                  RefreshIndicator(
                    strokeWidth: 4.0,
                    onRefresh: () {
                      return Future.delayed(
                        const Duration(seconds: 1),
                        () {
                          controller.commonChatMeetingController
                              .getChatRequestStatus(
                                  isShow: false,
                                  receiverId:
                                      controller.userDetailBody.value.id ?? "");
                        },
                      );
                    },
                    child: SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Stack(
                        fit: StackFit.loose,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 49.adaptSize),
                            width: context.width,
                            // height: context.height - 49.adaptSize - 73,
                            constraints: BoxConstraints(
                              minHeight: context.height - 49.adaptSize - 73,
                            ),
                            decoration: AppDecoration.roundedBoxDecoration,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 55.adaptSize,
                                ),
                                buildBannerView(context, personalObject),
                                bodyList(context),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: DetailImageWidget(
                              imageUrl: personalObject.avatar ?? "",
                              shortName: personalObject.shortName ?? "",
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  controller.isLoading.value ||
                          controller.commonChatMeetingController.isLoading.value
                      ? const Loading()
                      : const SizedBox()
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /*header with gallery list view */
  Widget bodyList(BuildContext context) {
    UserDetailBody body = controller.userDetailBody.value;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (body.bio?.params != null && body.bio!.params!.isNotEmpty)
            ? aboutWidget(body.bio, body.bio?.text ?? "", colorLightGray)
            : const SizedBox(),
        if (controller.userDetailBody.value.socialMedia?.params?.isNotEmpty ??
            false)
          buildSocialMedia(),
        body.virtual != null && body.virtual!.params!.isNotEmpty
            ? interestWidget(body.virtual, body.virtual?.label, colorLightGray)
            : const SizedBox(),
        if (!controller.isBlocked.value) buildNotesWidget(context),
        const SizedBox(
          height: 50,
        )
      ],
    );
  }

  //show top banner and type of media load
  buildBannerView(BuildContext context, UserDetailBody personalObject) {
    return SizedBox(
      width: context.width * 0.55,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextView(
              maxLines: 1,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              text: personalObject.name.toString().capitalize ?? ""),
          CompanyPositionWidget(
            company: personalObject.company ?? "",
            position: personalObject.position ?? "",
          ),
          const SizedBox(
            height: 18,
          ),
          !controller.isBlocked.value &&
                  (personalObject.isMeeting == 1 &&
                      (PrefUtils.isMeeting() ?? false))
              ? buildMeetingButton(context)
              : const SizedBox(),
          Skeletonizer(
            child: blockChatMeetingWidget(context, personalObject),
            enabled: controller.commonChatMeetingController.isChatLoading.value,
          )
        ],
      ),
    );
  }

  blockChatMeetingWidget(BuildContext context, UserDetailBody personalObject) {
    bool showChat = !controller.isBlocked.value &&
        (personalObject.isChat == 1 && (PrefUtils.isChat() ?? false));
    return Skeleton.shade(
        child: controller.isBlocked.value == false
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  showChat
                      ? Expanded(
                          flex: 1,
                          child: buildChatButton(context),
                        )
                      : const SizedBox(),
                  controller.isBlocked.value || !showChat
                      ? const SizedBox()
                      : const SizedBox(
                          width: 12,
                        ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        blockButton(context),
                        const CustomTextView(text: "")
                      ],
                    ),
                  )
                ],
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [blockButton(context), const CustomTextView(text: "")],
                ),
              ));
  }

  Widget blockButton(BuildContext context) {
    return CustomIconButton(
      onTap: () {
        controller.saveBlockUnblockDialog(
            context: context,
            content: "",
            body: {"block_user_id": controller.userDetailBody.value.id ?? ""});
      },
      height: 50,
      decoration: BoxDecoration(
          color: white,
          border: Border.all(color: colorGray, width: 1),
          borderRadius: BorderRadius.circular(10)),
      width: context.width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const SizedBox(width: 6,),
          controller.isBlocked.value
              ? SvgPicture.asset(
                  ImageConstant.icBlockUnBlock,
                )
              : SvgPicture.asset(
                  ImageConstant.icBlockUnBlock,
                ),
          // const SizedBox(width: 6,),
          AutoCustomTextView(
            text: controller.isBlocked.value ? "Unblock" : "Block",
            color: colorSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          // const SizedBox(width: 6,),
        ],
      ),
    );
  }

  Widget buildChatButton(BuildContext context) {
    chatHintText = "";
    var chatData = controller.commonChatMeetingController.chatStatusBody.value;

    if (chatData.id == null && chatData.iam == null) {
      chatText = "Chat";
      chatTextColor = colorSecondary;
      chatBorderColor = colorGray;
    } else if (chatData.id != null && chatData.iam == "receiver") {
      if (chatData.status == -1) {
        chatText = "Chat";
        chatTextColor = colorGray;
        chatBorderColor = colorGray;
        chatHintText = "*Request Rejected";
        chatHintTextColor = Colors.red;
      } else if (chatData.status == 0) {
        chatText = "Chat";
        chatTextColor = Colors.blue;
        chatBorderColor = colorGray;
        chatHintText = "*Request Received";
      } else if (chatData.status == 1) {
        chatText = "Chat";
        chatTextColor = colorSecondary;
        chatBorderColor = colorGray;
      }
    } else {
      if (chatData.status == 0) {
        chatText = "Chat";
        chatTextColor = colorGray;
        chatBorderColor = colorGray;
        chatHintText = "*Request Pending";
      }
      if (chatData.status == 1) {
        chatText = "Chat";
        chatTextColor = colorSecondary;
        chatBorderColor = Colors.black;
      }
      if (chatData.status == -1) {
        chatText = "Chat";
        chatTextColor = colorGray;
        chatBorderColor = colorGray;
        chatHintText = "*Request Rejected";
        chatHintTextColor = Colors.red;
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconButton(
          onTap: () {
            if (chatData.id == null) {
              openChatDialog(context);
            } else if (chatData.id != null && chatData.status == -1) {
              UiHelper.showFailureMsg(
                  context, "request_reject_cant_send_request".tr);
            } else {
              openChatDetailPage();
            }
          },
          height: 50,
          width: context.width,
          decoration: BoxDecoration(
              border: Border.all(color: chatBorderColor ?? colorGray, width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 3,
              ),
              SvgPicture.asset(
                ImageConstant.ic_chat,
                color: chatTextColor,
              ),
              const SizedBox(
                width: 3,
              ),
              Flexible(
                child: AutoCustomTextView(
                  text: chatText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.start,
                  maxLines: 3,
                  color: chatTextColor ?? colorSecondary,
                ),
              ),
              const SizedBox(
                width: 3,
              ),
            ],
          ),
        ),
        CustomTextView(
          text: chatHintText,
          fontSize: 11,
          maxLines: 1,
          color: chatHintTextColor,
          fontWeight: FontWeight.normal,
          textAlign: TextAlign.start,
        )
      ],
    );
  }

  ///meeting button
  Widget buildMeetingButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconButton(
          onTap: () {
            controller.commonChatMeetingController.showScheduleDialog(
                context,
                controller.userDetailBody.value.id ?? "",
                controller.userDetailBody.value.name ?? "",
                controller.userDetailBody.value.avatar ?? "",
                controller.userDetailBody.value.shortName ?? "",
                controller.userDetailBody.value.role ?? "",
                "");
          },
          height: 50,
          width: context.width,
          decoration: BoxDecoration(
              color: colorPrimary,
              border: Border.all(color: colorPrimary, width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(ImageConstant.ic_one_to_one),
              const SizedBox(width: 8.0),
              AutoCustomTextView(
                text: "schedule_one_two_one".tr,
                fontSize: 16,
                maxLines: 1,
                fontWeight: FontWeight.w500,
                color: white,
              ),
              // Icon(Icons.arrow_forward_ios, size: 12.adaptSize, color: white)
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  ///this is about widget
  Widget aboutWidget(dynamic about, String title, Color color) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 1,
        );
      },
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: about?.params?.length ?? 0,
      itemBuilder: (context, index) {
        var data = about?.params?[index];

        return StatefulBuilder(
          builder: (context, setState) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: CustomTextView(
                  text: data?.text ?? "",
                  color: colorSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 19,
                  textAlign: TextAlign.start,
                ),
              ),
              subtitle: Container(
                width: context.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    data.value is List
                        ? Wrap(
                            spacing: 10,
                            children: <Widget>[
                              for (var item in data?.value ?? [])
                                MyFlowWidget(item ?? "", isBgColor: true),
                            ],
                          )
                        : ReadMoreLinkify(
                            text: data?.value
                                    .replaceAll("<br", "")
                                    .replaceAll("/>", "") ??
                                "",
                            maxLines:
                                5, // Set the maximum number of lines before truncation
                            style: TextStyle(
                                fontSize: 16.fSize,
                                color: colorSecondary,
                                fontWeight: FontWeight.normal),
                            textAlign: TextAlign.start,
                            linkStyle: TextStyle(
                                fontSize: 16.fSize,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500),
                            onOpen: (link) async {
                              final Uri url = Uri.parse(link.url);
                              if (await canLaunchUrlString(link.url)) {
                                await launchUrlString(link.url,
                                    mode: LaunchMode.externalApplication);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget interestWidget(Virtual? virtualData, String? title, Color color) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: colorSecondary,
          gradient: LinearGradient(
            colors: [gradientBegin, gradientEnd],
          )),
      child: Container(
        margin: EdgeInsets.all(
            controller.userDetailBody.value.aiProfile == 0 ? 0 : 1),
        padding: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
            color: color,
            border: Border.all(color: borderColor, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: ListView.separated(
          padding: const EdgeInsets.all(6),
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 1,
              child: Divider(
                color: colorGray,
              ),
            );
          },
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: virtualData?.params?.length ?? 0,
          itemBuilder: (context, index) {
            VirtualParams? data = virtualData?.params?[index];
            return ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: CustomTextView(
                  text: data?.label ?? "",
                  color: colorSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  textAlign: TextAlign.start,
                ),
              ),
              subtitle: Wrap(
                spacing: 10,
                children: <Widget>[
                  for (var item in data?.value ?? [])
                    MyFlowWidget(item ?? "", isBgColor: true),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildNotesWidget(BuildContext context) {
    return Skeletonizer(
      enabled: controller.isNotesLoading.value,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: colorLightGray,
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.zero,
                  child: CustomTextView(
                    text: controller.isEditNotes.value
                        ? "add_note".tr
                        : "notes".tr,
                    fontSize: 18,
                    color: colorSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                controller.notesData.value.text != null &&
                        controller.notesData.value.text.toString().isNotEmpty
                    ? InkWell(
                        onTap: () async {
                          if (!controller.isEditNotes.value) {
                            controller
                                .isEditNotes(!controller.isEditNotes.value);
                            return;
                          }
                          if (formKey.currentState?.validate() ?? false) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (controller.notesEdtController.text
                                .trim()
                                .isEmpty) {
                              return;
                            }
                            controller.saveEditNotesApi(context);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: CustomTextView(
                            text: controller.isEditNotes.value
                                ? "save".tr
                                : "edit".tr,
                            fontSize: 18,
                            color: colorPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            Container(
              margin:
                  EdgeInsets.only(top: controller.isEditNotes.value ? 14 : 10),
              padding: EdgeInsets.zero,
              child: controller.isEditNotes.value
                  ? Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: formKey,
                      child: TextFormField(
                        enabled: controller.isEditNotes.value,
                        controller: controller.notesEdtController,
                        maxLength: 1024,
                        maxLines: 2,
                        minLines: 1,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        style: TextStyle(
                            fontSize: 14,
                            color: colorSecondary,
                            fontWeight: FontWeight.normal),
                        validator: (String? value) {
                          if (value == null ||
                              value.toString().trim().isEmpty) {
                            Future.delayed(const Duration(seconds: 1), () {
                              controller.notesData(NotesDataModel(
                                text: value,
                                id: controller.notesData.value.id ?? "",
                              ));
                            });
                            return "enter_notes".tr;
                          } else if (value.length < 3) {
                            return "notes_length_validation".tr;
                          } else {
                            Future.delayed(const Duration(seconds: 1), () {
                              controller.notesData(NotesDataModel(
                                text: value,
                                id: controller.notesData.value.id ?? "",
                              ));
                            });
                            return null;
                          }
                        },
                        onChanged: (value) {},
                        onEditingComplete: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        decoration: InputDecoration(
                            counter: const Offstage(),
                            contentPadding:
                                const EdgeInsets.fromLTRB(16, 15, 16, 15),
                            labelText: "notes".tr,
                            hintText: "type_here".tr,
                            hintStyle: TextStyle(
                                fontSize: 14.fSize,
                                color: colorGray,
                                fontWeight: FontWeight.normal),
                            labelStyle: TextStyle(
                                fontSize: 14.fSize,
                                color: colorGray,
                                fontWeight: FontWeight.normal),
                            fillColor: white,
                            filled: true,
                            prefixIconConstraints:
                                const BoxConstraints(minWidth: 60),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: colorSecondary)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.red)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.grey))),
                      ),
                    )
                  : CustomTextView(
                      text: controller.notesData.value.text.toString(),
                      // color: textGrayColor,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      maxLines: 50,
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSocialMedia() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 6),
            child: CustomTextView(
              text: controller
                      .userDetailBody.value.socialMedia?.text?.capitalize ??
                  "",
              color: colorSecondary,
              fontWeight: FontWeight.w500,
              fontSize: 19,
              textAlign: TextAlign.start,
            ),
          ),
          subtitle: Wrap(
            spacing: 10,
            children: <Widget>[
              for (var item
                  in controller.userDetailBody.value.socialMedia?.params ?? [])
                Padding(
                    padding: EdgeInsets.zero,
                    child: SizedBox(
                      height: 32,
                      width: 32,
                      child: InkWell(
                          onTap: () {
                            UiHelper.inAppWebView(
                                Uri.parse(item.value.toString()));
                          },
                          child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: colorGray, width: 1)),
                              child: SvgPicture.asset(
                                UiHelper.getSocialIcon(
                                    item.text.toString().toLowerCase()),
                              ))),
                    )),
            ],
          ),
        ),
      ],
    );
  }

  openChatDialog(BuildContext context) async {
    var result = await Get.bottomSheet(
      CommonConnectChatDialog(
        receiverId: controller.userDetailBody.value.id ?? "",
      ),
      enableDrag: true,
      barrierColor: Colors.black.withOpacity(0.80),
      isDismissible: false,
      isScrollControlled: true,
    );
    if (result["status"] == true) {
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
              controller.commonChatMeetingController.getChatRequestStatus(
                  isShow: true,
                  receiverId: controller.userDetailBody.value.id ?? "");
            },
          ));
    } else {
      UiHelper.showFailureMsg(
          context, result["status"] ?? "Something went wrong");
    }
  }

  openChatDetailPage() async {
    var chatData = controller.commonChatMeetingController.chatStatusBody.value;
    Get.to(ChatDetailPage(
        userModel: UserModel(
            iam: chatData.iam == "receiver"
                ? chatData.user?.id
                : PrefUtils.getUserId(),
            chatRequestStatus: chatData.status,
            userId: chatData.user?.id,
            fullName: chatData.user?.name,
            shortName: chatData.user?.shortName,
            avtar: chatData.user?.avatar,
            roomId: chatData.id)));

    controller.commonChatMeetingController.getChatRequestStatus(
        isShow: false, receiverId: controller.userDetailBody.value.id ?? "");
  }
}
