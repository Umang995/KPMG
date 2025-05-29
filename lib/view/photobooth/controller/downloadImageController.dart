// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:dreamcast/theme/ui_helper.dart';
// import 'package:dreamcast/view/photobooth/controller/photobooth_controller.dart';
// import 'package:dreamcast/view/photobooth/view/aiGallerySliderWidget.dart';
// import 'package:dreamcast/view/photobooth/view/multiimageDownloadWidget.dart';
// import 'package:dreamcast/view/photos/controller/photoController.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:workmanager/workmanager.dart';
//
// class DownloadImageController extends GetxController {
//   var isSelected = <bool>[].obs;
//   var isSelectedImagesList = <String>[].obs;
//   var isSelectionMode = false.obs;
//
//   var activeDownloadUrls = <String>[].obs;
//   var progress = <double>[].obs;
//   var downloadedImages = <File>[].obs;
//   var imageSizes = <double>[].obs;
//
//   var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   late PhotoBoothController photoBoothController;
//
//   void onInit() {
//     super.onInit();
//     photoBoothController = Get.find();
//     Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
//
//     /// Initialize the FlutterLocalNotificationsPlugin
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const ios = DarwinInitializationSettings(requestAlertPermission: true);
//     const initSettings = InitializationSettings(android: android, iOS: ios);
//     flutterLocalNotificationsPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) async {
//         Get.to(() => MultiImageDownloader());
//       },
//     );
//   }
//
//   // WorkManager background task dispatcher
//   static void callbackDispatcher() {
//     Workmanager().executeTask((task, inputData) {
//       // Handle the background task for image downloading
//       if (task == "imageDownloadTask") {
//         List<String> downloadUrls = inputData?['urls']?.cast<String>() ?? [];
//         for (String url in downloadUrls) {
//
//         }
//       }
//       return Future.value(true);
//     });
//   }
//
//   static void downloadImageInBackground(String url) async {
//     try {
//       final response = await Dio(BaseOptions(
//         connectTimeout: 1,
//         receiveTimeout: 5,
//       )).get<Uint8List>(
//         url,
//         options: Options(responseType: ResponseType.bytes),
//       );
//       final result = await ImageGallerySaver.saveImage(
//         Uint8List.fromList(response.data!),
//         name: "downloaded_image_${DateTime.now().millisecondsSinceEpoch}",
//       );
//       if (result['isSuccess'] == true) {
//         print("Downloaded $url in background");
//       }
//     } catch (e) {
//       print("Failed to download $url in background: $e");
//     }
//   }
//
//   Future downloadSelectedImages(BuildContext context) async {
//     if (isSelectedImagesList.isNotEmpty) {
//       //photoBoothController.setImageUrls(isSelectedImagesList);
//       progress.value = List.filled(isSelectedImagesList.length, 0.0);
//       downloadedImages.value =
//           List.filled(isSelectedImagesList.length, File(""));
//       activeDownloadUrls.value = List.from(isSelectedImagesList);
//       imageSizes.value = List.filled(isSelectedImagesList.length, 0.0);
//       startBackgroundDownload();
//       fetchImageSizes();
//
//       final result = await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => MultiImageDownloader(),
//         ),
//       );
//
//       //isSelected.value = List.filled(photoBoothController.photoList.length, false);
//       isSelectedImagesList.clear();
//       isSelectionMode.value = false;
//     } else {
//       UiHelper.showFailureMsg(null, "Please select images to download!!");
//     }
//   }
//
//   void startBackgroundDownload() {
//     downloadImages(
//       activeDownloadUrls,
//       onStart: () {
//         print("Download is working in foreground");
//         // Start overlay when downloading starts
//         WidgetsBinding.instance.addPostFrameCallback((_) async {
//           // Get.find<DownloadOverlayController>().show("Downloading...");
//           await flutterLocalNotificationsPlugin.show(
//             0,
//             "Download Started",
//             "Your images are being downloaded...",
//             const NotificationDetails(
//               iOS: DarwinNotificationDetails(
//                 presentAlert: true,
//                 presentBadge: true,
//                 presentSound: true,
//               ),
//               android: AndroidNotificationDetails(
//                 'download_channel',
//                 'Downloads',
//                 channelDescription: 'Download progress notifications',
//                 importance: Importance.high,
//                 priority: Priority.high,
//                 showProgress: false,
//               ),
//             ),
//           );
//         });
//       },
//       onEnd: () {
//         print("Download is working in background");
//         // Hide overlay when download finishes
//         WidgetsBinding.instance.addPostFrameCallback((_) async {
//           // Get.find<DownloadOverlayController>().hide();
//           await flutterLocalNotificationsPlugin
//               .cancel(0); // Cancel the progress notification
//           await flutterLocalNotificationsPlugin.show(
//             1,
//             "Download Complete",
//             "All images have been downloaded.",
//             const NotificationDetails(
//               iOS: DarwinNotificationDetails(
//                 presentAlert: true,
//                 presentBadge: true,
//                 presentSound: true,
//               ),
//               android: AndroidNotificationDetails(
//                 'download_channel',
//                 'Downloads',
//                 channelDescription: 'Download status updates',
//                 importance: Importance.high,
//                 priority: Priority.high,
//               ),
//             ),
//           );
//         });
//       },
//       onProgress: (index, progressValue) {
//         // Update progress safely
//         progress[index] = progressValue;
//       },
//       onComplete: (index, file) {
//         // Update completed download state safely
//         downloadedImages[index] = file;
//       },
//       onError: (index, error) {
//         debugPrint("Error downloading image $index: $error");
//       },
//     );
//   }
//
//   void fetchImageSizes() async {
//     for (int i = 0; i < activeDownloadUrls.length; i++) {
//       final size = await getImageSizeInMB(activeDownloadUrls[i]);
//       imageSizes[i] = size!;
//     }
//   }
//
//   void removeImage(int index) {
//     progress.removeAt(index);
//     downloadedImages.removeAt(index);
//     activeDownloadUrls.removeAt(index);
//     imageSizes.removeAt(index);
//   }
//
//   Future<double?> getImageSizeInMB(String url) async {
//     try {
//       final response = await Dio(BaseOptions(
//         connectTimeout: 1,
//         receiveTimeout: 5,
//       )).head(url);
//       final contentLength =
//           response.headers.value(HttpHeaders.contentLengthHeader);
//       if (contentLength != null) {
//         final bytes = int.tryParse(contentLength);
//         if (bytes != null) {
//           return bytes / (1024 * 1024); // Convert to MB
//         }
//       }
//     } catch (e) {
//       print("Failed to get image size for $url: $e");
//     }
//     return null;
//   }
//
//   final Dio _dio = Dio();
//
//   Future<void> downloadImages(
//     List<String> urls, {
//     required Function(int index, double progress) onProgress,
//     required Function(int index, File file) onComplete,
//     required Function(int index, dynamic error) onError,
//     Function()? onStart,
//     Function()? onEnd,
//   }) async {
//     onStart?.call();
//     for (int i = 0; i < activeDownloadUrls.length; i++) {
//       final url = activeDownloadUrls[i];
//       if (!activeDownloadUrls.contains(url)) continue;
//       try {
//         final response = await _dio.get<Uint8List>(
//           url,
//           options: Options(responseType: ResponseType.bytes),
//           onReceiveProgress: (received, total) {
//             if (total != -1) {
//               progress[i] = received / total;
//             }
//           },
//         );
//
//         final result = await ImageGallerySaver.saveImage(
//           Uint8List.fromList(response.data!),
//           name: "downloaded_image_$i",
//         );
//
//         if (result['isSuccess'] == true) {
//           downloadedImages[i] = File(result['filePath']);
//           print("Downloaded completely");
//         }
//       } catch (e) {
//         print("Download failed for $url: $e");
//       }
//     }
//     progress.refresh();
//     onEnd?.call();
//   }
//
//   void onImageTap(int index, String imageUrl, BuildContext context) {
//     if (isSelectedImagesList.isNotEmpty || isSelectionMode.value) {
//       toggleSelection(index, imageUrl);
//     } else {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => AiGallerySliderWidget(selectedIndex: index),
//         ),
//       );
//       // Get.to(FullImageView(
//       //   imgUrl: images[index] ?? "",
//       //   showNotification: true,
//       //   showDownload: true,
//       // ));
//     }
//   }
//
//   onImageLongPress(int index, String imageUrl) {
//     HapticFeedback.mediumImpact();
//     if (!isSelectionMode.value) {
//       isSelectionMode.value = true;
//       toggleSelection(index, imageUrl);
//     }
//   }
//
//   void toggleSelection(int index, String imageUrl) {
//     final isCurrentlySelected = isSelected[index];
//
//     if (isCurrentlySelected) {
//       // Unselecting
//       isSelected[index] = false;
//       isSelectedImagesList.remove(imageUrl);
//     } else {
//       // Selecting
//       if (isSelectedImagesList.length < 10) {
//         isSelected[index] = true;
//         isSelectedImagesList.add(imageUrl);
//       } else {
//         UiHelper.showFailureMsg(
//             null, "You can select only 10 images at a time!!");
//       }
//     }
//   }
// }
