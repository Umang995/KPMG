import 'package:dreamcast/view/eventFeed/controller/eventFeedController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;
  final String Thumbnail;

  VideoThumbnailWidget({required this.videoUrl, required this.Thumbnail});

  @override
  _VideoThumbnailWidgetState createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  final EventFeedController feedController = Get.find();

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    feedController.thumbnailPath.value = (await VideoThumbnail.thumbnailFile(
      video: widget.videoUrl,
      //thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      quality: 100,
    ))!;
    feedController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => feedController.thumbnailPath.value != null &&
        feedController.thumbnailPath.value.isNotEmpty
        ? Stack(
      alignment: Alignment.center,
      children: [
        //Image.memory(feedController.thumbnailPath.value),
        Image.network(widget.Thumbnail),
        InkWell(
          onTap: () {
            //Get.to(VideoAppWidget(widget.videoUrl));
          },
          child: const Icon(
            Icons.play_circle,
            color: Colors.black,
          ),
        )
      ],
    )
        : const CircularProgressIndicator());
  }
}
