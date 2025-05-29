import 'package:chewie/chewie.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/view/schedule/controller/session_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class BetterPlayerScreen extends StatefulWidget {
  dynamic url;
  BetterPlayerScreen({super.key, required this.url});

  @override
  State<BetterPlayerScreen> createState() => _BetterPlayerScreen();
}

class _BetterPlayerScreen extends State<BetterPlayerScreen> {
  SessionController controller = Get.find();
  //late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    controller.videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.url.toString() ?? ""),
    )..initialize().then((_) {
        setState(() {});
        // _videoPlayerController.play();
      });
    _chewieController = ChewieController(
      videoPlayerController: controller.videoPlayerController,
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

    //enterFullScreen();
  }

  @override
  void dispose() {
    controller.videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
    exitFullScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                controller.videoPlayerController.value.isInitialized
                    ? Flexible(
                        child: AspectRatio(
                          aspectRatio: controller
                              .videoPlayerController.value.aspectRatio,
                          child: Chewie(controller: _chewieController!),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ],
            ),
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


