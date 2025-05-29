import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoModel {
  final String videoUrl;
  final String thumbnailUrl;
  final String title;

  VideoModel(
      {required this.videoUrl,
      required this.thumbnailUrl,
      required this.title});
}

class VideoListScreen extends StatefulWidget {
  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  List<VideoModel> videoList = [
    VideoModel(
      videoUrl:
          "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
      thumbnailUrl: "https://img.youtube.com/vi/ScMzIvxBSi4/0.jpg",
      title: "Sample Video 1",
    ),
    VideoModel(
      videoUrl:
          "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
      thumbnailUrl: "https://img.youtube.com/vi/tgbNymZ7vqY/0.jpg",
      title: "Sample Video 2",
    ),
  ];

  Map<int, VideoPlayerController?> _controllers = {};
  int? _activeIndex;
  bool showLoading = false;

  void _toggleVideo(int index) {
    if (_activeIndex == index) {
      // If already playing, stop and dispose the controller
      _disposeVideo(index);
      return;
    }

    // Stop previous video if different
    if (_activeIndex != null) {
      _disposeVideo(_activeIndex!);
    }

    // Initialize new video
    VideoPlayerController controller =
        VideoPlayerController.network(videoList[index].videoUrl);
    _controllers[index] = controller;
    _activeIndex = index;
    showLoading = true;
    setState(() {});

    controller.initialize().then((_) {
      setState(() {
        showLoading = false;
        controller.play();
      });
    });
  }

  void _disposeVideo(int index) {
    if (_controllers.containsKey(index) && _controllers[index] != null) {
      _controllers[index]!.pause();
      _controllers[index]!.dispose();
      _controllers.remove(index);
    }
    setState(() {
      _activeIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video List")),
      body: ListView.builder(
        itemCount: videoList.length,
        itemBuilder: (context, index) {
          final video = videoList[index];
          final VideoPlayerController? controller = _controllers[index];
          final bool isPlaying = _activeIndex == index &&
              controller != null &&
              controller.value.isPlaying;

          return Card(
            margin: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _toggleVideo(index),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (!isPlaying)
                        Image.network(video.thumbnailUrl,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover),
                      if (isPlaying &&
                          controller != null &&
                          controller.value.isInitialized)
                        AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              VideoPlayer(controller),
                              IconButton(
                                icon: Icon(Icons.stop_circle,
                                    size: 50, color: Colors.white),
                                onPressed: () => _disposeVideo(index),
                              ),
                            ],
                          ),
                        ),
                      if (!isPlaying)
                        Icon(Icons.play_circle_filled,
                            size: 60, color: Colors.white),
                      showLoading
                          ? const SizedBox(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator())
                          : SizedBox()
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(video.title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
