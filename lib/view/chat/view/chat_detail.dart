import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/chat/model/message_model.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/image_constant.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/customImageWidget.dart';
import '../../../widgets/textview/customTextView.dart';
import '../../../widgets/dialog/custom_animated_dialog_widget.dart';
import '../../../widgets/dialog/custom_dialog_widget.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/button/common_material_button.dart';
import '../../../widgets/toolbarTitle.dart';
import '../controller/chatController.dart';
import '../controller/roomController.dart';
import '../model/user_model.dart';
import 'chat_bubble.dart';

class ChatDetailPage extends StatefulWidget {
  UserModel userModel;
  ChatDetailPage({Key? key, required this.userModel}) : super(key: key);
  static const routeName = "/chat_detail_page";
  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final controller = Get.put(ChatController());
  final _messageController = TextEditingController();
  var focusNode = FocusNode();
  final DashboardController _dashboardController = Get.find();
  final roomController = Get.put(RoomController());

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    FirebaseAuth.instance.currentUser?.getIdToken(true);
    controller.notificationUserModel = widget.userModel;
    /*focusNode.addListener(() {
      if (focusNode.hasFocus) {
        controller.scrollToBottom();
      }
    });*/
    if (widget.userModel.roomId != null &&
        widget.userModel!.roomId!.isNotEmpty) {
      controller.setRoomId = widget.userModel!.roomId ?? "";
      controller.initMessageRef(receiverId: widget.userModel.userId ?? "");
    } else {
      controller.setRoomId = "";
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
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
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 40.h,
              child: CustomImageWidget(
                  size: 40,
                  fontSize: 18,
                  imageUrl: widget.userModel.avtar ?? "",
                  shortName: widget.userModel.shortName ?? ""),
            ),
            const SizedBox(
              width: 9,
            ),
            Expanded(
                child: ToolbarTitle(
                  title: widget.userModel.fullName ?? "",
                  color: Colors.black,
                ))
          ],
        ),
      ),
      body: Container(
          color: Colors.transparent,
          height: context.height,
          width: context.width,
          padding: const EdgeInsets.all(0),
          child: GetX<ChatController>(
            builder: (controller) {
              return Stack(
                children: <Widget>[
                  Column(
                    children: [
                      const SizedBox(
                        height: 0,
                      ),
                      controller.getRoomId.isNotEmpty
                          ? Expanded(child: buildMessageView())
                          : const SizedBox(),
                      SizedBox(
                        height: 100.v,
                      )
                    ],
                  ),
                  widget.userModel.chatRequestStatus == -1
                      ? requestRejectByReceived()
                      : Align(
                    alignment: Alignment.bottomCenter,
                    child: widget.userModel.chatRequestStatus == 1
                        ? Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(10)),
                          border: Border.all(
                              width: 1, color: colorSecondary)),
                      padding: const EdgeInsets.all(3),
                      // height: 56,
                      width: double.infinity,
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: focusNode,
                              controller: _messageController,
                              keyboardType: TextInputType.multiline,
                              textInputAction:
                              TextInputAction.newline,
                              maxLines: 3,
                              minLines: 1,
                              style: TextStyle(
                                  fontSize: 16.fSize,
                                  color: colorSecondary,
                                  fontWeight: FontWeight.normal),
                              decoration: InputDecoration(
                                  fillColor: Colors.transparent,
                                  hintStyle: TextStyle(
                                      fontSize: 16.fSize,
                                      color: colorGray,
                                      fontWeight:
                                      FontWeight.normal),
                                  labelStyle: TextStyle(
                                      fontSize: 16.fSize,
                                      color: colorGray,
                                      fontWeight:
                                      FontWeight.normal),
                                  hintText: "type_your_message".tr,
                                  border: InputBorder.none),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          SizedBox(
                            height: 46,
                            width: 46,
                            child: FloatingActionButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (_messageController.text
                                    .toString()
                                    .trim()
                                    .isNotEmpty) {
                                  _sendMessage();
                                } else {
                                  return;
                                }
                              },
                              backgroundColor: colorPrimary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                              child: ImageIcon(
                                AssetImage(ImageConstant.send_icon),
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                        : pendingRequestSender(),
                  ),
                  controller.loading.value ? const Loading() : const SizedBox()
                ],
              );
            },
          )),
    );
  }

  buildMessageView() {
    return controller.newChatDetailList.isNotEmpty
        ? ListView.builder(
        controller: controller.scrollController,
        //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: controller.newChatDetailList.length,
        itemBuilder: (BuildContext context, int index) {
          ChatModel chatModel = controller.newChatDetailList[index];
          return ChatBubble(
            text: chatModel.message ?? "",
            date: UiHelper.displayCommonDateTime(
                date: chatModel.dateTime.toString(),
                timezone: PrefUtils.getTimezone()),
            isSender:
            chatModel.userId == PrefUtils.getUserId() ? true : false,
            userName: chatModel.userId == PrefUtils.getUserId()
                ? PrefUtils.getName() ?? ""
                : widget.userModel.fullName ?? "",
            shortName: chatModel.userId == PrefUtils.getUserId()
                ? PrefUtils.getUsername() ?? ""
                : widget.userModel.shortName ?? "",
            avtar: chatModel.userId == PrefUtils.getUserId()
                ? PrefUtils.getImage() ?? ""
                : widget.userModel.avtar ?? "",
          );
        })
        : const SizedBox();
  }

  Future<void> _sendMessage() async {
    if (controller!.getRoomId.isNotEmpty) {
      final message = ChatModel(PrefUtils.getUserId(),
          _messageController.text.trim(), DateTime.now().toUtc());
      controller.sendMessage(message, widget.userModel.userId ?? "");
      _messageController.clear();
    } else {
      var body = {
        "user_id": widget.userModel.userId,
        "message": _messageController.text.trim()
      };
      await controller.sendFirstMessage(body, widget.userModel.userId);
      _messageController.clear();
      setState(() {});
    }
  }

  Widget pendingRequestSender() {
    return widget.userModel.iam == PrefUtils.getUserId()
        ? Container(
      width: context.width,
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: colorLightGray,
          borderRadius: const BorderRadius.all(Radius.circular(6))),
      child: CustomTextView(
        text: "chat_request_sent".tr,
        fontWeight: FontWeight.normal,
        color: colorPrimary,
        fontSize: 14,
      ),
    )
        : pendingRequestReceiver();
  }

  Widget requestRejectByReceived() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: colorLightGray,
                borderRadius: BorderRadius.all(Radius.circular(6))),
            child: const Row(
              children: [
                Icon(
                  Icons.warning,
                  color: accentColor,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: CustomTextView(
                    text: "This user is currently not available for chat!",
                    fontWeight: FontWeight.normal,
                    color: accentColor,
                    fontSize: 14,
                  ),
                ),
              ],
            )));
  }

  Widget pendingRequestReceiver() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: colorLightGray,
          borderRadius: const BorderRadius.all(Radius.circular(6))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextView(
            text: "chat_request_received".tr,
            fontSize: 14,
          ),
          Row(
            children: [
              Expanded(
                  child: CommonMaterialButton(
                    color: colorPrimary,
                    textColor: Theme.of(context).highlightColor,
                    height: 40,
                    radius: 23,
                    textSize: 16.adaptSize,
                    text: "accept".tr,
                    svgIcon: ImageConstant.acceptSvg,
                    iconColor: Theme.of(context).highlightColor,
                    onPressed: () async {
                      var body = {
                        "id": widget.userModel.roomId,
                        "text": "",
                        "user_id": widget.userModel.userId,
                        "status": 1
                      };
                      showActionChatDialog(
                          context: context,
                          title: "accept_request".tr,
                          confirmButtonText: "accept".tr,
                          logo: ImageConstant.icAcceptRequest,
                          content:
                          "Are you sure you want to ${"accept".tr} this request?",
                          isAccept: true,
                          body: body);
                    },
                  )),
              const SizedBox(
                width: 6,
              ),
              Expanded(
                  child: CommonMaterialButton(
                    color: accentColor,
                    textColor: Theme.of(context).highlightColor,
                    height: 40,
                    radius: 23,
                    textSize: 16.adaptSize,
                    text: "Reject".tr,
                    iconColor: Theme.of(context).highlightColor,
                    svgIcon: ImageConstant.reject,
                    onPressed: () async {
                      var body = {
                        "id": widget.userModel.roomId,
                        "text": "",
                        "user_id": widget.userModel.userId,
                        "status": -1
                      };
                      showActionChatDialog(
                          context: context,
                          title: "reject_request".tr,
                          confirmButtonText: "reject".tr,
                          logo: ImageConstant.icCancelRequest,
                          content:
                          "Are you sure you want to ${"Reject".tr} this request?",
                          isAccept: false,
                          body: body);
                    },
                  ))
            ],
          )
        ],
      ),
    );
  }

  void showActionChatDialog(
      {required context,
        required content,
        required body,
        required title,
        required logo,
        required confirmButtonText,
        required isAccept}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogWidget(
          logo: logo,
          title: title,
          description: content,
          buttonAction: "Yes, $confirmButtonText",
          buttonCancel: "go_back".tr,
          onCancelTap: () {},
          onActionTap: () async {
            var result = await controller.takeChatRequestAction(body: body);
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
                      if (isAccept) {
                        widget.userModel.chatRequestStatus = 1;
                        controller.dashboardController.chatTabIndex(0);
                        controller.update();
                      } else {
                        widget.userModel.chatRequestStatus = -1;
                        controller.dashboardController.chatTabIndex(0);
                        controller.update();
                        Get.back();
                      }
                      setState(() {});
                    },
                  ));
            } else {
              UiHelper.showFailureMsg(
                  context, result["message"] ?? "Something went wrong");
            }
          },
        );
      },
    );
  }

  _scrollListener() {
    //FocusScope.of(context).requestFocus(FocusNode());
  }
}

