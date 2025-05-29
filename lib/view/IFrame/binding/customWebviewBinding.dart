
import 'package:dreamcast/view/IFrame/customWebviewController.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class CustomWebViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CustomWebViewController>(CustomWebViewController());
  }
}
