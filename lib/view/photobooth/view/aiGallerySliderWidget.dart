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
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/photobooth/controller/photobooth_controller.dart';
import 'package:dreamcast/widgets/app_bar/appbar_leading_image.dart';
import 'package:dreamcast/widgets/app_bar/custom_app_bar.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:widget_zoom/widget_zoom.dart';

class AiGallerySliderWidget extends StatefulWidget {
  final selectedIndex;

  const AiGallerySliderWidget({super.key, required this.selectedIndex});

  @override
  State<AiGallerySliderWidget> createState() => _AiGallerySliderWidgetState();
}

class _AiGallerySliderWidgetState extends State<AiGallerySliderWidget> {
  late PageController _pageController;
  int selectedIndex = 0;
  ScrollController _thumbScrollController = ScrollController();

  PhotoBoothController photoBoothController = PhotoBoothController();
  var progressLoading = false.obs;
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
    selectedIndex = widget.selectedIndex;
    _pageController = PageController(initialPage: selectedIndex);
    // Add a small delay to ensure the widget builds first
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToThumbnail(selectedIndex);
    });
  }

  void _scrollToThumbnail(int index) {
    final offset = (index * 82.0) - 20; // Adjust based on item size + padding
    _thumbScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _thumbScrollController.dispose();
    super.dispose();
  }

  void _onThumbnailTap(int index, url) {
    setState(() {
      selectedIndex = index;
    });
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    _scrollToThumbnail(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 72.v,
        leadingWidth: 45.h,
        leading: AppbarLeadingImage(
          imagePath: ImageConstant.imgArrowLeft,
          margin: EdgeInsets.only(
            left: 7.h,
            top: 3,
            // bottom: 12.v,
          ),
          onTap: () {
            Get.back();
          },
        ),
        title: ToolbarTitle(title: "ai_gallery".tr),
        actions: [
          GetX<PhotoBoothController>(
            builder: (controller){
              return Padding(
                  padding: EdgeInsets.only(
                    right: 20.h,
                  ),
                  child: progressLoading.value
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorPrimary,
                    ),
                  )
                      : InkWell(
                    onTap: () async {
                      saveNetworkImage(controller.photoList[selectedIndex]);
                    },
                    child: Icon(
                      Icons.download,
                      color: colorPrimary,
                    ),
                  )
              );
            }
          )
        ],
      ),
      body: GetX<PhotoBoothController>(builder: (controller) {
        return Column(
          children: [
            // Main full screen image viewer
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: controller.photoList.length,
                onPageChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                  _scrollToThumbnail(index);
                  // if (index == widget.imageUrls.length - 1) {
                  //   await loadMoreImages();
                  // }
                },
                itemBuilder: (context, index) {
                  return  WidgetZoom(
                    heroAnimationTag: 'tag',
                    zoomWidget: CachedNetworkImage(
                      fit: BoxFit.contain,
                      maxHeightDiskCache: 500,
                      imageUrl: controller.photoList[index],
                      placeholder: (context, url) => Center(
                        child: Image.asset(
                          ImageConstant.imagePlaceholder,
                          fit: BoxFit.contain,
                        ),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        ImageConstant.imagePlaceholder,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Thumbnails list
            SizedBox(
              height: 90,
              child: ListView.builder(
                controller: _thumbScrollController,
                scrollDirection: Axis.horizontal,
                itemCount: controller.photoList.length,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, index) {
                  final isSelected = index == selectedIndex;
                  if (controller.isLoadMoreRunning.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  }
                  return GestureDetector(
                    onTap: () =>
                        _onThumbnailTap(index, controller.photoList[index]),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: isSelected ? const EdgeInsets.all(3) : null,
                      decoration: BoxDecoration(
                        border: isSelected
                            ? Border.all(color: colorPrimary, width: 2)
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(
                          maxHeightDiskCache: 500,
                          width: 70,
                          height: 70,
                          imageUrl: controller.photoList[index],
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) => Center(
                            child: Image.asset(
                              ImageConstant.imagePlaceholder,
                            ),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            ImageConstant.imagePlaceholder,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      }),
    );
  }

  ///the the image in gallery
  saveNetworkImage(String url) async {
    _requestPermission();
    downloadAndSaveImage(url);
  }

  ///download the image from url and save it in gallery.
  downloadAndSaveImage(String url) async {
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
      await _showNotification(res);
    }
    progressLoading(false);
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
