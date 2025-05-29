
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/chat/model/parent_room_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/custom_search_view.dart';
import '../../../widgets/loading.dart';
import '../../dashboard/showLoadingPage.dart';
import '../controller/roomController.dart';
import 'chat_list_body.dart';

class RoomTab1Widget extends GetView<RoomController> {
  int? tabIndex;
  RoomTab1Widget({Key? key, this.tabIndex}) : super(key: key);
  static const routeName = "/chat_list_Page";
  final textController = TextEditingController().obs;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<RoomController>(builder: (controller) {
        return Container(
          padding: EdgeInsets.all(12.adaptSize),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: CustomSearchView(
                  isShowFilter: false,
                  hintText: "search_here".tr,
                  controller: textController.value,
                  textStyle: TextStyle(
                    fontSize: 18.fSize,
                    fontWeight: FontWeight.normal,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 18.fSize,
                    fontWeight: FontWeight.normal,
                    color: colorGray
                  ),
                  press: () async {
                    controller.filterSearchResults("");
                  },
                  onSubmit: (result) async {
                    if (result.isNotEmpty) {
                      controller.filterSearchResults(result);
                    }
                  },
                  onClear: (result) {
                    _refreshIndicatorKey.currentState?.show();
                  },
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Expanded(child: messageListWidget()),
            ],
          ),
        );
      }),
    );
  }

  messageListChild(
      BuildContext context, ParentRoomModel parentRoomModel, int index) {
    return InkWell(
      onTap: () {
        controller.checkIsUserBlocked(parentRoomModel);
      },
      child: ChatListPageBody(parentRoomModel: parentRoomModel),
    );
  }

  Widget messageListWidget() {
    return Stack(
      children: [
        RefreshIndicator(
            backgroundColor: colorSecondary,
            key: _refreshIndicatorKey,
            child: ListView.separated(
              itemCount: controller.activeChatItem.length,
              itemBuilder: (context, index) {
                final parentRoomModel = controller.activeChatItem[index];
                return messageListChild(context, parentRoomModel, index);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 6,
                  color: borderColor,
                );
              },
            ),
            onRefresh: () async {
              controller.initRoomRef();
            }),
        _progressEmptyWidget()
      ],
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.loading.value
          ? const Loading()
          : controller.activeChatItem.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey,
      title: "choose_conversation".tr,message: "chat_no_text".tr,)
              : const SizedBox(),
    );
  }




}
