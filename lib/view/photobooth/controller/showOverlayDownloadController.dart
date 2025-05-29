import 'package:get/get.dart';

class DownloadOverlayController extends GetxController {
  var isVisible = false.obs;
  var message = "".obs;

  void show(String msg) {
    message.value = msg;
    isVisible.value = true;
  }

  void hide() {
    isVisible.value = false;
  }
}
