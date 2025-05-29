import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'dart:io';

class FullImageView extends StatefulWidget {
  String? imgUrl;
  bool? showNotification;
  bool? showDownload;
  bool? isLocalUrl = false;
  FullImageView(
      {super.key,
      required this.imgUrl,
      this.showNotification,
      this.showDownload,
      this.isLocalUrl});

  @override
  State<FullImageView> createState() => _FullImageViewState();
}

class _FullImageViewState extends State<FullImageView> {
  var progressLoading = false.obs;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  //final _dio = Dio.Dio();

  @override
  void initState() {
    super.initState();

    /// pdf download initialization
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(requestAlertPermission: true);

    const initSettings = InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin!.initialize(initSettings);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            Center(child: circularImage()),
            GestureDetector(
              onTap: () => Get.back(),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: widget.showDownload != null
            ? FloatingActionButton.small(
                onPressed: () async {
                  saveNetworkImage(widget.imgUrl ?? "");
                  //_download;
                },
                child: Obx(() => progressLoading.value
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: white,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color:
                              colorPrimary, // Replace with your custom background color
                          shape: BoxShape
                              .circle, // Optional: shape of the container
                        ),
                        child: Icon(
                          Icons.download,
                          color: white,
                        ),
                      )))
            : null,
      ),
    );
  }

  ///the the image in gallery
  saveNetworkImage(String url) async {
    _requestPermission();
    downloadAndSaveImage(url);
  }

  ///download the image from url and save it in gallery.
  downloadAndSaveImage(String url) async {
    if (widget.isLocalUrl == true) {
      final imageBytes = await File(widget.imgUrl ?? "").readAsBytes();

      String name = url.split('/').last;
      String picturesPath = name;
      final result = await SaverGallery.saveImage(
          Uint8List.fromList(imageBytes),
          quality: 60,
          name: picturesPath,
          androidRelativePath: "picture_imc_ai_gallery".tr,
          androidExistNotSave: true);
      if (result.isSuccess) {
        UiHelper.showSuccessMsg(null, "image_saved_in_gallery".tr);
        var res = {"isSuccess": result.isSuccess, "filePath": picturesPath};
        if (widget.showNotification == true) {
          await _showNotification(res);
        }
      }
    } else {
      progressLoading(true);
      var response = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes));
      String name = url.split('/').last;
      String picturesPath = name;
      final result = await SaverGallery.saveImage(
          Uint8List.fromList(response.data),
          quality: 60,
          name: picturesPath,
          androidRelativePath: "picture_imc_ai_gallery".tr,
          androidExistNotSave: true);
      if (result != null && result.isSuccess) {
        UiHelper.showSuccessMsg(null, "image_saved_in_gallery".tr);
        var res = {"isSuccess": result.isSuccess, "filePath": picturesPath};
        if (widget.showNotification == true) {
          await _showNotification(res);
        }
      }
      progressLoading(false);
    }
  }

  Widget circularImage() {
    return SizedBox(
        height: 500,
        width: 500,
        child: InteractiveViewer(
          panEnabled: true, // Set it to false
          boundaryMargin: const EdgeInsets.all(100),
          minScale: 0.5,
          maxScale: 2,
          child: widget.isLocalUrl == true
              ? Image.file(File(widget.imgUrl ?? ""))
              : CachedNetworkImage(
                  maxHeightDiskCache: 900,
                  imageUrl: widget.imgUrl ?? "",
                  imageBuilder: (context, imageProvider) => Container(
                    height: context.height * 0.20,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.contain),
                    ),
                  ),
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
        ));
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
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'File has been downloaded successfully!'
            : 'There was an error while downloading the file.',
        platform,
        payload: json);
    // print("Notification Shown ===================================");
    await _onSelectNotification(json);
  }

  ///when user tap on notification
  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);
    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      UiHelper.showSuccessMsg(null, "${obj['error']}");
    }
  }

  Future<bool> _requestPermission() async {
    bool statuses;
    if (Platform.isAndroid) {
      statuses = await Permission.storage.request().isGranted;
    } else {
      statuses = await Permission.photosAddOnly.request().isGranted;
    }
    return true;
  }
}
