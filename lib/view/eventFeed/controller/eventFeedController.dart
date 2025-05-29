import 'dart:convert';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:dreamcast/model/common_model.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/view/eventFeed/model/commentModel.dart';
import 'package:dreamcast/view/eventFeed/model/feedDataModel.dart';
import 'package:dreamcast/view/home/controller/home_controller.dart';
import 'package:dreamcast/widgets/dialog/custom_dialog_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/thumbnail_helper.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../model/createCommentModel.dart';
import '../model/createPostModel.dart';
import '../model/feedLikeModel.dart';
import '../model/postLikeModel.dart';
import '../view/LikeListPage.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class EventFeedController extends GetxController {
  var feedDataList = <Posts>[].obs;
  var feedDataListPrivate = <Posts>[].obs;

  var feedCmtList = <dynamic>[].obs;
  var showPlayer = false.obs;
  var thumbnailPath = "".obs;
  var isLoading = false.obs;
  var sponsorLoading = false.obs;
  var isFilePicked = false.obs;
  var recordAudio = false.obs;

  final ImagePicker _picker = ImagePicker();
  XFile _xFeedFile = XFile("");

  set xFeedFile(XFile value) {
    _xFeedFile = value;
  }

  XFile get pickedFile => _xFeedFile;

  File? _thumbnailFile;

  File? get thumbnailFile => _thumbnailFile;
  var mediaPath = "".obs;
  var mediaType = "".obs;
  final PlatformFile _platformFile = PlatformFile(name: "", size: 0);

  PlatformFile get platformFile => _platformFile;
  var commentResign = [
    'Nudity',
    'Violence',
    'Harassment',
    'Suicide or Self-Injury',
    'False Information',
    'Spam',
    'Unauthorized Sales',
    'Hate Speech',
    'Terrorism',
    'Something Else'
  ];

  final FocusNode focusNode = FocusNode();
  var isFocused = false.obs;
  var showLikeButton = false.obs;
  var selectedReportOption = 0.obs;

  final _scrollController = ScrollController();
  get scrollController => _scrollController;

  final _scrollControllerCmt = ScrollController();
  get scrollControllerCmt => _scrollControllerCmt;
  final HomeController _homeController = Get.find();

  var likeOptionList = <LikeOption>[].obs;

  late bool hasNextPage;
  late int _pageNumber;
  var isLoadMoreRunning = false.obs;
  late bool hasNextPageCmt;
  late int _pageNumberCmt;
  var isLoadMoreRunningCmt = false.obs;
  var isFirstLoadRunning = false.obs;

  var loading = false.obs;
  var feedLikeBody = FeedLikeBody().obs;

  var feedLikeList = [];

  final HomeController _dashboardController = Get.find();
  final AuthenticationManager authManager = Get.find();

  var lastIndexPlay = 0;

  @override
  void onInit() {
    super.onInit();
    likeOptionList.clear();
    focusNode.addListener(() {
      isFocused.value = focusNode.hasFocus;
    });
    likeOptionList
        .add(LikeOption(url: ImageConstant.thumbs_up, likeType: "like"));
    likeOptionList
        .add(LikeOption(url: ImageConstant.heart_icon, likeType: "love"));
    likeOptionList
        .add(LikeOption(url: ImageConstant.emoji_like_2, likeType: "care"));
    likeOptionList
        .add(LikeOption(url: ImageConstant.emoji_like_1, likeType: "haha"));
    likeOptionList
        .add(LikeOption(url: ImageConstant.emoji_like_3, likeType: "wow"));
  }

  @override
  void onClose() {
    focusNode.dispose();
    super.onClose();
  }

  Future<void> getEventFeed({required bool isLimited}) async {
    if (!authManager.isLogin()) {
      return;
    }
    lastIndexPlay = 0;
    _pageNumber = 1;
    isFirstLoadRunning(true);

    final model = FeedDataModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: {
          "filters": {"page": _pageNumber, "type": ""}
        },
        url: AppUrl.feedGetList,
      ),
    ));
    isFirstLoadRunning(false);
    if (model.status ?? false) {
      feedDataList.clear();
      feedDataList.addAll(model.body?.posts ?? []);
      hasNextPage = model.body?.hasNextPage ?? false;
      _pageNumber = _pageNumber + 1;
      feedDataList.refresh();
      _homeController.feedDataList.clear();
      if (feedDataList.isNotEmpty) {
        _homeController.feedDataList.add(feedDataList[0]);
      }
      update();
      _loadMoreEventFeed();
    }
  }

  Future<void> _loadMoreEventFeed() async {
    scrollController.addListener(() async {
      if (hasNextPage == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunning.value == false &&
          scrollController.position.maxScrollExtent ==
              scrollController.position.pixels) {
        isLoadMoreRunning(true);
        try {
          final model = FeedDataModel.fromJson(json.decode(
            await apiService.dynamicPostRequest(
              body: {
                "filters": {"page": _pageNumber, "type": ""}
              },
              url: AppUrl.feedGetList,
            ),
          ));

          if (model.status! && model.code == 200) {
            hasNextPage = model.body?.hasNextPage ?? false;
            _pageNumber = _pageNumber + 1;
            feedDataList.addAll(model.body?.posts ?? []);
            update();
          }
        } catch (e) {
          print(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }

  Future<void> getFeedCommentList({feedId}) async {
    _pageNumberCmt = 1;
    loading(true);
    final model = FeedCommentModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(body: {
        "feed_id": feedId,
        "filters": {"page": _pageNumberCmt, "hasNextPage": false}
      }, url: AppUrl.feedCommentGet),
    ));
    loading(false);
    if (model.status ?? false) {
      feedCmtList.clear();
      feedCmtList.addAll(model.body?.comments ?? []);
      hasNextPageCmt = model.body?.hasNextPage ?? false;
      _pageNumberCmt = _pageNumberCmt = 1;
      _loadMoreFeedComment(feedId: feedId);
    }
  }

  Future<void> _loadMoreFeedComment({feedId}) async {
    scrollControllerCmt.addListener(() async {
      if (hasNextPageCmt == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunningCmt.value == false &&
          scrollControllerCmt.position.maxScrollExtent ==
              scrollControllerCmt.position.pixels) {
        isLoadMoreRunningCmt(true);
        try {
          final model = FeedCommentModel.fromJson(json.decode(
            await apiService.dynamicPostRequest(body: {
              "feed_id": feedId,
              "filters": {"page": _pageNumberCmt, "hasNextPage": false}
            }, url: AppUrl.feedCommentGet),
          ));
          if (model.status! && model.code == 200) {
            hasNextPageCmt = model.body?.hasNextPage ?? false;
            _pageNumberCmt = _pageNumberCmt = 1;
            feedCmtList.addAll(model.body?.comments ?? []);
          }
        } catch (e) {
          print(e.toString());
        }
        isLoadMoreRunningCmt(false);
      }
    });
  }

  void scrollToBottom() {
    if (feedCmtList.isNotEmpty) {
      // _scrollController.position.maxScrollExtent;
      Future.delayed(const Duration(seconds: 1), () {
        scrollControllerCmt.animateTo(
          scrollControllerCmt.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      });
    }
  }

  Future<void> getFeedLikeList({feedId}) async {
    _dashboardController.loading(true);
    loading(true);
    final model = LikeFeedModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: {"feed_id": feedId}, url: AppUrl.feedEmotionsGet),
    ));
    _dashboardController.loading(false);
    loading(false);
    if (model.status ?? false) {
      feedLikeBody(model.body);
      Get.to(FeedLikeListPage());
    } else {
      UiHelper.showFailureMsg(null, "data_not_found".tr);
    }
  }

  Future<void> createFeedComment({requestBody}) async {
    loading(true);
    final model = CreateCommentModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: requestBody, url: AppUrl.feedCommentGetCreate),
    ));
    loading(false);
    if (model.status ?? false) {
      feedCmtList.add(Comments(
          created: model.body?.created ?? "",
          id: model.body?.id ?? "",
          content: model.body?.content ?? "",
          user: UserData(
              id: model.body?.user?.id ?? "",
              shortName: model.body?.user?.shortName ?? "",
              name: model.body?.user?.name ?? "",
              avatar: model.body?.user?.avatar ?? "")));
      refresh();
      scrollToBottom();
    } else {
      UiHelper.showFailureMsg(null, "data_not_found".tr);
    }
  }

  Future<dynamic> likeFeedPost({feedId, type}) async {
    final model = PostLikeModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: {"feed_id": feedId, "type": type},
          url: AppUrl.feedEmotionsToggleMe),
    ));
    loading(false);
    if (model.status ?? false) {
      return {
        "is_like": model.body?.toggle ?? false,
        "count": model.body?.count ?? 0
      };
    } else {
      return {"is_like": false ?? false, "count": 0};
    }
  }

  //delete post from server
  Future<void> deletePostApi({required requestBody}) async {
    loading(true);
    final model = CommonModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: requestBody, url: AppUrl.feedDelete),
    ));
    loading(false);
    UiHelper.showSuccessMsg(null, model.message ?? "");
  }

  //report post
  Future<void> reportPostApi({required requestBody}) async {
    print(requestBody);
    loading(true);
    final model = CommonModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: requestBody, url: AppUrl.feedReport),
    ));
    loading(false);
    UiHelper.showSuccessMsg(null, model.message ?? "");
  }

  Future<void> showThePost(Posts posts) async {
    final imageUrl = posts.type == "video" ? posts.video : posts.media;

    if (imageUrl == null) {
      // Share only the text if no media is available
      Share.share(UiHelper.removeHtmlTags(posts.text ?? ""));
    } else {
      try {
        final uri = Uri.parse(imageUrl);
        loading(true);

        // Fetch the media file from the URL
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          // Determine the file type based on the URL
          final isVideo =
              imageUrl.endsWith('.mp4') || imageUrl.endsWith('.mov');
          final fileExtension = isVideo ? 'mp4' : 'jpg';

          // Get the appropriate directory to save the file
          Directory? tempDir = Platform.isAndroid
              ? await getExternalStorageDirectory() // For Android
              : await getApplicationSupportDirectory(); // For iOS

          final filePath = '${tempDir?.path}/shared_media.$fileExtension';

          // Save the downloaded file
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          loading(false);

          // Share the downloaded file with optional text
          await Share.shareXFiles(
            [XFile(filePath)],
            text: UiHelper.removeHtmlTags(posts.text ?? ""),
          );
        } else {
          loading(false);
          debugPrint('Failed to load media: ${response.statusCode}');
        }
      } catch (e) {
        loading(false);
        debugPrint('Error downloading media: $e');
      }
    }
  }

  Future<void> viewVideoPostApi(
      {required requestBody, required Posts post}) async {
    final model = CommonModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: requestBody, url: AppUrl.videPost),
    ));
    if (model.status == true) {
      post.viewsCount = post.viewsCount ?? 0 + 1;
      feedDataList.refresh();
    }
    //loading(false);
  }

  ///delete post from server
  Future<void> deleteCommentApi({required requestBody}) async {
    loading(true);
    final model = CommonModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: requestBody, url: AppUrl.feedCommentGetTrash),
    ));
    loading(false);
    UiHelper.showSuccessMsg(null, model.message ?? "");
  }

  ///report post
  Future<void> reportCommentApi({required requestBody}) async {
    loading(true);
    final model = CommonModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: requestBody, url: AppUrl.feedCommentGetReport),
    ));
    loading(false);
    UiHelper.showSuccessMsg(null, model.body.message ?? model.message);
  }

  Future<bool> submitEventFeed(
      {required BuildContext context, required String content}) async {
    isLoading(true);
    var formData = <String, String>{};
    formData["text"] = content;
    formData["type"] = pickedFile.path.isEmpty ? "text" : mediaType.value;
    CreatePostModel? responseModel = await apiService.createEventFeed(
        formData, pickedFile, _thumbnailFile, mediaType.value);
    isLoading(false);
    if (responseModel?.status != null && responseModel!.status!) {
      clearTheMedia();
      UiHelper.showSuccessMsg(
          null, responseModel.body?.message ?? "feed_submit_success".tr);
      return true;
    } else {
      UiHelper.showFailureMsg(null, responseModel?.message ?? "");
      return false;
    }
  }

  clearTheMedia() {
    xFeedFile = XFile("");
    _thumbnailFile = null;
    mediaPath("");
    mediaType("");
    isFilePicked(false);
  }

  imgFromCamera() async {
    var pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    File compressedFile = await UiHelper.compressImage(
        originalFile: File(pickedFile?.path ?? ""));
    _xFeedFile = XFile(compressedFile.path);
    mediaPath(_xFeedFile.path);
    mediaType("image");
    isFilePicked(true);
  }

  ///record the vide from the camera
  recordVideoFile() async {
    var pickedFile = await _picker.pickVideo(
      source: ImageSource.camera,
    );
    _xFeedFile = pickedFile!;
    mediaPath(_xFeedFile.path);
    mediaType("video");
    await VideoThumbnail.thumbnailData(
      video: _xFeedFile.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth:
          128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );
    isFilePicked(true);
  }

  var videoLoaded = false.obs;

  ///used for the upload the video from the gallery
  videoFromGallery() async {
    try {
      videoLoaded(true);
      var pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,
      );
      mediaPath.value = "";
      if (pickedFile == null) {
        videoLoaded(false);
      }
      await Future.delayed(const Duration(seconds: 1));
      _xFeedFile = pickedFile!;
      mediaPath(_xFeedFile.path);
      mediaType("video");
      _thumbnailFile =
          await Thumbnailhelper.generateThumbnailFile(_xFeedFile.path);
      videoLoaded(false);
      isFilePicked(true);
    } catch (exception) {
      videoLoaded(false);
    }
    print("@@@ thumbnailFile ${_thumbnailFile?.path}");
    print("@@@ mediaPath ${mediaPath}");

    refresh();
  }

  //no need for this current
  imgFromGallery() async {
    var pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      final fileExtension = path.extension(pickedFile.path).toLowerCase();
      if (fileExtension == '.png' ||
          fileExtension == '.jpg' ||
          fileExtension == '.jpeg') {
        File compressedFile = await UiHelper.compressImage(
            originalFile: File(pickedFile.path ?? ""), maxSizeInMB: 5);
        _xFeedFile = XFile(compressedFile.path);

        //_xFeedFile = pickedFile;
        mediaPath(_xFeedFile.path);
        mediaType("image");
        isFilePicked(true);
        refresh();
      } else {
        UiHelper.showFailureMsg(null, "selectPngAndJpg".tr);
      }
    } else {
      print('No file selected.');
    }
  }

  selectFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      dialogTitle: "select_file_to_upload".tr,
      allowedExtensions: ['xls', 'xlsx', 'pdf', 'csv'],
    );
    if (result != null && result.files.isNotEmpty) {
      final PlatformFile file = result.files.single;
      _xFeedFile = XFile(file.path.toString());
      mediaPath(_xFeedFile.path);
      mediaType("document");
      isFilePicked(true);
      refresh();
    }
  }

  audioFileFromGallery() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.audio,
      dialogTitle: "select_file_to_upload".tr,
    );
    if (result != null && result.files.isNotEmpty) {
      final PlatformFile file = result.files.single;
      _xFeedFile = XFile(file.path.toString());
      mediaPath(_xFeedFile.path);
      mediaType("audio");
      isFilePicked(true);
      refresh();
      print(mediaType);
    }
  }

  likeTheFeedPost(Posts posts, String likeType) async {
    posts.showLikeButton = false;

    var newType = likeType;
    var oldType = posts.emoticon?.type ?? "";

    if (posts.emoticon?.status == true) {
      if (oldType != newType) {
        // Decrement old reaction
        final oldValue = posts.emoticon!.total!.getReaction(oldType) ?? 0;
        posts.emoticon!.total!.setReaction(oldType, oldValue - 1);
        posts.emoticon?.count = posts.emoticon!.count - 1;
        posts.emoticon?.status = false;

        posts.emoticon?.type = newType;
        final newValue = posts.emoticon!.total!.getReaction(newType) ?? 0;
        posts.emoticon!.total!.setReaction(newType, newValue + 1);
        posts.emoticon?.count = posts.emoticon!.count + 1;
        posts.emoticon?.status = true;
        feedDataList.refresh();
      } else {
        final oldValue = posts.emoticon!.total!.getReaction(oldType) ?? 0;
        posts.emoticon!.total!.setReaction(oldType, oldValue - 1);
        posts.emoticon?.count = posts.emoticon!.count - 1;
        posts.emoticon?.status = false;
      }
    } else {
      // Add a new reaction
      posts.emoticon?.type = newType;
      final newValue = posts.emoticon!.total!.getReaction(newType) ?? 0;
      posts.emoticon!.total!.setReaction(newType, newValue + 1);
      posts.emoticon?.status = true;
      posts.emoticon?.count = posts.emoticon!.count + 1;
    }

    feedDataList.refresh();
    await likeFeedPost(feedId: posts.id ?? "", type: likeType);
  }

  void showDeleteNoteDialog(
      {required context,
      required content,
      required title,
      required logo,
      required confirmButtonText,
      required body,
      required action,
      required posts}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogWidget(
          logo: logo,
          title: title,
          description: content,
          buttonAction: "Yes, $confirmButtonText",
          buttonCancel: "cancel".tr,
          onCancelTap: () {},
          onActionTap: () async {
            switch (action) {
              case "delete":
                await deletePostApi(requestBody: body);
                feedDataList.remove(posts);
                feedDataList.refresh();
                break;
              case "report":
                await reportPostApi(requestBody: body);
                feedDataList.remove(posts);
                feedDataList.refresh();
                break;
              case "share":
                await reportPostApi(requestBody: body);
                feedDataList.remove(posts);
                feedDataList.refresh();
                break;
            }
          },
        );
      },
    );
  }
}

class LikeOption {
  String url;
  String likeType;
  LikeOption({required this.url, required this.likeType});
}
