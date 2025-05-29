import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:dreamcast/view/eventFeed/controller/eventFeedController.dart';
import 'package:dreamcast/view/eventFeed/model/feedDataModel.dart';
import 'package:dreamcast/view/home/controller/home_controller.dart';
import 'package:dreamcast/view/schedule/controller/session_controller.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../routes/my_constant.dart';
import '../theme/app_colors.dart';
import '../theme/ui_helper.dart';
import '../utils/image_constant.dart';
import '../utils/pref_utils.dart';
import '../view/beforeLogin/globalController/authentication_manager.dart';
import '../view/eventFeed/controller/src/audio_player.dart';
import '../view/eventFeed/model/commentModel.dart';
import '../view/eventFeed/view/comment_bubble.dart';
import '../view/eventFeed/view/feed_report_page.dart';
import '../view/eventFeed/view/feed_video_player.dart';
import '../view/home/screen/pdfViewer.dart';
import '../view/skeletonView/skeleton_event_feed.dart';
import 'customImageWidget.dart';
import 'textview/customTextView.dart';
import 'custom_linkfy.dart';
import 'focused_menu_custom.dart';
import 'fullscreen_image.dart';
import 'lunchpad_menu_label.dart';

enum PostAction { deletePost, reportPost, share }

//those are used only for home page
class EventFeedWidget extends GetView<EventFeedController> {
  EventFeedWidget({super.key});
  final DashboardController dashboardController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetX<EventFeedController>(
      builder: (controller) {
        return controller.feedDataList.isNotEmpty
            ? Column(
                children: [
                  const SizedBox(height: 40),
                  LaunchpadMenuLabel(
                    title: "event_feed".tr,
                    trailing: "view_all".tr,
                    index: 5,
                    trailingIcon: "",
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.feedDataList.isNotEmpty
                        ? 1
                        : controller.feedDataList.length,
                    itemBuilder: (context, index) {
                      var posts = controller.feedDataList[index];
                      return Container(
                          padding: EdgeInsets.only(
                              left: 16.adaptSize,
                              right: 16.adaptSize,
                              top: 16.adaptSize,
                              bottom: 8.adaptSize),
                          decoration: BoxDecoration(
                              color: Theme.of(Get.context!)
                                  .scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: borderColor, width: 1)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              EventFeedChildWidget(
                                  posts: posts,
                                  index: index,
                                  isLaunchpad: true),
                            ],
                          ));
                    },
                  ),
                ],
              )
            : const SizedBox();
      },
    );
  }
}

//those are used only for social page
class EventFeedWidgetDynamic extends GetView<EventFeedController> {
  bool isFromLaunchpad;
  EventFeedWidgetDynamic({super.key, required this.isFromLaunchpad});

  final AuthenticationManager authenticationManager = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetX<EventFeedController>(
      builder: (controller) {
        return Skeletonizer(
            enabled: controller.isFirstLoadRunning.value,
            child: SizedBox(
              width: context.width,
              child: ListView.builder(
                cacheExtent: 9999,
                physics: const AlwaysScrollableScrollPhysics(),
                controller: controller.scrollController,
                scrollDirection: Axis.vertical,
                itemCount: controller.isFirstLoadRunning.value
                    ? 5
                    : controller.feedDataList.length,
                itemBuilder: (context, index) {
                  if (controller.isFirstLoadRunning.value) {
                    return const LoadingEventFeedWidget();
                  }
                  Posts posts = controller.feedDataList[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    child: Container(
                        width: context.width,
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.only(
                            top: 16, left: 15, right: 15, bottom: 6),
                        decoration: BoxDecoration(
                          color: colorLightGray,
                          borderRadius: BorderRadius.circular(15.adaptSize),
                        ),
                        child: EventFeedChildWidget(
                            posts: posts, index: index, isLaunchpad: false)),
                  );
                },
              ),
            ));
      },
    );
  }
}

class EventFeedChildWidget extends GetView<EventFeedController> {
  Posts posts;
  int index;
  bool isLaunchpad = false;
  EventFeedChildWidget(
      {super.key,
      required this.posts,
      required this.index,
      required this.isLaunchpad});

  final AuthenticationManager authenticationManager = Get.find();
  AuthenticationManager authController = Get.find();
  HomeController homeController = Get.find();

  final _messageController = TextEditingController();
  var focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomImageWidget(
                      size: 44.adaptSize,
                      color: isLaunchpad ? colorLightGray : white,
                      imageUrl: posts.user?.avatar ?? "",
                      fontSize: 18,
                      shortName: posts.user?.shortName ?? "",
                    ),
                    SizedBox(
                      width: 7.adaptSize,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextView(
                          text: posts.user?.name ?? "",
                          color: colorSecondary,
                          maxLines: 4,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        SizedBox(
                          width: 3.adaptSize,
                        ),
                        CustomTextView(
                          text: UiHelper.displayDatetimeSuffixEventFeed(
                              startDate: posts.created ?? "",
                              timezone:
                                  PrefUtils.getTimezone() ?? "Asia/Kolkata"),
                          color: colorGray,
                          fontWeight: FontWeight.normal,
                          maxLines: 3,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (posts.isPin == true)
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: SizedBox(
                          height: 30.adaptSize,
                          width: 30.adaptSize,
                          child: SvgPicture.asset("assets/svg/pin.svg"),
                        ),
                      ),
                    const SizedBox(
                      width: 12,
                    ),
                    popupMenuButton(context, isLaunchpad)
                  ],
                )
              ],
            ),
            SizedBox(
              height: 15.adaptSize,
            ),
            if (posts.text.toString().isNotEmpty)
              ReadMoreLinkify(
                text: posts.text?.replaceAll("<br", "").replaceAll("/>", "") ??
                    "",
                maxLines:
                    6, // Set the maximum number of lines before truncation
                style: TextStyle(
                    fontSize: 15.fSize,
                    color: colorSecondary,
                    fontWeight: FontWeight.normal),
                textAlign: TextAlign.start,
                linkStyle: TextStyle(
                    fontSize: 15.fSize,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500),
                onOpen: (link) async {
                  final Uri url = Uri.parse(link.url);
                  if (await canLaunchUrlString(link.url)) {
                    await launchUrlString(link.url,
                        mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            FeedMediaWidget(
              posts: posts,
              index: index,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                posts.emoticon!.count > 0
                    ? Padding(
                        padding: const EdgeInsets.only(top: 9, bottom: 3),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  controller.getFeedLikeList(
                                      feedId: posts.id ?? "");
                                },
                                child: LikeTitleWidget(posts: posts)),
                            CustomTextView(
                                text: posts.emoticon?.count.toString() ?? "",
                                color: colorGray,
                                textAlign: TextAlign.end,
                                fontWeight: FontWeight.normal,
                                fontSize: 12),
                          ],
                        ),
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    posts.type == "video" &&
                            posts.viewsCount != null &&
                            posts.viewsCount! > 0
                        ? Padding(
                            padding: const EdgeInsets.only(top: 9, bottom: 3),
                            child: Row(
                              children: [
                                //SvgPicture.asset(ImageConstant.ic_video_view),
                                const SizedBox(
                                  width: 4,
                                ),
                                CustomTextView(
                                    text:
                                        "${posts.viewsCount ?? ""} ${"views".tr}",
                                    color: colorGray,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12),
                                posts.comment!.total! > 0
                                    ? Text(
                                        " | ",
                                        style: TextStyle(color: colorGray),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    GestureDetector(
                      onTap: () async {
                        homeController.loading(isLaunchpad);
                        controller.loading(true);
                        await controller.getFeedCommentList(
                            feedId: posts.id ?? "");
                        homeController.loading(false);
                        controller.loading(false);
                        controller.feedDataList[controller.lastIndexPlay]
                            .isPlayVideo = false;
                        controller.feedDataList.refresh();
                        getCommentListBottomSheet(context, posts, index, false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 9, bottom: 3),
                        child: CustomTextView(
                            text: posts.comment!.total! > 0
                                ? "${posts.comment?.total.toString() ?? ""} ${"comments".tr}"
                                : "",
                            color: colorGray,
                            fontWeight: FontWeight.normal,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              height: 12.adaptSize,
              color: borderColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () async {
                      posts.showLikeButton =
                          posts.showLikeButton ? false : true;
                      controller.feedDataList.refresh();
                    },
                    child: SizedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: posts.emoticon?.status == true
                                ? buildMyLikeWidget(posts)
                                : SvgPicture.asset(ImageConstant.newLikeIcon,
                                    colorFilter: ColorFilter.mode(
                                        Theme.of(context).colorScheme.onSurface,
                                        BlendMode.srcIn)),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          CustomTextView(
                            text: posts.emoticon?.status == true
                                ? buildMyLikeTextWidget(posts)
                                : "like".tr,
                            // text: "Like",
                            fontWeight: FontWeight.w500,
                            color: colorSecondary, fontSize: 14,
                            // color: buildMyLikeTextColorWidget(posts),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  color: borderColor,
                  width: 1,
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () async {
                      homeController.loading(isLaunchpad);
                      controller.loading(true);
                      await controller.getFeedCommentList(
                          feedId: posts.id ?? "");
                      homeController.loading(false);
                      controller.loading(false);
                      controller.feedDataList[controller.lastIndexPlay]
                          .isPlayVideo = false;
                      controller.feedDataList.refresh();
                      getCommentListBottomSheet(context, posts, index, true);
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(ImageConstant.icComment,
                              colorFilter: ColorFilter.mode(
                                  Theme.of(context).colorScheme.onSurface,
                                  BlendMode.srcIn)),
                          CustomTextView(
                            text: "comment".tr,
                            fontWeight: FontWeight.w500,
                            color: colorSecondary,
                            fontSize: 14,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        Positioned(
            bottom: 35,
            child: posts.showLikeButton
                ? BuildLikeWidget(
                    posts: posts,
                  )
                : const SizedBox())
      ],
    );
  }

  Widget buildMyLikeWidget(Posts posts) {
    final reactions = posts.emoticon?.type;
    final Map<bool, String> reactionPaths = {
      reactions == "like": ImageConstant.thumbs_up,
      reactions == "love": ImageConstant.heart_icon,
      reactions == "care": ImageConstant.emoji_like_2,
      reactions == "haha": ImageConstant.emoji_like_1,
      reactions == "wow": ImageConstant.emoji_like_3,
    };
    // Find the first matching reaction path or provide a default empty path
    String path = reactionPaths.entries
        .firstWhere(
          (entry) => entry.key,
          orElse: () => MapEntry(false, ImageConstant.thumbs_up),
        )
        .value;

    return Image.asset(
      path,
      height: 30,
      width: 30,
    );
  }

  String buildMyLikeTextWidget(Posts posts) {
    String likeTitle = "Like";
    final reactions = posts.emoticon?.type;
    print(reactions);
    print(reactions);
    switch (reactions) {
      case "like":
        likeTitle = "Like";
        break;
      case "love":
        likeTitle = "Love";
        break;
      case "care":
        likeTitle = "Smile";
        break;
      case "haha":
        likeTitle = "Funny";
        break;
      case "wow":
        likeTitle = "Surprise";
        break;
    }
    return likeTitle;
  }

  popupMenuButton(BuildContext context, bool isLaunchpad) {
    return Align(
      alignment: Alignment.topRight,
      child: FocusedMenuHolderWidget(
        onPressed: () {},
        menuOffset: 6,
        menuWidth: MediaQuery.of(context).size.width / 2.9,
        openWithTap: true,
        blurSize: 0, // Disable blur effect
        animateMenuItems: false,
        menuItemExtent: 40,
        menuBoxDecoration: BoxDecoration(
            color: white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: borderColor, width: 1)),
        menuItems: [
          FocusedMenuItem(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(ImageConstant.sharePost),
                  const SizedBox(width: 10),
                  const CustomTextView(
                    text: "Share Post",
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ],
              ),
              backgroundColor: white, // Ensures no visual gap
              onPressed: () {
                controller.showThePost(posts);
              }),
          if (posts.user?.id != PrefUtils.getUserId() && (authenticationManager.configModel.body?.reportOptions?.isEventFeed ?? false))
            FocusedMenuItem(
                title: Row(
                  children: [
                    SvgPicture.asset(ImageConstant.reportPost),
                    const SizedBox(width: 10),
                    const Text(
                      "Report Post",
                    ),
                  ],
                ),
                onPressed: () {
                  controller.selectedReportOption.value = 0;
                  controller.commentResign = authenticationManager.configModel.body?.reportOptions?.eventFeed  ?? [];
                  Get.to(() => FeedReportPage(
                        eventFeedId: posts.id ?? "",
                        feedCommentId: "",
                        isReportPost: true,
                      ));
                  /*controller.showDeleteNoteDialog(
                      context: context,
                      content: "Are you sure you want to report this feed?",
                      title: "Alert",
                      logo: "",
                      confirmButtonText: "Report",
                      action: "report",
                      body: {"feed_id": posts.id},
                      posts: posts);*/
                }),
          if (posts.user?.id == PrefUtils.getUserId())
            FocusedMenuItem(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(ImageConstant.deletePost),
                  const SizedBox(width: 10),
                  const CustomTextView(
                    text: "Delete Post",
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ],
              ),
              backgroundColor: white, // Ensures no visual gap
              onPressed: () async {
                controller.showDeleteNoteDialog(
                    context: context,
                    content: "Are you sure you want to delete this feed??",
                    title: "Alert",
                    logo: "",
                    action: "delete",
                    confirmButtonText: "Delete",
                    body: {"feed_id": posts.id},
                    posts: posts);
              },
            )
        ],
        child: Container(
          decoration: BoxDecoration(
              color: isLaunchpad ? colorLightGray : white,
              borderRadius: BorderRadius.circular(100)),
          height: 30.adaptSize,
          width: 30.adaptSize,
          child: Icon(Icons.more_vert, color: colorSecondary),
        ),
      ),
    );
  }

  ///********* Get Comment List Bottom Sheet ***********///
  getCommentListBottomSheet(
      BuildContext context, Posts posts, int postIndex, bool isFocused) {
    try {
      if (isFocused == true) {
        focusNode.requestFocus();
      } else {
        focusNode.unfocus();
      }
    } catch (e) {
      print(e.toString());
    }

    showModalBottomSheet(
        context: context,
        backgroundColor: white,
        isScrollControlled:
            true, // Allows bottom sheet to adjust when keyboard opens
        builder: (context) {
          return GetX<EventFeedController>(builder: (controller) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: white,
                      border: Border.all(color: borderColor, width: 1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 6, right: 6, bottom: 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomTextView(
                                  text:
                                      "Total ${controller.feedCmtList.length} Comments",
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: colorSecondary,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child:
                                      SvgPicture.asset(ImageConstant.icClose),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Divider(color: colorLightGray),
                            const SizedBox(height: 12),
                            Expanded(
                              child: Skeletonizer(
                                enabled: controller.loading.value,
                                child: ListView.builder(
                                    controller: controller.scrollControllerCmt,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                    itemCount: controller.feedCmtList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Comments comments =
                                          controller.feedCmtList[index];
                                      return CommentBubble(
                                        comments: comments,
                                        feedId: posts.id ?? "",
                                        isMe: PrefUtils.getUserId() ==
                                                comments.user?.id
                                            ? true
                                            : false,
                                        feedIndex: postIndex,
                                      );
                                    }),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(color: borderColor)),
                                padding: const EdgeInsets.all(3),
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Expanded(
                                      child: TextField(
                                        keyboardType: TextInputType.multiline,
                                        textInputAction:
                                            TextInputAction.newline,
                                        maxLines: 3,
                                        minLines: 1,
                                        focusNode: focusNode,
                                        controller: _messageController,
                                        style: TextStyle(
                                            fontSize: 16.fSize,
                                            color: colorSecondary,
                                            fontWeight: FontWeight.normal),
                                        decoration: InputDecoration(
                                            hintText: "write_public_comment".tr,
                                            hintStyle: TextStyle(
                                                fontSize: 16.fSize,
                                                color: colorGray,
                                                fontWeight: FontWeight.normal),
                                            labelStyle: TextStyle(
                                                fontSize: 16.fSize,
                                                color: colorGray,
                                                fontWeight: FontWeight.normal),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    SizedBox(
                                      height: 46,
                                      width: 46,
                                      child: FloatingActionButton(
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          _sendMessage(index, posts);
                                        },
                                        backgroundColor: colorPrimary,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ImageIcon(
                                          AssetImage(ImageConstant.send_icon),
                                          color: white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  controller.loading.value ? const Loading() : const SizedBox()
                ],
              ),
            );
          });
        });
  }

  Future<void> _sendMessage(int postIndex, Posts posts) async {
    if (_messageController.text.trim().isNotEmpty) {
      var requestBody = {
        "feed_id": posts.id ?? "",
        "content": _messageController.text.trim()
      };
      _messageController.clear();
      await controller.createFeedComment(requestBody: requestBody);
      if (controller.feedCmtList.isNotEmpty &&
          controller.feedDataList.isNotEmpty) {
        controller.feedDataList[postIndex].comment?.total =
            controller.feedCmtList.length - 1 ?? 0;
        posts.comment?.total = controller.feedCmtList.length ?? 0;
        controller.feedDataList.refresh();
      }
    }
  }
}

class BuildLikeWidget extends StatefulWidget {
  final Posts posts;

  const BuildLikeWidget({super.key, required this.posts});

  @override
  _BuildLikeWidgetState createState() => _BuildLikeWidgetState();
}

class _BuildLikeWidgetState extends State<BuildLikeWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final EventFeedController controller = Get.find<EventFeedController>();
  final Map<int, AnimationController> _emojiControllers = {};
  final Map<int, Animation<double>> _emojiAnimations = {};
  final Map<int, Animation<double>> _emojiScaleAnimations = {};
  bool _isVisible = true; // Control widget visibility
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _bounceAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Create animation controllers for each emoji
    for (int i = 0; i < controller.likeOptionList.length; i++) {
      final emojiController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );
      _emojiControllers[i] = emojiController;

      _emojiAnimations[i] = Tween<double>(begin: 0.0, end: -35.0).animate(
        CurvedAnimation(parent: emojiController, curve: Curves.easeOutBack),
      );

      _emojiScaleAnimations[i] = Tween<double>(begin: 1.0, end: 2.0).animate(
        CurvedAnimation(parent: emojiController, curve: Curves.easeOutSine),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.posts.showLikeButton) {
        _animationController.forward();
      }
    });
  }

  void _animateEmoji(int index) {
    final emojiController = _emojiControllers[index];
    if (emojiController != null) {
      emojiController.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 400), () {
          emojiController.reverse().then((_) {
            // Ensure we check using EventFeedController, not AnimationController
            if (index == controller.likeOptionList.length - 1) {
              setState(() {
                _isVisible = false;
              });
            }
          });
        });
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();

    // Dispose each emoji animation controller to prevent memory leaks
    for (var controller in _emojiControllers.values) {
      controller.dispose();
    }

    _emojiControllers.clear();
    _emojiAnimations.clear();
    _emojiScaleAnimations.clear();

    super.dispose();
  }

  void _playSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/like_soundeffect.mp3'));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox(); // Hide the widget after animation

    return ScaleTransition(
      scale: _bounceAnimation,
      child: Card(
        elevation: 6,
        child: Container(
          height: 50,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.likeOptionList.length,
            itemBuilder: (context, index) {
              LikeOption likeOption = controller.likeOptionList[index];
              return GestureDetector(
                onTap: () async {
                  HapticFeedback.heavyImpact(); // Trigger haptic feedback
                  _playSound(); // Play sound
                  _animateEmoji(index);
                  await Future.delayed(const Duration(milliseconds: 1200));
                  controller.likeTheFeedPost(widget.posts, likeOption.likeType);
                },
                child: AnimatedBuilder(
                  animation: _emojiControllers[index]!,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _emojiAnimations[index]!.value),
                      child: Transform.scale(
                        scale: _emojiScaleAnimations[index]!.value,
                        child: child,
                      ),
                    );
                  },
                  child: Center(
                    child: Image.asset(
                      likeOption.url,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
/*
class buildLikeWidget extends GetView<EventFeedController> {
  Posts posts;
  buildLikeWidget({super.key, required this.posts});
  var height = 40.0;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        //width: MediaQuery.of(context).size.width * 0.6,
        height: 50,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: white, borderRadius: BorderRadius.circular(10)),
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: controller.likeOptionList.length,
          itemBuilder: (context, index) {
            LikeOption likeOption = controller.likeOptionList[index];
            return GestureDetector(
              onTap: () async {
                print("clicked 1");
                controller.likeTheFeedPost(posts, likeOption.likeType);
              },
              child: Center(
                child: Image.asset(likeOption.url,
                    height: height, fit: BoxFit.contain),
              ),
            );
          },
        ),
      ),
    );
  }
}
*/

class LikeTitleWidget extends GetView<EventFeedController> {
  Posts posts;
  LikeTitleWidget({super.key, required this.posts});
  @override
  Widget build(BuildContext context) {
    return buildLikeTitleWidget(posts);
  }

  buildLikeTitleWidget(Posts posts) {
    var eventType = posts.emoticon?.total;
    posts.emoticon?.emojiList.clear();

    if (eventType?.like != 0 ||
        (posts.emoticon?.type == "like" && posts.emoticon!.status ?? false)) {
      posts.emoticon?.emojiList.add(ImageConstant.thumbs_up);
    }
    if (eventType?.love != 0 ||
        (posts.emoticon?.type == "love" && posts.emoticon!.status ?? false)) {
      posts.emoticon?.emojiList.add(ImageConstant.heart_icon);
    }
    if (eventType?.care != 0 ||
        (posts.emoticon?.type == "care" && posts.emoticon!.status ?? false)) {
      posts.emoticon?.emojiList.add(ImageConstant.emoji_like_2);
    }
    if (eventType?.haha != 0 ||
        (posts.emoticon?.type == "haha" && posts.emoticon!.status ?? false)) {
      posts.emoticon?.emojiList.add(ImageConstant.emoji_like_1);
    }
    if (eventType?.wow != 0 ||
        (posts.emoticon?.type == "wow" && posts.emoticon!.status ?? false)) {
      posts.emoticon?.emojiList.add(ImageConstant.emoji_like_3);
    }
    int itemCount = posts.emoticon?.emojiList.length ?? 0;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 20, maxWidth: (itemCount * 20)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (var i = 0; i < itemCount; i++)
            Positioned(
              left: (i * (1 - .4) * 20).toDouble(),
              child:
                  Image.asset(posts.emoticon?.emojiList[i] ?? "", height: 20),
            ),
        ],
      ),
    );
  }
}

class FeedMediaWidget extends GetView<EventFeedController> {
  Posts posts;
  int index;
  FeedMediaWidget({super.key, required this.posts, required this.index});

  final SessionController sessionController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 6,
        ),
        posts.type == "image"
            ? SizedBox(
                height: 0.adaptSize,
              )
            : const SizedBox(),
        posts.type == "image"
            ? imageWidget(posts.media ?? "")
            : posts.type == "video"
                ? videoWidget(context, posts, index)
                : posts.type == "document"
                    ? fileWidget(posts.media ?? "")
                    : posts.type == "audio"
                        ? audioWidget(posts.media ?? "")
                        : const SizedBox(),
        /*const SizedBox(
          height: 12,
        )*/
      ],
    );
  }

  Widget imageWidget(url) {
    return InkWell(
      onTap: () => Get.to(FullImageView(imgUrl: url)),
      child: AspectRatio(
        aspectRatio: 16 / 9, // 16:9 aspect ratio
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            maxHeightDiskCache: 500,
            imageUrl: url,
            // memCacheHeight: 200,
            imageBuilder: (context, imageProvider) => Container(
              // height: 200,
              decoration: BoxDecoration(
                image:
                    DecorationImage(image: imageProvider, fit: BoxFit.contain),
              ),
            ),
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  // Set a default aspect ratio (16:9) for most videos
  double aspectRatio = 16 / 9;

  Widget videoWidget(
    context,
    Posts post,
    int index,
  ) {
    return AspectRatio(
        aspectRatio: 16 / 9, // 16:9 aspect ratio
        child: InkWell(
          onTap: () {
            Get.to(FeedListVideoPLayer(
              url: post.video ?? "",
            ));
            controller.viewVideoPostApi(
                requestBody: {"feed_id": posts.id ?? "", "type": "video"},
                post: posts);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  maxHeightDiskCache: 500,
                  imageUrl: posts.media ?? "",
                  // memCacheHeight: 200,
                  imageBuilder: (context, imageProvider) => Container(
                    // height: 200,
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
              ),
              Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.play_circle,
                  color: white,
                  size: 30,
                ),
              )
            ],
          ),
        ));
  }

  Widget audioWidget(url) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: CustomAudioPlayer(
        source: url,
        isShowDelete: false,
        onDelete: () {
          //controller.showPlayer(false);
        },
      ),
    );
  }

  Widget fileWidget(url) {
    String extension = url.split('.').last;
    return InkWell(
      onTap: () {
        if (extension == "pdf") {
          Get.to(
              () => PdfViewPage(htmlPath: url.toString(), title: "PDF file"));
        } else {
          UiHelper.inAppBrowserView(Uri.parse(url.toString()));
        }
      },
      child: extension == "pdf"
          ? Container(
              color: colorLightGray,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.picture_as_pdf,
                        color: colorSecondary,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      CustomTextView(
                        text: "File Upload",
                        fontSize: 16,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container(
              color: colorLightGray,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.file_download,
                        color: colorSecondary,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      CustomTextView(
                        text: "Download the file",
                        fontSize: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
