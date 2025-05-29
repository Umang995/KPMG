import 'package:chewie/chewie.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../utils/image_constant.dart';

class FeedListVideoPLayer extends StatefulWidget {
  dynamic url;
  FeedListVideoPLayer({super.key, required this.url});

  @override
  State<FeedListVideoPLayer> createState() => _FeedListVideoPLayer();
}

class _FeedListVideoPLayer extends State<FeedListVideoPLayer> {
  ChewieController? _chewieController;
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.url.toString() ?? ""),
    )..initialize().then((_) {
        videoPlayerController.play();
        setState(() {});
      });
    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      showOptions: false,
      showControls: true,
      allowFullScreen: true,
      allowPlaybackSpeedChanging: false,
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ],
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
    exitFullScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorLightGray,
      body: Container(
        color: Colors.black54,
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: videoPlayerController.value.isInitialized
                  ? AspectRatio(
                    aspectRatio: videoPlayerController != null &&
                        videoPlayerController.value.isInitialized
                        ? videoPlayerController.value.aspectRatio
                        : 16 / 9, // Default aspect ratio
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Chewie(controller: _chewieController!)),
                  )
                  : const CircularProgressIndicator(),
            ),
            Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    videoPlayerController.pause();
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(right: 15,top: 30),
                    child: SvgPicture.asset(
                      ImageConstant.icCloseCircle,
                      height: 30,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void enterFullScreen() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.leanBack); // Hide status and navigation bars
  }

  void exitFullScreen() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); // Go back to portrait
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); // Show status and navigation bars
  }
}
