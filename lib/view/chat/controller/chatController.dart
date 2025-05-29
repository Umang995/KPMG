import 'dart:async';
import 'dart:convert';
import 'package:dreamcast/api_repository/app_url.dart';
import 'package:dreamcast/view/chat/controller/roomController.dart';
import 'package:dreamcast/view/chat/model/create_room_model.dart';
import 'package:dreamcast/view/chat/model/user_model.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../model/common_model.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/dialog/custom_animated_dialog_widget.dart';
import '../../../widgets/dialog/custom_dialog_widget.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../representatives/model/chat_accept_model.dart';
import '../model/message_model.dart';

class ChatController extends GetxController {
  late final AuthenticationManager _authManager;
  final DashboardController dashboardController = Get.find();
  final _scrollController = ScrollController();

  get scrollController => _scrollController;

  AuthenticationManager get authManager => _authManager;

  late DatabaseReference _messagesRef;

  DatabaseReference get messagesRef => _messagesRef;

  final String title = 'Home Title';
  var loading = false.obs;
  String _mRoomId = "";

  String get getRoomId => _mRoomId;

  set setRoomId(String value) {
    _mRoomId = value;
  }

  var newChatDetailList = <ChatModel>[].obs;
  late StreamSubscription<DatabaseEvent> _eventsSubscription;
  var notificationUserModel = UserModel();

  @override
  void onInit() {
    super.onInit();
    _authManager = Get.find();
  }

  @override
  void onReady() {
    super.onReady();
    updateOnlineStatusSelf(PrefUtils.getUserId() ?? "", true);
  }

  /*used for chat details screen*/
  initMessageRef({receiverId}) async {
    if (getRoomId.toString().isNotEmpty) {
      newChatDetailList.clear();
      _messagesRef = authManager.firebaseDatabase.ref(
          "${AppUrl.defaultFirebaseNode}/${AppUrl.chatConversation}/$getRoomId");
      _eventsSubscription = _messagesRef.onChildAdded.listen((data) {
        onEventsSnapshot(data);
      });
      clearReadCount(receiverId);
    }
  }

  void onEventsSnapshot(DatabaseEvent data) {
    if (data.snapshot.value != null) {
      final json = data.snapshot.value as Map<dynamic, dynamic>;
      final message = ChatModel.fromJson(json);
      newChatDetailList.add(message);
      scrollToBottom();
    }
  }

  void scrollToBottom() {
    try {
      if (newChatDetailList.isNotEmpty) {
        // _scrollController.position.maxScrollExtent;
        Future.delayed(const Duration(seconds: 1), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 1),
            curve: Curves.fastOutSlowIn,
          );
        });
      }
    } catch (e) {
      print("error");
    }
  }

  /*insert new message on firebase*/
  void sendMessage(ChatModel message, String receiverId) {
    messagesRef.push().set(message.toJson()).then((_) async {
      manageReadCount(receiverId, message);
      manageReadCountReceiverSide(receiverId, message);

      DataSnapshot snapshotvalue = await getReceiverStatus(receiverId);
      if (snapshotvalue.value == false) {
        sendNotification(receiverId: receiverId, message: message.message);
      }
    }).catchError((onError) {
      print("onError-:$onError");
    });
  }

  /* update read count sender side*/
  void manageReadCount(String receiverId, ChatModel message) async {
    return await authManager.firebaseDatabase
        .ref("${AppUrl.defaultFirebaseNode}/${AppUrl.chatUsers}/")
        .child(receiverId)
        .child(PrefUtils.getUserId() ?? "")
        .once()
        .then((result) async {
      if (result.snapshot.value != null) {
        final json = result.snapshot.value! as Map<dynamic, dynamic>;
        // print(json);
        int count = json['count'];
        var body = <String, dynamic>{};
        body["count"] = count + 1;
        body["datetime"] = message.dateTime.toString();
        body["room_id"] = json['room_id'];
        body["text"] = message.message;
        await authManager.firebaseDatabase
            .ref("${AppUrl.defaultFirebaseNode}/${AppUrl.chatUsers}/")
            .child(receiverId)
            .child(PrefUtils.getUserId() ?? "")
            .update(body);
      } else {
        print("result is empty");
      }
    });
  }

  /* update read count receiver side*/
  void manageReadCountReceiverSide(String receiverId, ChatModel message) async {
    return await authManager.firebaseDatabase
        .ref("${AppUrl.defaultFirebaseNode}/${AppUrl.chatUsers}/")
        .child(PrefUtils.getUserId() ?? "")
        .child(receiverId)
        .once()
        .then((result) async {
      if (result.snapshot.value != null) {
        final json = result.snapshot.value! as Map<dynamic, dynamic>;
        int count = json['count'];
        var body = <String, dynamic>{};
        body["count"] = 0;
        body["datetime"] = message.dateTime.toString();
        body["id"] = json['id'];
        body["text"] = message.message;
        await authManager.firebaseDatabase
            .ref("${AppUrl.defaultFirebaseNode}/${AppUrl.chatUsers}/")
            .child(PrefUtils.getUserId() ?? "")
            .child(receiverId)
            .update(body);
      } else {
        print("result is empty");
      }
    });
  }

  /* clear read count*/
  void clearReadCount(String receiverId) async {
    return await authManager.firebaseDatabase
        .ref("${AppUrl.defaultFirebaseNode}/${AppUrl.chatUsers}/")
        .child(PrefUtils.getUserId() ?? "")
        .child(receiverId)
        .update({"count": 0});
  }

  //send first message in case of room id is empty.
  Future<bool> sendFirstMessage(dynamic requestBody, receiverId) async {
    bool result = false;
    loading(true);
    final model = CreateRoomModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: requestBody,
        url: AppUrl.createRoom,
      ),
    ));
    if (model.status! && model.code == 200) {
      setRoomId = model.body?.room?.id ?? "";
      initMessageRef(receiverId: receiverId);
      result = true;
    } else {
      result = false;
    }
    loading(false);
    return result;
  }

  //send the notification when user send the message.
  Future<void> sendNotification({receiverId, message}) async {
    var requestBody = {
      "data": {
        "room_id": getRoomId ?? "",
        "page": "new_message",
        "user_id": notificationUserModel.userId,
        "avtar": notificationUserModel.avtar,
        "full_name": notificationUserModel.fullName,
        "short_name": notificationUserModel.shortName,
        "iam": notificationUserModel.iam,
        "chat_req_status": notificationUserModel.chatRequestStatus.toString()
      },
      "body": message ?? "",
      "title": "New message",
      "receiver_id": receiverId
    };

    await apiService.dynamicPostRequest(
      body: requestBody,
      url: AppUrl.sendChatNotification,
    );
  }

  Future<Map> takeChatRequestAction({required dynamic body}) async {
    var result = {};
    loading(true);
    final model = ChatRequestAcceptModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: body,
        url: AppUrl.takeChatRequestAction,
      ),
    ));
    loading(false);
    if (model.status! && model.code == 200) {
      if (Get.isRegistered<RoomController>()) {
        RoomController roomController = Get.find();
        roomController.initRoomRef();
      } else {
        RoomController roomController = Get.put(RoomController());
        roomController.initRoomRef();
      }
      result = {"message": model.body?.message ?? "", "status": true};
    } else {
      result = {"message": model.message ?? "", "status": false};
    }
    return result;
  }

  /*Future<Map> rejectChatRequest({required dynamic body}) async {
    loading(true);
    var result = {};
    ChatRequestAcceptModel model = await apiService.takeChatRequestAction(body);
    loading(false);
    if (model.status! && model.code == 200) {
      result = {"message": model.body!.message ?? "", "status": true};
      roomController.initRoomRef();
    } else {
      result = {"message": "", "status": true};
    }
    return result;
  }*/

  //update online status of user
  Future<void> updateOnlineStatusSelf(String userId, bool isOnline) async {
    authManager.firebaseDatabase
        .ref(AppUrl.defaultFirebaseNode)
        .child("online")
        .child(userId)
        .update({"status": isOnline});
  }

  Future<DataSnapshot> getReceiverStatus(String receiverId) async {
    final snapshot = await authManager.firebaseDatabase
        .ref(AppUrl.defaultFirebaseNode)
        .child("online")
        .child(receiverId)
        .child("status")
        .get();
    return snapshot;
  }

  @override
  void onClose() {
    updateOnlineStatusSelf(PrefUtils.getUserId() ?? "", false);
    _messagesRef.onDisconnect();
    _eventsSubscription.cancel();
    Get.delete<ChatController>();
    super.onClose();
  }
}
