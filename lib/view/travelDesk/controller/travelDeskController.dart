
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/widgets/fullscreen_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/file_manager.dart';
import 'package:dreamcast/utils/pref_utils.dart';
import 'package:dreamcast/view/home/screen/pdfViewer.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class TravelDeskController extends GetxController {
  final tabIndex = 0.obs;
  var tabList = <String>[].obs;
  var loader = true.obs;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  var downloadProgress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    createTab();
    callApi(0, false);
    /// pdf download initialization
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(requestAlertPermission: true);

    const initSettings = InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin!.initialize(initSettings);
  }

  Future<void> createTab() async {
    tabList.clear();
    tabList.add("Flight Details");
    tabList.add("Cab Details");
    tabList.add("Hotel Details");
    tabList.add("Visa Details");
    tabList.add("Passport");
  }

  //common method for all tabs
  viewPdf({required String fileName, required String networkPath}) async {
    // Get the file path
    final directory = await FileManager.instance.getDocumentsDirectoryPath;
    final filePath = '$directory/$fileName.pdf';
    final pdfFile = File(filePath);

    if (PrefUtils.getDocumentPath(fileName) != networkPath &&
        networkPath.isNotEmpty) {
      final response = await http.get(Uri.parse(networkPath));
      if (response.statusCode == 200) {
        PrefUtils.saveDocumentPath(fileName, networkPath);
        FileManager.instance
            .saveFile("$fileName.pdf", response.bodyBytes)
            .then((filePath) async {
          Get.to(PdfViewPage(
              htmlPath: filePath, title: fileName, isLocalDataShow: true));
        });
      }
    } else {
      print("else ");
      final directory = await FileManager.instance.getDocumentsDirectoryPath;
      final filePath = '$directory/$fileName.pdf';
      if (await pdfFile.exists()) {
        Get.to(PdfViewPage(
          htmlPath: filePath,
          title: fileName,
          isLocalDataShow: true,
        ));
      } else {
        UiHelper.showFailureMsg(null, "Please check your internet connection.");
      }
    }
  }


  var showFileLoader = "".obs;
  Future<String?> pdfDownload({String? networkPath, String? fileName}) async {
    showFileLoader(networkPath);
    if (!networkPath!.startsWith("https://")) {
      print("Error: The URL must start with 'https://'");
      return null;
    }

    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String savePath = "${directory.path}/$fileName";

      dio.Dio dioClient = dio.Dio();

      dio.Response response = await dioClient.download(
        networkPath,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double progress = received / total;
            downloadProgress.value = progress;
            print("Downloading: ${(progress * 100).toStringAsFixed(0)}%");
          }
        },
      );
      if (response.statusCode == 200) {
        print("File downloaded to: $savePath");
        downloadProgress.value = 0.0;
        showFileLoader("");
        _showNotification({
          'isSuccess': true,
          'filePath': savePath,
          'error': null,
        });
        return savePath;
      } else {
        print("Error downloading file: ${response.statusCode}");
        downloadProgress.value = 0.0;
        showFileLoader("");
        return null;
      }
    } catch (e) {
      print("Download error: $e");
      downloadProgress.value = 0.0;
      showFileLoader("");
      return null;
    }
  }


  /// local notification
  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    const android = AndroidNotificationDetails('1', 'channel name',
        // 'channel description',
        priority: Priority.high,
        importance: Importance.max);

    const platform = NotificationDetails(android: android);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];
    // print("${platform.iOS!.subtitle}" + "platform information");

    await flutterLocalNotificationsPlugin!.show(
        0, // notification id
        isSuccess ? 'success'.tr : 'failure'.tr,
        isSuccess ? 'file_uploaded_success'.tr : 'file_upload_error'.tr,
        platform,
        payload: json);
    // print("Notification Shown ===================================");
    await _onSelectNotification(json);
  }

  ///when user tap on notification

  Future<void> _onSelectNotification(String json) async {
    print(json);
    final obj = jsonDecode(json);
    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      UiHelper.showSuccessMsg(null, "${obj['error']}");
    }
  }


  ///****** call Apis ********///
  Future<void> callApi(int index, bool isRefresh) async {
    tabIndex(index);
  }


}
