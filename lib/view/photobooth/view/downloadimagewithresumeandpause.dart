import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';


enum DownloadStatus { notStarted, downloading, paused, completed, failed }

class ImageDownload {
  final String url;
  late String fileName;
  int downloaded = 0;
  int total = 0;
  DownloadStatus status = DownloadStatus.notStarted;
  CancelToken cancelToken = CancelToken();

  ImageDownload(this.url) {
    fileName = Uri.parse(url).pathSegments.last;
  }

  double get progress => total == 0 ? 0 : downloaded / total;
}

class ImageDownloadList extends StatefulWidget {
  @override
  _ImageDownloadListState createState() => _ImageDownloadListState();
}

class _ImageDownloadListState extends State<ImageDownloadList> {
  final Dio dio = Dio();
  List<ImageDownload> images = [
    ImageDownload('https://images.pexels.com/photos/31732874/pexels-photo-31732874/free-photo-of-colorful-street-art-on-modern-building-exterior.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
    ImageDownload("https://images.pexels.com/photos/20282777/pexels-photo-20282777/free-photo-of-mural-depicting-woman-with-white-flowers.jpeg?auto=compress&cs=tinysrgb&w=1200&lazy=load"),
    ImageDownload("https://images.pexels.com/photos/4345389/pexels-photo-4345389.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
    ImageDownload("https://images.pexels.com/photos/5496151/pexels-photo-5496151.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
  ];

  Future<String> _getSavePath(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$fileName';
  }

  void _startDownload(ImageDownload image) async {
    final path = await _getSavePath(image.fileName);
    try {
      setState(() {
        image.status = DownloadStatus.downloading;
      });

      await dio.download(
        image.url,
        path,
        cancelToken: image.cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              image.downloaded = received;
              image.total = total;
            });
          }
        },
      );

      setState(() {
        image.status = DownloadStatus.completed;
      });
    } catch (e) {
      setState(() {
        image.status = DownloadStatus.paused;
      });
    }
  }

  void _pauseDownload(ImageDownload image) {
    image.cancelToken.cancel();
    image.cancelToken = CancelToken(); // Reset for future resume
  }

  Widget _buildItem(ImageDownload image) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              leading: Image.network(image.url, width: 50, height: 50, fit: BoxFit.cover),
              title: Text(image.fileName),
              subtitle: Text(image.status.name.toUpperCase()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (image.status == DownloadStatus.notStarted || image.status == DownloadStatus.paused)
                    IconButton(
                      icon: Icon(Icons.play_arrow),
                      onPressed: () => _startDownload(image),
                    ),
                  if (image.status == DownloadStatus.downloading)
                    IconButton(
                      icon: Icon(Icons.pause),
                      onPressed: () => _pauseDownload(image),
                    ),
                  if (image.status == DownloadStatus.completed)
                    Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
            ),
            if (image.status == DownloadStatus.downloading || image.status == DownloadStatus.paused)
              LinearProgressIndicator(
                value: image.progress,
                backgroundColor: Colors.grey[300],
                color: Colors.blue,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Download List')),
      body: ListView(
        children: images.map(_buildItem).toList(),
      ),
    );
  }
}
