import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Thumbnailhelper {
  static Future<File> saveAssetImageToFile(
      String assetPath, String fileName) async {
    try {
      // Load image from assets
      ByteData byteData = await rootBundle.load(assetPath);
      Uint8List imageData = byteData.buffer.asUint8List();

      final tempDir = Directory.systemTemp;
      final thumbnailFile =
          File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await thumbnailFile.writeAsBytes(imageData);

      /*// Get temporary directory
      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/$fileName';

      // Save the file
      File imageFile = File(filePath);
      await imageFile.writeAsBytes(imageData);

      print("Image saved at: $filePath");*/
      return thumbnailFile;
    } catch (e) {
      print("Error saving image: $e");
      throw Exception("Failed to save image");
    }
  }

  Future<String> generateThumbnail(videoUrl) async {
    var _thumbnailPath = (await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 120,
      quality: 50,
    ))!;
    return _thumbnailPath;
  }

  static Future<File?> generateThumbnailFile(videoUrl) async {
    File? thumbnailFile;
    var uint8list = (await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 50,
    ))!;

    if (uint8list != null) {
      final tempDir = Directory.systemTemp;
      thumbnailFile =
          File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await thumbnailFile.writeAsBytes(uint8list);
    }
    thumbnailFile ??= await Thumbnailhelper.saveAssetImageToFile(
        "assets/icons/ic_no_image.png", "default_thumbnail");
    return thumbnailFile;
  }
}
