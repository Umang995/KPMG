import 'dart:convert';
import 'dart:io';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dio/dio.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../menu/controller/menuController.dart';
import 'package:path/path.dart' as path;

class PdfViewPage extends StatefulWidget {
  dynamic htmlPath;
  dynamic title;
  final bool isLocalDataShow;
  PdfViewPage(
      {Key? key,
      required this.htmlPath,
      required this.title,
      this.isLocalDataShow = false})
      : super(key: key);

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  var loadingDownload = false.obs;
  var loadingDocument = true.obs;

  @override
  HubController controller = Get.find();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final Dio _dio = Dio();
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

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
    return Scaffold(
      appBar: CustomAppBar(
        height: 72.v,
        leadingWidth: 45.h,
        leading: AppbarLeadingImage(
          imagePath: ImageConstant.imgArrowLeft,
          margin: EdgeInsets.only(left: 7.h, top: 3),
          onTap: () => Get.back(),
        ),
        title: ToolbarTitle(
          title: widget.title,
        ),
      ),
      backgroundColor: white,
      body: Stack(
        children: [
          Container(
            color: white,
            child: widget.isLocalDataShow == true
                ? SfPdfViewer.file(
                    File(widget.htmlPath),
                    key: _pdfViewerKey,
                    pageLayoutMode: PdfPageLayoutMode
                        .continuous, // Loads one page at a time
                    onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                      Future.delayed(const Duration(seconds: 3), () async {
                        loadingDocument.value = false;
                      });
                    },

                    onDocumentLoadFailed:
                        (PdfDocumentLoadFailedDetails details) {
                      loadingDocument.value = false;
                      debugPrint("Failed to load PDF: ${details.error}");
                    },
                  )
                : SfPdfViewer.network(
                    widget.htmlPath,
                    pageLayoutMode: PdfPageLayoutMode
                        .continuous, // Loads one page at a time
                    onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                      Future.delayed(const Duration(seconds: 3), () async {
                        loadingDocument.value = false;
                      });
                    },
                    onDocumentLoadFailed:
                        (PdfDocumentLoadFailedDetails details) {
                      loadingDocument.value = false;
                      debugPrint("Failed to load PDF: ${details.error}");
                    },

                    key: _pdfViewerKey,
                  ),
          ),
        ],
      ),
      floatingActionButton: Obx(() => loadingDocument.value
          ? const SizedBox()
          : FloatingActionButton.small(
              backgroundColor: colorPrimary,
              onPressed: () async {
                bool status = await UiHelper.isInternetWorking(context);
                if (status) {
                  Platform.isAndroid ? _download() : _downloadForIos();
                }
              },
              child: loadingDownload.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      Icons.download,
                      color: white,
                    ))),
    );
  }

  Future<void> _download() async {
    loadingDownload(true);
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    String? filePath = await _getDownloadDirectory();
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory();
    final savePath = path.join(directory?.path ?? "", widget.title + ".pdf");
    await _startDownload(savePath, widget.htmlPath);
  }

  Future<void> _downloadForIos() async {
    loadingDownload(true);
    final dir = await _getDownloadDirectoryIos();
    final isPermissionStatusGranted =
        await _requestPermission(Permission.storage);

    final hasExisted = dir?.existsSync() ?? false;
    if (!hasExisted) {
      await dir?.create();
    }
    if (isPermissionStatusGranted && dir != null) {
      final savePath = path.join(dir.path, widget.title + ".pdf");
      await _startDownload(savePath, widget.htmlPath);
    } else {
      print("please check permission");
    }
  }

  Future<void> _startDownload(String savePath, String file) async {
    if (widget.isLocalDataShow == true) {
      Map<String, dynamic> result = {
        'isSuccess': true,
        'filePath': widget.htmlPath,
        'error': null,
      };
      loadingDownload(false);
      await _showNotification(result);
    } else {
      Map<String, dynamic> result = {
        'isSuccess': false,
        'filePath': null,
        'error': null,
      };
      try {
        final response = await _dio.download(
          file,
          savePath,
        );
        result['isSuccess'] = response.statusCode == 200;
        result['filePath'] = savePath;
        loadingDownload(false);
      } catch (ex) {
        loadingDownload(false);
        result['error'] = ex.toString();
      } finally {
        loadingDownload(false);
        await _showNotification(result);
      }
    }
  }

  Future<String?> _getDownloadDirectory() async {
    try {
      String directory = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      return directory;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<Directory?> _getDownloadDirectoryIos() async {
    try {
      Directory? directory = Platform.isAndroid
          ? await getExternalStorageDirectory() //FOR ANDROID
          : await getApplicationSupportDirectory();
      return directory;
    } catch (e) {
      return await getExternalStorageDirectory();
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

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
}
