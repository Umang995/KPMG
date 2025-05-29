import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:dreamcast/api_repository/app_url.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/dialog_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/photobooth/controller/MyltiImageUploadController.dart';
import 'package:dreamcast/view/photobooth/model/myPhotoModel.dart';
import 'package:dreamcast/view/photobooth/view/aiGallerySliderWidget.dart';
import 'package:dreamcast/view/photobooth/view/downloadimagewithresumeandpause.dart';
import 'package:dreamcast/view/photobooth/view/multiImageUploadingWidget.dart';
import 'package:dreamcast/view/photobooth/view/multiimageDownloadWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'dart:io';
import '../../../api_repository/api_service.dart';
import '../../../model/common_model.dart';
import '../../../utils/image_constant.dart';
import '../../../utils/pref_utils.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../../widgets/textview/customTextView.dart';
import '../model/photoListModel.dart';
import '../view/camera_screen.dart';
import 'package:path/path.dart' as path;

class PhotoBoothController extends GetxController {
  late final AuthenticationManager _authManager;
  var loading = false.obs;
  final ImagePicker _picker = ImagePicker();
  var photoList = <dynamic>[].obs;
  var totalPhotos = 0.obs;
  late bool hasNextPage;
  int pageNumber = 0;
  var isFirstLoadRunning = false.obs;
  var isLoadMoreRunning = false.obs;
  var progressLoading = false.obs;
  var downloadPosition = 0.obs;
  var user_id = "";
  List<CameraDescription> cameras = [];
  List<XFile> multiImage = [];
  var loadImagesLoader = false.obs;

  var isMyPhotos = false.obs;
  var totalPage = 0.obs;
  var selectedTabIndex = 1.obs;
  var isDownloading = false.obs;
  var uploadPhotoEnable = false.obs;

  var isCameraPermissionDenied = false.obs;
  var isCameraInitialized = false.obs;

  var isAiSearchVisible = true.obs;

  var activeDownloadUrls = <String>[].obs;
  var progress = <double>[].obs;
  var downloadedImages = <File>[].obs;
  var imageSizes = <double>[].obs;

  var isSelected = <bool>[].obs;
  var isSelectedImagesList = <String>[].obs;
  var isSelectionMode = false.obs;
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final ImagePickerPlatform pickerPlatform = ImagePickerPlatform.instance;

  ScrollController scrollController = ScrollController();
  @override
  void onInit() {
    super.onInit();

    /// Initialize the FlutterLocalNotificationsPlugin
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(requestAlertPermission: true);
    const initSettings = InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin!.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Get.to(() => MultiImageDownloader());
      },
    );

    _authManager = Get.find();
    user_id = PrefUtils.getUserId() ?? "";
    getAllPhotos(body: {"page": "1"}, isRefresh: false);
    getAvailableCameras();
  }

  ///load photos first time
  Future<void> getAllPhotos({required dynamic body, required isRefresh}) async {
    if (!_authManager.isLogin()) {
      return;
    }
    try {
      if (!isRefresh) {
        isFirstLoadRunning(true);
      }
      isSelected.value = [];
      isSelectedImagesList.value = [];
      isSelectionMode.value = false;
      final model = PhotoListModel.fromJson(json.decode(
        await apiService.dynamicPostRequest(
            body: body, url: AppUrl.eventPhotoListApi),
      ));
      isFirstLoadRunning(false);
      if (model.status! && model.code == 200) {
        isMyPhotos(false);
        uploadPhotoEnable(
            model.body?.actionUploadEnable.toString() == "1" ? true : false);
        totalPhotos.value = model.body?.total ?? 0;
        photoList.clear();

        hasNextPage = model.body!.hasNextPage!;
        pageNumber = 2;
        photoList.addAll(model.body!.gallery!);
        isSelected.addAll(List.filled(photoList.length, false));
        _loadMorePhotos();
        update();
        isFirstLoadRunning(false);
      } else {
        isFirstLoadRunning(false);
        update();
      }
    } catch (e) {
      isFirstLoadRunning(false);
    } finally {
      isFirstLoadRunning(false);
    }
  }

  ///add pagination for _loadMorePhotos
  Future<void> _loadMorePhotos() async {
    scrollController.addListener(() async {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        isAiSearchVisible(false);
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        isAiSearchVisible(true);
      }

      if (hasNextPage == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunning.value == false &&
          scrollController.position.maxScrollExtent ==
              scrollController.position.pixels) {
        isLoadMoreRunning(true);
        try {
          final model = PhotoListModel.fromJson(json.decode(
            await apiService.dynamicPostRequest(
                body: {"page": pageNumber}, url: AppUrl.eventPhotoListApi),
          ));
          if (model.status! && model.code == 200) {
            hasNextPage = model.body!.hasNextPage!;
            pageNumber = pageNumber + 1;
            photoList.addAll(model.body!.gallery!);
            // isSelected.addAll(List.filled(photoList.length, false));
            isSelected.value = [];
            for (var photo in photoList) {
              if (isSelectedImagesList.contains(photo)) {
                isSelected.add(true);
              } else {
                isSelected.add(false);
              }
            }
            update();
          }
        } catch (e) {
          print(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }

  var imageUrls = <String>[].obs;

  setImageUrls(List<String> urls) {
    imageUrls.clear();
    imageUrls.addAll(urls);
  }

  Future downloadSelectedImages(BuildContext context) async {
    if (isSelectedImagesList.isNotEmpty) {
      setImageUrls(isSelectedImagesList);
      progress.value = List.filled(isSelectedImagesList.length, 0.0);
      downloadedImages.value =
          List.filled(isSelectedImagesList.length, File(""));
      activeDownloadUrls.value = List.from(isSelectedImagesList); // make a copy
      imageSizes.value = List.filled(isSelectedImagesList.length, 0.0);
      startBackgroundDownload();
      fetchImageSizes();

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiImageDownloader(),
        ),
      );

      // Clear selection after returning
      isSelected.value = List.filled(photoList.length, false);
      isSelectedImagesList.clear();
      isSelectionMode.value = false;
    } else {
      UiHelper.showFailureMsg(null, "select_image_to_download".tr);
    }
  }

  void startBackgroundDownload() {
    downloadImages(
      activeDownloadUrls,
      onStart: () {
        isDownloading(true);
        // Start overlay when downloading starts
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          // Get.find<DownloadOverlayController>().show("Downloading...");
          await flutterLocalNotificationsPlugin.show(
            0,
            "Download Started",
            "Your images are being downloaded...",
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'download_channel',
                'Downloads',
                channelDescription: 'Download progress notifications',
                importance: Importance.low,
                priority: Priority.low,
                showProgress: false,
              ),
            ),
          );
        });
      },
      onEnd: () {
        isDownloading(false);
        // Hide overlay when download finishes
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          // Get.find<DownloadOverlayController>().hide();
          await flutterLocalNotificationsPlugin
              .cancel(0); // Cancel the progress notification

          await flutterLocalNotificationsPlugin.show(
            1,
            "Download Complete",
            "All images have been downloaded.",
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'download_channel',
                'Downloads',
                channelDescription: 'Download status updates',
                importance: Importance.high,
                priority: Priority.high,
              ),
            ),
          );
        });
      },
      onProgress: (index, progressValue) {
        // Update progress safely
        progress[index] = progressValue;
      },
      onComplete: (index, file) {
        // Update completed download state safely
        downloadedImages[index] = file;
      },
      onError: (index, error) {
        debugPrint("Error downloading image $index: $error");
      },
    );
  }

  void fetchImageSizes() async {
    for (int i = 0; i < activeDownloadUrls.length; i++) {
      final size = await getImageSizeInMB(activeDownloadUrls[i]);
      imageSizes[i] = size!;
    }
  }

  void removeImage(int index) {
    progress.removeAt(index);
    downloadedImages.removeAt(index);
    activeDownloadUrls.removeAt(index);
    imageSizes.removeAt(index);
  }

  Future<double?> getImageSizeInMB(String url) async {
    try {
      final response = await Dio().head(url);
      final contentLength =
          response.headers.value(HttpHeaders.contentLengthHeader);
      if (contentLength != null) {
        final bytes = int.tryParse(contentLength);
        if (bytes != null) {
          return bytes / (1024 * 1024); // Convert to MB
        }
      }
    } catch (e) {
      print("Failed to get image size for $url: $e");
    }
    return null;
  }

  final Dio _dio = Dio();

  Future<void> downloadImages(
    List<String> urls, {
    required Function(int index, double progress) onProgress,
    required Function(int index, File file) onComplete,
    required Function(int index, dynamic error) onError,
    Function()? onStart,
    Function()? onEnd,
  }) async {
    onStart?.call();
    for (int i = 0; i < activeDownloadUrls.length; i++) {
      final url = activeDownloadUrls[i];
      if (!activeDownloadUrls.contains(url)) continue;
      try {
        final response = await _dio.get<Uint8List>(
          url,
          options: Options(responseType: ResponseType.bytes),
          onReceiveProgress: (received, total) {
            if (total != -1) {
              progress[i] = received / total;
            }
          },
        );

        final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data!),
          name: "downloaded_image_$i",
        );

        if (result['isSuccess'] == true) {
          downloadedImages[i] = File(result['filePath']);
          print("Downloaded completely");
        }
      } catch (e) {
        print("Download failed for $url: $e");
      }
    }
    onEnd?.call();
  }

  void onImageTap(int index, String imageUrl, BuildContext context) {
    if (isSelectedImagesList.isNotEmpty || isSelectionMode.value) {
      toggleSelection(index, imageUrl);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AiGallerySliderWidget(selectedIndex: index),
        ),
      );
      // Get.to(FullImageView(
      //   imgUrl: images[index] ?? "",
      //   showNotification: true,
      //   showDownload: true,
      // ));
    }
  }

  onImageLongPress(int index, String imageUrl) {
    HapticFeedback.mediumImpact();
    if (isDownloading.value) {
      UiHelper.showFailureMsg(null, "download_progress_to_wait".tr);
      return;
    }
    if (!isSelectionMode.value) {
      isSelectionMode.value = true;
      toggleSelection(index, imageUrl);
    }
  }

  void toggleSelection(int index, String imageUrl) {
    final isCurrentlySelected = isSelected[index];

    if (isCurrentlySelected) {
      // Unselecting
      isSelected[index] = false;
      isSelectedImagesList.remove(imageUrl);
    } else {
      // Selecting
      if (isSelectedImagesList.length < 20) {
        isSelected[index] = true;
        isSelectedImagesList.add(imageUrl);
      } else {
        UiHelper.showFailureMsg(null, "select_limit_message".tr);
      }
    }
  }

  onClearData() {
    isSelectionMode.value = false;
    isSelected.value = List.filled(photoList.length, false);
    isSelectedImagesList.clear();
  }

  ///search the image by image.
  Future<void> searchAiImage({
    BuildContext? context,
    required String userId,
    required File imageFile,
  }) async {
    if (!_authManager.isLogin()) {
      return;
    }
    isMyPhotos(true);
    loading(true);
    MyPhotoModel? responseModel =
        await apiService.uploadMultipartRequest<MyPhotoModel>(
      url: AppUrl.seachAiPhototApi,
      fields: {"type": "file"},
      files: {"image": imageFile.path.toString()},
      timeout: const Duration(seconds: 50),
      fromJson: (json) => MyPhotoModel.fromJson(json),
    );
    loading(false);
    if (responseModel?.status ?? false) {
      photoList.clear();
      photoList.addAll(responseModel?.body ?? []);
      totalPhotos.value = photoList.length;
      photoList.refresh();
    } else {
      photoList.clear();
      totalPhotos(0);
      photoList.refresh();
      UiHelper.showFailureMsg(context, responseModel?.message ?? "");
    }
  }

  ///upload the image on server
  Future<void> storeImageToServer({
    BuildContext? context,
    required String userId,
    required File imageFile,
  }) async {
    loading(true);

    await apiService.uploadMultipartRequest<CommonModel>(
      url: AppUrl.uploadAiPhoto,
      fields: {"type": "file"},
      files: {"image": imageFile.path.toString()},
      timeout: const Duration(seconds: 50),
      fromJson: (json) => CommonModel.fromJson(json),
    );
    loading(false);
    getAllPhotos(body: {"page": "1"}, isRefresh: true);
  }

  getAvailableCameras() async {
    try {
      cameras = await availableCameras();
    } on CameraException catch (e) {
      print('Error in fetching the cameras: $e');
    }
  }

  ///the the image in gallery
  saveNetworkImage(String url) async {
    _requestPermission();
    downloadAndSaveImage(url);
  }

  ///search the image from camera
  imgFromCamera(isSearch) async {
    // Check current camera permission status
    PermissionStatus status = await Permission.camera.status;
    debugPrint("@@ camera status ${status.isDenied}");
    if (status.isPermanentlyDenied /*|| status.isDenied*/) {
      // If permission is denied or permanently denied
      DialogConstantHelper.showPermissionDialog();
    } else {
      final pickedFile =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
      if (pickedFile != null) {
        if (isSearch) {
          searchAiImage(imageFile: File(pickedFile.path), userId: user_id);
        } else {
          storeImageToServer(imageFile: File(pickedFile.path), userId: user_id);
        }
      }
    }
  }

  ///search the image from native camera
  searchFromCamera() async {
    var result = await Get.to(CameraScreen());
    if (result != null) {
      searchAiImage(imageFile: File(result), userId: user_id);
    }
  }

  imgFromGallery(isSearch) async {
    // Check current camera permission status
    PermissionStatus status = await Permission.camera.status;
    if (status.isPermanentlyDenied) {
      // If permission is denied or permanently denied
      DialogConstantHelper.showPermissionDialog();
    }
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      final fileExtension = path.extension(pickedFile.path).toLowerCase();
      if (fileExtension == '.png' ||
          fileExtension == '.jpg' ||
          fileExtension == '.jpeg') {
        if (isSearch) {
          searchAiImage(imageFile: File(pickedFile.path), userId: user_id);
        } else {
          storeImageToServer(imageFile: File(pickedFile.path), userId: user_id);
        }
      } else {
        UiHelper.showFailureMsg(null, "selectPngAndJpg".tr);
      }
    }
  }

  multiImgFromGallery(isSearch, BuildContext context) async {
    loadImagesLoader(true);
    // Check current camera permission status
    PermissionStatus status = await Permission.camera.status;
    if (status.isPermanentlyDenied) {
      // If permission is denied or permanently denied
      DialogConstantHelper.showPermissionDialog();
    }
    final ImagePickerPlatform pickerPlatform = ImagePickerPlatform.instance;
    if (pickerPlatform is ImagePickerAndroid) {
      pickerPlatform.useAndroidPhotoPicker = true;
      debugPrint("Using Android Photo Picker (Scoped Picker)");
    }
    final pickedFile = await _picker.pickMultiImage(
      limit: 10,
      imageQuality: 70,
    );
    if (pickedFile != null && pickedFile.isNotEmpty) {
      multiImage = pickedFile ?? [];
      print("imageLength ${multiImage.length}");
      uploadSelectedImages(context);
      // storeMultiImageToServer(userId: user_id, imageFile: multiImage);
    }
    loadImagesLoader(false);
  }

  Future uploadSelectedImages(BuildContext context) async {
    if (Get.isRegistered<MultiImageUploadController>()) {
      MultiImageUploadController photoBoothController =
          Get.put(MultiImageUploadController());
      photoBoothController.isUploading(false);
      photoBoothController.startUploading(false);
      photoBoothController.init(multiImage);
    } else {
      MultiImageUploadController photoBoothController =
          Get.put(MultiImageUploadController());
      photoBoothController.isUploading(false);
      photoBoothController.startUploading(false);
      photoBoothController.init(multiImage);
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiImageUploader(
          imageFiles: multiImage,
        ),
      ),
    );
    multiImage.clear();
    getAllPhotos(body: {"page": "1"}, isRefresh: false);
  }

  ///upload the image on server
  Future<void> storeMultiImageToServer({
    BuildContext? context,
    required String userId,
    required List<XFile> imageFile,
  }) async {
    loading(true);
    await Future.wait(imageFile.map((element) {
      return apiService.uploadMultipartRequest<CommonModel>(
        url: AppUrl.uploadAiPhoto,
        fields: {"type": "file"},
        files: {"image": element.path.toString()},
        timeout: const Duration(seconds: 50),
        fromJson: (json) => CommonModel.fromJson(json),
      );
    }));
    loading(false);
    getAllPhotos(body: {"page": "1"}, isRefresh: true);
  }

  _requestPermission() async {
    bool statuses;
    if (Platform.isAndroid) {
      await Permission.storage.request().isGranted;
    } else {
      statuses = await Permission.photosAddOnly.request().isGranted;
    }
  }

  // ******* Camera permission *******//
  Future<void> checkPermissionStatus(isSearch) async {
    var status = await Permission.camera.status;
    if (status.isPermanentlyDenied) {
      isCameraPermissionDenied(true);
    } else {
      isCameraPermissionDenied(false);
    }
  }

  void showPicker(BuildContext context, isSearch) {
    showModalBottomSheet(
        context: context,
        backgroundColor: white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                isSearch
                    ? const SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10.v,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.only(left: 18, bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomTextView(
                                          text: "upload_photos".tr,
                                          color: colorSecondary,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        CustomTextView(
                                          text: "upload_limit".tr,
                                          color: gray,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ]),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(bc).pop();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: SvgPicture.asset(
                                        ImageConstant.closeIcon,
                                        height: 29.v,
                                        width: 29.v,
                                      ),
                                    ),
                                  )
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 18, right: 18),
                            child: Divider(
                              color: borderColor,
                              height: 20.v,
                            ),
                          ),
                          ListTile(
                              leading: SvgPicture.asset(
                                ImageConstant.noImage,
                                color: colorSecondary,
                                height: 21.v,
                                width: 21.v,
                              ),
                              title: CustomTextView(
                                text: "photo".tr,
                                textAlign: TextAlign.start,
                                color: colorSecondary,
                                fontSize: 18,
                              ),
                              onTap: () {
                                multiImgFromGallery(isSearch, context);
                                Navigator.of(bc).pop();
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ImageDownloadList(),
                                //   ),
                                // );
                              }),
                        ],
                      ),
                ListTile(
                  leading: SvgPicture.asset(
                    ImageConstant.camera,
                    color: colorSecondary,
                    height: 21.v,
                    width: 21.v,
                  ),
                  title: CustomTextView(
                    text: "camera".tr,
                    textAlign: TextAlign.start,
                    color: colorSecondary,
                    fontSize: 18,
                  ),
                  onTap: () {
                    Navigator.of(bc).pop();
                    imgFromCamera(isSearch);
                  },
                ),
              ],
            ),
          );
        });
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
    }
    progressLoading(false);
  }
}
