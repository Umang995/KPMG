import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:video_player/video_player.dart';
import '../controller/eventFeedController.dart';
import '../model/feedDataModel.dart';
import 'fullScreenPlayer.dart';

class PostVideoPlayer extends StatefulWidget {
  Posts posts;
  bool isFullScreen;
  final Function onFullScreen;
  final Function onPlay;
  final Function onPause;

  PostVideoPlayer({
    super.key,
    required this.posts,
    required this.isFullScreen,
    required this.onFullScreen,
    required this.onPlay,
    required this.onPause,
  });

  @override
  State<PostVideoPlayer> createState() => _FeedListVideoPLayer();
}

class _FeedListVideoPLayer extends State<PostVideoPlayer>
    with WidgetsBindingObserver {
  late VideoPlayerController videoPlayerController;
  var _isPlaying = false.obs;
  final AuthenticationManager authenticationManager = Get.find();
  final EventFeedController eventFeedController = Get.find();
  bool _isVideoCompleted = false;

  @override
  void initState() {
    super.initState();
    // Add WidgetsBindingObserver to listen for lifecycle events
    WidgetsBinding.instance.addObserver(this);
    videoPlayerController =
        VideoPlayerController.file(File(widget.posts.video.toString() ?? ""))
          ..initialize().then((_) {
            setState(() {
              //videoPlayerController.play();
            });
          });

    // Add a listener to detect play/pause events
    // Add listener to update play state
    videoPlayerController.addListener(() async {
      setState(() {});
      _isPlaying(videoPlayerController.value.isPlaying);
      if (videoPlayerController.value.position ==
              videoPlayerController.value.duration &&
          !_isVideoCompleted) {
        setState(() {
          _isVideoCompleted = true;
        });
        widget.posts.isPlayVideo = false;
        eventFeedController.feedDataList.refresh();
      }
    });
  }

  // Listen for lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // Pause the video when the app goes into the background
      if (videoPlayerController.value.isPlaying) {
        videoPlayerController.pause();
      }
    }
  }

  void _togglePlayPause() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
    } else {
      videoPlayerController.play();
    }
    setState(() {});
  }

  @override
  void dispose() {
    // Remove the observer when the widget is disposed
    WidgetsBinding.instance.removeObserver(this);
    videoPlayerController.dispose();
    super.dispose();
    exitFullScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorLightGray,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: AspectRatio(
                  aspectRatio: videoPlayerController.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      videoPlayerController.value.isInitialized
                          ? GestureDetector(
                              onTap: () {
                                _togglePlayPause();
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: VideoPlayer(videoPlayerController),
                              ),
                            )
                          : _buildThumbnail(),
                      IgnorePointer(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            videoPlayerController.value.isInitialized
                                ? Obx(() => Icon(
                                      _isPlaying.value
                                          ? Icons.pause_circle
                                          : Icons.play_circle,
                                      color: _isPlaying.value
                                          ? Colors.transparent
                                          : Colors.white,
                                      size: 40,
                                    ))
                                : const SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: CircularProgressIndicator())
                          ],
                        ),
                      ),
                      widget.isFullScreen
                          ? Positioned(
                              right: 6,
                              bottom: 6,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(FullScreenPlayer(
                                    videoUrl: widget.posts.video ?? "",
                                    videoPlayerController:
                                        videoPlayerController,
                                    currentPosition:
                                        videoPlayerController.value.position,
                                  ));
                                },
                                child: Icon(
                                  Icons.fullscreen,
                                  color: white,
                                ),
                              ))
                          : const SizedBox()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        maxHeightDiskCache: 500,
        imageUrl: widget.posts.media ?? "",
        // memCacheHeight: 200,
        imageBuilder: (context, imageProvider) => Container(
          // height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
          ),
        ),
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  void exitFullScreen() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
