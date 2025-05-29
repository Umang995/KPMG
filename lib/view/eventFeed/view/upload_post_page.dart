import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/eventFeed/model/feedDataModel.dart';
import 'package:dreamcast/view/eventFeed/view/post_video_player.dart';
import 'package:dreamcast/widgets/customImageWidget.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../utils/pref_utils.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../controller/eventFeedController.dart';

class UploadPostPage extends StatefulWidget {
  var isPrivate;
  UploadPostPage({super.key, this.isPrivate});

  static const routeName = "/upload_post_page";

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  final AuthenticationManager authenticationManager = Get.find();
  final EventFeedController controller = Get.find();

  TextEditingController textfieldController = TextEditingController();
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    // Request focus when the page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      minimum: const EdgeInsets.only(top: 75),
      bottom: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white.withOpacity(0.0),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: const EdgeInsets.all(0),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(19),
                    topRight: Radius.circular(19)),
                color: Colors.white),
            height: double.infinity,
            child: GetX<EventFeedController>(builder: (controller) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.only(
                              left: 7, right: 10, top: 7, bottom: 7),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: colorLightGray),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomImageWidget(
                                imageUrl: PrefUtils.getImage(),
                                shortName: PrefUtils.getUsername(),
                                size: 30,
                                fontSize: 12,
                                color: white,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              CustomTextView(
                                text:
                                PrefUtils.getName().toString(),
                                fontSize: 16,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Form(
                            child: TextField(
                              focusNode: _focusNode,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  //counter: const Offstage(),
                                  hintText: "want_to_talk_about".tr,
                                  focusColor: colorGray),
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              maxLength: 2048,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(
                                    2048), // Restricts input length/ Ensures max length
                              ],
                              style: TextStyle(
                                color: colorSecondary,
                                fontWeight: FontWeight.normal,
                                fontSize: 16.fSize,
                                height: 2,
                              ),
                              controller: textfieldController,
                              maxLines: 5,
                              minLines: 2,
                            ),
                          ),
                        ),
                        controller.mediaPath.value.isNotEmpty
                            ? Container(
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                margin: const EdgeInsets.all(20),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    controller.mediaType.value == "image"
                                        ? imageWidget(context, size)
                                        : controller.mediaType.value == "video"
                                            ? playLocalVideo(context)
                                            : controller.mediaType.value ==
                                                    "document"
                                                ? fileWidget(size)
                                                : audioFileWidget(size),
                                    Positioned(
                                      top: -5,
                                      right: -5,
                                      child: InkWell(
                                        onTap: () {
                                          controller.videoLoaded(false);
                                          controller.mediaPath("");
                                          controller.xFeedFile = XFile("");
                                        },
                                        child: Container(
                                            margin: const EdgeInsets.all(10),
                                            padding: const EdgeInsets.all(10),
                                            alignment: Alignment.topRight,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: Colors.transparent,
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 2.0,
                                                  )
                                                ]),
                                            child: const Icon(
                                              Icons.clear,
                                              size: 30,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ),
                                  ],
                                ))
                            : controller.videoLoaded.value
                                ? const LinearProgressIndicator()
                                : const SizedBox(),
                        const SizedBox(height: 200),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        color: white,
                        border: Border(
                          top: BorderSide(
                            color: colorLightGray,
                            width: 1.0,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: CustomTextView(
                              text: "disclaimer_follow_policy".tr,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              maxLines: 2,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      controller.recordAudio(false);
                                      controller.imgFromGallery();
                                    },
                                    icon:
                                        buildIconWidget(ImageConstant.ic_image),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        controller.recordAudio(false);
                                        controller.videoFromGallery();
                                      },
                                      icon: buildIconWidget(
                                          ImageConstant.ic_video)),
                                  // Add more buttons if needed
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  OutlinedButton(
                                    onPressed: () async {
                                      final mediaNotEmpty =
                                          controller.mediaPath.value.isNotEmpty;
                                      final textNotEmpty = textfieldController
                                          .text
                                          .trim()
                                          .isNotEmpty;

                                      if (mediaNotEmpty || textNotEmpty) {
                                        final textLength = textfieldController
                                            .text
                                            .trim()
                                            .length;

                                        if (!mediaNotEmpty && textLength < 3) {
                                          UiHelper.showFailureMsg(
                                              context,
                                              "text_event_length_validation"
                                                  .tr);
                                          return;
                                        }

                                        FocusScope.of(context).unfocus();
                                        if (await controller.submitEventFeed(
                                          context: context,
                                          content:
                                              textfieldController.text.trim(),
                                        )) {
                                          Navigator.of(context).pop(true);
                                        }
                                      } else {
                                        UiHelper.showFailureMsg(context,
                                            "text_event_length_validation".tr);
                                      }
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: BorderSide(
                                          color: colorSecondary, width: 1),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      minimumSize: const Size(82, 30),
                                    ),
                                    child: CustomTextView(
                                      text: "publish".tr,
                                      color: colorSecondary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        controller.videoLoaded(false);
                        Get.back(result: false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SvgPicture.asset(ImageConstant.closeIcon),
                      ),
                    ),
                  ),
                  controller.isLoading.value
                      ? const Loading()
                      : const SizedBox(),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  buildIconWidget(String url) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(0),
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: colorLightGray),
        ),
        SvgPicture.asset(
          url,
          height: 26,
        )
      ],
    );
  }

  imageWidget(BuildContext context, Size size) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.width / aspectRatio,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.contain,
            image: FileImage(File(controller.mediaPath.value))),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        color: colorLightGray,
      ),
    );
  }

  // Set a default aspect ratio (16:9) for most videos
  double aspectRatio = 16 / 9;

  playLocalVideo(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.width / aspectRatio,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: white,
        ),
        child: PostVideoPlayer(
          onPause: () {},
          onPlay: () {},
          onFullScreen: () {
            controller.update();
          },
          posts: Posts(
              video: controller.mediaPath.value, media: "", user: User(id: "")),
          isFullScreen: false,
        ));
  }

  fileWidget(Size size) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: colorGray,
        ),
        child: Center(
            child: CustomTextView(
          text: "file_selected".tr,
          color: white,
          fontSize: 22,
        )),
      ),
    );
  }

  audioFileWidget(Size size) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: colorGray,
        ),
        child: Center(
            child: CustomTextView(
          text: "select_audio_file".tr,
          color: white,
          fontSize: 22,
        )),
      ),
    );
  }

  circularImage({url, shortName}) {
    return url.toString().isNotEmpty && url != null
        ? CircleAvatar(backgroundImage: NetworkImage(url))
        : Container(
            height: 80.adaptSize,
            width: 80.adaptSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
                child: CustomTextView(
              text: shortName ?? "",
              textAlign: TextAlign.center,
              fontSize: 18.adaptSize,
            )),
          );
  }
}
