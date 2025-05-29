import 'package:dreamcast/utils/pref_utils.dart';
import 'package:dreamcast/view/chat/controller/roomController.dart';
import 'package:dreamcast/view/chat/model/parent_room_model.dart';
import 'package:dreamcast/widgets/customImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/ui_helper.dart';
import '../../../widgets/textview/customTextView.dart';
import '../../../widgets/fullscreen_image.dart';

class ChatListPageBody extends GetView<RoomController> {
  ParentRoomModel parentRoomModel;
  ChatListPageBody({Key? key, required this.parentRoomModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String message = parentRoomModel.roomModel?.text ?? "";
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: CustomImageWidget(
            size: 70,
            shortName: parentRoomModel.chatProfileModel?.shortName??"",
            imageUrl: parentRoomModel.chatProfileModel?.avtar??"",
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextView(
                text: parentRoomModel.chatProfileModel?.name ?? "",
                textAlign: TextAlign.start,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
              parentRoomModel.roomModel!.unread! > 0
                  ? buildChatBudge(parentRoomModel.roomModel!.unread!)
                  : const SizedBox(
                      height: 30,
                    ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 5,
                child: CustomTextView(
                  text: message??"",
                  textAlign: TextAlign.start,
                  fontSize: 14,
                  maxLines: 2,
                  color: colorGray,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Expanded(
                flex: 5,
                child: CustomTextView(
                  text: UiHelper.displayCommonDateTime(
                      date: parentRoomModel.roomModel!.dateTime ?? "",
                      timezone: PrefUtils.getTimezone()),
                  fontSize: 12,
                  color: colorGray,
                  textAlign: TextAlign.end,
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
        ),
        /*index == controller.tempChatList.length - 1
            ? const Divider(
          color: grayColorLight,
        )
            : const SizedBox()*/
      ],
    );
  }

  buildChatBudge(count) {
    return Container(
      height: 20,
      width: 20,
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: borderColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          count.toString(),
          style: const TextStyle(
              color: Colors.black, fontSize: 10, fontFamily: "SourceSansPro"),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
