import 'package:dreamcast/view/eventFeed/controller/eventFeedController.dart';
import 'package:dreamcast/view/menu/controller/menuController.dart';
import 'package:dreamcast/view/photobooth/controller/MyltiImageUploadController.dart';
import 'package:dreamcast/view/photobooth/controller/downloadImageController.dart';
import 'package:dreamcast/view/photobooth/controller/photobooth_controller.dart';
import 'package:dreamcast/view/photos/controller/photoController.dart';
import 'package:get/get.dart';
import 'package:dreamcast/view/photobooth/controller/downloadImageController.dart';

class PhotoBoothBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PhotoBoothController>(PhotoBoothController());

  }
}
