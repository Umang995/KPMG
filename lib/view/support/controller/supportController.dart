import 'dart:async';
import 'dart:convert';
import 'package:dreamcast/api_repository/app_url.dart';
import 'package:dreamcast/view/chat/model/create_room_model.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:dreamcast/view/home/model/config_detail_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../utils/pref_utils.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../home/controller/home_controller.dart';
import '../../representatives/model/chat_request_status_model.dart';
import '../../chat/model/message_model.dart';
import '../../chat/model/user_model.dart';

class SupportController extends GetxController {
  final DashboardController dashboardController = Get.find();
  final HomeController homeController = Get.find();

  final _scrollController = ScrollController();

  get scrollController => _scrollController;

  final AuthenticationManager _authManager = Get.find();
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
  var userModel = UserModel();
  var loadingLabel = "Chat Loading...".obs;
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 0), () {
      if (!authManager.isLogin()) {
        return;
      }
      getChatRequestStatus();
    });
  }

  Future<void> getChatRequestStatus() async {
    HelpDeskChat? helpDeskChat =
        homeController.configDetailBody.value.organizers?.helpDeskChat;
    var body = {"receiver_id": helpDeskChat?.id ?? ""};

    final model = ChatRequestStatusModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: body,
        url: AppUrl.getChatRequestStatus,
      ),
    ));
    loading(false);
    if (model.status! && model!.code == 200) {
      if (model.body?.id != null) {
        loadingLabel("");
        userModel = UserModel(
            userId: helpDeskChat?.id ?? "",
            fullName: helpDeskChat?.name ?? "",
            shortName: helpDeskChat?.shortName ?? "",
            avtar: helpDeskChat?.avatar ?? "",
            roomId: model.body?.id ?? "");
      } else {
        userModel = UserModel(
            userId: helpDeskChat?.id ?? "",
            fullName: helpDeskChat?.name ?? "",
            shortName: helpDeskChat?.shortName ?? "",
            avtar: helpDeskChat?.avatar ?? "",
            roomId: model.body?.id ?? "");
        loadingLabel("");
        //Need help? Chat with us for quick assistance.
      }
      if (userModel!.roomId != null && userModel!.roomId!.isNotEmpty) {
        setRoomId = userModel!.roomId ?? "";
        initMessageRef(receiverId: userModel.userId ?? "");
      } else {
        setRoomId = "";
      }
    }
  }

  void scrollToBottom() {
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
  }

  /*used for chat details screen*/
  initMessageRef({receiverId}) async {
    if (getRoomId.toString().isNotEmpty) {
      newChatDetailList.clear();
      _messagesRef = authManager.firebaseDatabase
          .ref(AppUrl.defaultFirebaseNode)
          .child(AppUrl.chatConversation)
          .child(getRoomId);
      _eventsSubscription = _messagesRef.onChildAdded.listen((snapshot) {
        onEventsSnapshot(snapshot);
      });
      clearReadCount(receiverId);
    }
  }

  void onEventsSnapshot(DatabaseEvent event) {
    if (event.snapshot.value != null) {
      final json = event.snapshot.value as Map<dynamic, dynamic>;
      final message = ChatModel.fromJson(json);
      newChatDetailList.add(message);
      scrollToBottom();
    } else {
      print("data is load");
    }
  }

  void scrollToBottom1() {
    if (newChatDetailList.isNotEmpty) {
      // _scrollController.position.maxScrollExtent;

      try {
        _scrollController.position.maxScrollExtent;
        Future.delayed(const Duration(seconds: 1), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 1),
            curve: Curves.fastOutSlowIn,
          );
        });
      } catch (exception) {
        print("exception:$exception");
      }
    }
  }

  /*insert new  question on firebase*/
  void sendMessage(ChatModel message, String receiverId) {
    messagesRef.push().set(message.toJson()).then((_) {
      manageReadCount(receiverId, message);
      //sendNotification(receiverId: receiverId, message: message.message);
      print(message.dateTime);
    }).catchError((onError) {
      print("onError-:$onError");
    });
  }

  /* update read count*/
  void manageReadCount(String receiverId, ChatModel message) async {
    return await authManager.firebaseDatabase
        .ref("${AppUrl.defaultFirebaseNode}/${AppUrl.chatUsers}/")
        .child(receiverId)
        .child(PrefUtils.getUserId() ?? "")
        .once()
        .then((result) async {
      if (result.snapshot.value != null) {
        final json = result.snapshot!.value! as Map<dynamic, dynamic>;
        int count = json['count'];
        var body = <String, dynamic>{};
        body["count"] = count + 1;
        body["datetime"] = json['datetime'];
        body["room"] = json['room'];
        body["text"] = message.message;
        await authManager.firebaseDatabase
            .ref(AppUrl.defaultFirebaseNode)
            .child(AppUrl.chatUsers)
            .child(receiverId)
            .child(PrefUtils.getUserId() ?? "")
            .update(body);
      } else {
        print("result is empty");
      }
    });
  }

  /* clear read count*/
  void clearReadCount(String receiverId) async {
    return await authManager.firebaseDatabase
        .ref(AppUrl.defaultFirebaseNode)
        .child(AppUrl.chatUsers)
        .child(PrefUtils.getUserId() ?? "")
        .child(receiverId)
        .update({"count": 0});
  }

  //send first message in case of room id is empty.

  Future<void> sendFirstMessage(dynamic requestBody, receiverId) async {
    loading(true);
    final model = CreateRoomModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: requestBody,
        url: AppUrl.createRoom,
      ),
    ));
    loading(false);
    if (model!.status! && model!.code == 200) {
      setRoomId = model.body?.room?.id ?? "";
      loadingLabel("");
      initMessageRef(receiverId: receiverId);
    }
    loading(false);
  }

  @override
  void onClose() {
    print("dispose onClose");
    try {
      messagesRef.onDisconnect();
      _eventsSubscription.cancel();
      Get.delete<SupportController>();
    } catch (exception) {
      print(exception.toString());
    }

    super.onClose();
  }
}
