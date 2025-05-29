
import 'package:dreamcast/view/chat/controller/roomController.dart';
import 'package:dreamcast/view/chat/model/parent_room_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/loading.dart';
import '../../dashboard/showLoadingPage.dart';
import 'chat_list_body.dart';

class RoomTab2Widget extends GetView<RoomController> {
  int? tabIndex;
  RoomTab2Widget({Key? key, this.tabIndex}) : super(key: key);
  static const routeName = "/chat_list_Page";
  final textController = TextEditingController().obs;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<RoomController>(builder: (controller) {
        return Container(
          padding: const EdgeInsets.all(12.0),
          child: _getMessageList(),
        );
      }),
    );
  }

  _teamViewCard(
      BuildContext context, ParentRoomModel parentRoomModel, int index) {
    String message = parentRoomModel.roomModel?.text ?? "";
    return InkWell(
      onTap: () {
        controller.checkIsUserBlocked(parentRoomModel);
      },
      child: ChatListPageBody(parentRoomModel: parentRoomModel),
    );
  }

  Widget _getMessageList() {
    return Stack(
      children: [
        RefreshIndicator(
            backgroundColor: colorSecondary,
            key: _refreshIndicatorKey,
            child: ListView.separated(
              itemCount: controller.receivedChatItem.length,
              itemBuilder: (context, index) {
                final parentRoomModel = controller.receivedChatItem[index];
                return _teamViewCard(context, parentRoomModel, index);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 6,
                  color: borderColor,
                );
              },
            ),
            onRefresh: () async {
              await controller.initRoomRef();
            },
        ),
        _progressEmptyWidget()
      ],
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.loading.value
          ? const Loading()
          : controller.receivedChatItem.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey,
        title: "choose_conversation".tr,message: "chat_no_text".tr,)
              : const SizedBox(),
    );
  }

}
