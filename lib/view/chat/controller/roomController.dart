import 'dart:async';
import 'package:dreamcast/api_repository/app_url.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/view/breifcase/controller/common_document_controller.dart';
import 'package:dreamcast/view/chat/model/parent_room_model.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/dialog/custom_animated_dialog_widget.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../model/profile_model.dart';
import '../model/room_model.dart';
import '../model/user_model.dart';
import '../view/chat_detail.dart';

class RoomController extends GetxController {
  final DashboardController dashboardController = Get.find();
  final AuthenticationManager _authManager = Get.find();
  final CommonDocumentController documentController = Get.find();

  AuthenticationManager get authManager => _authManager;

  final String title = 'Home Title';
  var loading = false.obs;
  String mRoomId = "";
  var tabList = ["Active Chats", "Request Received", "Request Sent"];

  var chatList = <ParentRoomModel>[].obs;
  var filterChatList = [].obs;

  late StreamSubscription<DatabaseEvent> _onChildChangeListener;
  late StreamSubscription<DatabaseEvent> _onChildAddedListener;
  var isFromNotification = false;
  var activeChatItemCount = 0.obs;
  var requestedChatItemCount = 0.obs;
  var sentChatItemCount = 0.obs;

  var activeChatItem = [].obs;
  var receivedChatItem = [].obs;
  var sendChatItem = [].obs;

  @override
  void onInit() {
    super.onInit();
    initRoomRef();
    if (Get.arguments != null && Get.arguments["chat_data"] != null) {
      //open the chat detail page after click on notification.
      try {
        var data = Get.arguments["chat_data"];
        Future.delayed(const Duration(milliseconds: 10), () {
          openChatPageFromAlert(UserModel(
              iam: data["iam"],
              chatRequestStatus: int.parse(data["chat_req_status"] ?? "0"),
              userId: data["user_id"],
              fullName: data["full_name"],
              shortName: data["short_name"],
              avtar: data["avtar"],
              roomId: data["room_id"]));
        });
      } catch (exception) {
        debugPrint(exception.toString());
      }
    }
  }

  /*no room id need here*/
  initRoomRef() async {
    chatList.clear();
    filterChatList.clear();

    final initialDataSnapshot = await authManager.firebaseDatabase
        .ref(AppUrl.defaultFirebaseNode)
        .child(AppUrl.chatUsers)
        .child(PrefUtils.getUserId() ?? "")
        .once();

    int totalChildren = initialDataSnapshot.snapshot.children.length;
    int processedChildren = 0;
    loading(true);
    //used for get all room details here.
    _onChildAddedListener = authManager.firebaseDatabase
        .ref(AppUrl.defaultFirebaseNode)
        .child(AppUrl.chatUsers)
        .child(PrefUtils.getUserId() ?? "")
        .orderByChild('datetime')
        .onChildAdded
        .listen((snapshot) async {
      final profileModel = await getUserData(snapshot.snapshot.key ?? "");
      await onChildAddedListenerSnapshot(snapshot, profileModel);
      processedChildren++;
      // Check if all initial children are processed
      if (processedChildren == totalChildren) {
        updateTheChatList();
      }
    });

    /*used for on child change*/
    _onChildChangeListener = authManager.firebaseDatabase
        .ref(AppUrl.defaultFirebaseNode)
        .child(AppUrl.chatUsers)
        .child(PrefUtils.getUserId() ?? "")
        .onChildChanged
        .listen((snapshot) {
      print("onChildChanged");
      onChildChangeEventsSnapshot(snapshot);
    });
    Future.delayed(const Duration(seconds: 4), () {
      loading(false);
    });
  }

  Future<ChatProfileModel> getUserData(String userId) async {
    print("userId=${userId}");
    final snapshot = await authManager.firebaseDatabase
        .ref(AppUrl.defaultFirebaseNode)
        .child("users")
        .child(userId)
        .get();
    if (snapshot.value != null) {
      final json = snapshot.value! as Map<dynamic, dynamic>;
      print(json);
      return ChatProfileModel.fromJson(json);
    } else {
      return ChatProfileModel("", "", "", "", "", "");
    }
  }

  Future<void> onChildAddedListenerSnapshot(
      DatabaseEvent event, ChatProfileModel? profileModel) async {
    if (event.snapshot.value != null) {
      final json = event.snapshot.value as Map<dynamic, dynamic>;
      final message = RoomModel.fromJson(json);
      print(json);
      var parentRoomModel = ParentRoomModel(
          receiverId: event.snapshot.key,
          roomModel: message,
          chatProfileModel: profileModel);
      chatList.add(parentRoomModel);
      filterChatList.add(parentRoomModel);
    } else {
      loading(false);
    }
  }

  void onChildChangeEventsSnapshot(DatabaseEvent event) {
    if (event.snapshot.value != null) {
      final jsonData = event.snapshot.value as Map<dynamic, dynamic>;
      for (int i = 0; i < chatList.length; i++) {
        ParentRoomModel temp = chatList[i];
        if (temp.receiverId == event.snapshot.key) {
          final roomModel = RoomModel.fromJson(jsonData);
          filterChatList[i].roomModel = roomModel;
          chatList[i].roomModel = roomModel;
        }
      }
      chatList.refresh();
      filterChatList.refresh();
      updateTheChatList();
      update();
    }
  }

  filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<ParentRoomModel> dummyListData = [];
      for (var item in chatList) {
        if ((item.chatProfileModel?.name?.toLowerCase())!
            .contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      }
      activeChatItem.clear();
      activeChatItem.addAll(dummyListData);
      print("activeChatItem.length");
      return;
    } else {
      activeChatItem.clear();
      activeChatItem.addAll(chatList);
    }
  }

  ///
  updateTheChatList() {
    loading(false);
    getActiveChatList();
    getReceivedChatList();
    getSentChatList();
  }

  getActiveChatList() {
    List outputList = chatList
        .where((parentRoomModel) => parentRoomModel.roomModel?.status == 1)
        .toList();
    outputList.sort((a, b) {
      var date1 = b.roomModel?.dateTime.toString();
      var date2 = a.roomModel?.dateTime.toString();
      return date1!.compareTo(date2!);
    });
    activeChatItemCount(outputList.length);
    activeChatItem.clear();
    activeChatItem.addAll(outputList);
    refresh();
  }

  getReceivedChatList() {
    List outputList = chatList
        .where((parentRoomModel) =>
            parentRoomModel.roomModel?.status == 0 &&
            parentRoomModel.roomModel?.iam != PrefUtils.getUserId())
        .toList();

    outputList.sort((a, b) {
      var date1 = b.roomModel?.dateTime.toString();
      var date2 = a.roomModel?.dateTime.toString();
      return date1!.compareTo(date2!);
    });

    requestedChatItemCount(outputList.length);
    receivedChatItem.clear();
    receivedChatItem.addAll(outputList);
    refresh();
  }

  getSentChatList() {
    List outputList = chatList
        .where((parentRoomModel) =>
            parentRoomModel.roomModel?.status == 0 &&
            parentRoomModel.roomModel?.iam == PrefUtils.getUserId())
        .toList();

    outputList.sort((a, b) {
      var date1 = b.roomModel?.dateTime.toString();
      var date2 = a.roomModel?.dateTime.toString();
      return date1!.compareTo(date2!);
    });

    sentChatItemCount(outputList.length);
    sendChatItem.clear();
    sendChatItem.addAll(outputList);
    refresh();
  }

  checkIsUserBlocked(ParentRoomModel parentRoomModel) async {
    loading(true);
    var isBlocked = await documentController
        .getBlockListByIds(items: [parentRoomModel.receiverId]);
    loading(false);
    if (isBlocked) {
      await Get.dialog(
          barrierDismissible: false,
          CustomAnimatedDialogWidget(
            title: "",
            logo: ImageConstant.block,
            description: "Chat is not available for this user",
            buttonAction: "okay".tr,
            buttonCancel: "cancel".tr,
            isHideCancelBtn: true,
            onCancelTap: () {},
            onActionTap: () async {
              Get.back();
            },
          ));
    } else {
      openChatDetailPage(parentRoomModel);
    }
  }

  openChatDetailPage(ParentRoomModel parentRoomModel) {
    Get.to(() => ChatDetailPage(
        userModel: UserModel(
            chatRequestStatus: parentRoomModel.roomModel?.status,
            iam: parentRoomModel.roomModel?.iam,
            userId: parentRoomModel.receiverId,
            fullName: parentRoomModel.chatProfileModel?.name ?? "",
            shortName: parentRoomModel.chatProfileModel?.shortName ?? "",
            avtar: parentRoomModel.chatProfileModel?.avtar ?? "",
            roomId: parentRoomModel.roomModel?.roomId)));
  }

  openChatPageFromAlert(UserModel userModel) {
    Get.to(() => ChatDetailPage(userModel: userModel));
  }

  @override
  void onClose() {
    _onChildChangeListener.cancel();
    _onChildAddedListener.cancel();
    super.onClose();
  }
}
