import 'dart:io';
import 'dart:math';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/dashboard/deep_linking_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;
  PushNotificationService(this._fcm);

  Future<void> initialise() async {
    if (Platform.isIOS) {
      _fcm.requestPermission();
    } else {
      await Permission.notification.isDenied.then((value) {
        if (value) {
          Permission.notification.request();
        }
      });
    }
    //_fcm.subscribeToTopic(AppUrl.topicName);
    startListeningNotificationEvents();

    // When app is terminated
    _fcm.getInitialMessage().then((message) {
      print("@@ message terminated-: ${message?.data}");

      if (message != null) {
        handleMessage(
          data: message.data,
          page: message.data["page"] ?? "",
          title: message.notification?.title ?? "",
          notificationId: message.data["id"] ?? "",
          appStatus: "terminate",
        );
      }
    });
    // When app is open and in foreground
    FirebaseMessaging.onMessage.listen((message) {
      print(" @@ message foreground-: ${message.data}");
      if (message.notification != null && Platform.isAndroid) {
        createNotification(message, "foreground");
      }
    });

    // When app is running in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("@@ message background-: ${message.data}");

      if (message.notification != null) {
        handleMessage(
          data: message.data,
          page: message.data["page"] ?? "",
          title: message.notification?.title ?? "",
          notificationId: message.data["id"] ?? "",
          appStatus: "background",
        );
      }
    });
  }

  Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: PushNotificationService.onActionReceivedMethod,
    );
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.actionType == ActionType.Default ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      handleMessage(
        data: receivedAction.payload?["data"] ?? "",
        page: receivedAction.payload?["page"] ?? "",
        title: receivedAction.payload?["title"] ?? "",
        notificationId: receivedAction.payload?["id"] ?? "",
        appStatus: "background",
      );
      print(
          ' @@ Message sent via notification input: "${receivedAction.buttonKeyInput}"');
    }
  }

  // Only working for foreground
  Future<void> createNotification(RemoteMessage message, String key) async {
    AuthenticationManager manager = Get.find();
    manager.pageRouteName = message.data["page"] ?? "";
    manager.pageRouteTitle = message.notification?.title ?? "";
    manager.pageRouteId = message.data["id"] ?? "";

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Random().nextInt(2147483647),
        channelKey: "high_importance_channel",
        payload: {
          "page": message.data["page"] ?? "",
          "id": message.data["id"] ?? "",
          "title": message.notification?.title ?? ""
        },
        title: message.notification?.title.toString(),
        body: message.notification?.body.toString(),
        displayOnBackground: true,
        displayOnForeground: true,
        criticalAlert: true,
        notificationLayout: NotificationLayout.Default,
      ),
      actionButtons: [
        NotificationActionButton(
          key: message.data?["page"] ?? "",
          label: 'Open Notification',
          actionType: ActionType.Default,
        ),
      ],
    );
  }

  static Future<void> handleMessage({
    required dynamic data,
    required String page,
    required String notificationId,
    required String appStatus,
    required String title,
  }) async {
    if (appStatus == "background" && page.isNotEmpty) {
      AuthenticationManager manager = Get.find();
      if (manager.isLogin()) {
        if (Get.isRegistered<DeepLinkingController>()) {
          DeepLinkingController controller = Get.find();
          manager.pageRouteId = notificationId;
          manager.pageRouteName = page;
          manager.pageRouteTitle = title;
          controller.navigatePageAsPerNotification();
        }
      }
    } else if (appStatus == "terminate") {
      AuthenticationManager manager = Get.find();
      if (page.isNotEmpty) {
        if (notificationId.isNotEmpty) {
          manager.pageRouteId = notificationId;
        }
        manager.pageRouteName = page;
        manager.pageRouteTitle = title;
        manager.notificationNode = data;
      } else {
        manager.pageRouteName = "alert";
      }
    }
  }
}
