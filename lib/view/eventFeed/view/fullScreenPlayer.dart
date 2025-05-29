import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../../theme/app_colors.dart';

class FullScreenPlayer extends StatefulWidget {
  VideoPlayerController videoPlayerController;
  final String videoUrl;
  Duration currentPosition;

  FullScreenPlayer(
      {super.key,
      required this.videoUrl,
      required this.videoPlayerController,
      required this.currentPosition});

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  ChewieController? _chewieController;
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl.toString() ?? ""),
    )..initialize().then((_) {
        videoPlayerController.seekTo(widget.currentPosition);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: white,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.fullscreen_exit,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context); // Exit full-screen
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            videoPlayerController.value.isInitialized
                ? Flexible(
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Chewie(controller: _chewieController!),
                    ),
                  )
                : const CircularProgressIndicator(),
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

