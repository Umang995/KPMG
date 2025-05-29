
import 'package:dreamcast/view/qrCode/controller/qr_page_controller.dart';
import 'package:get/get.dart';

class QRBadgeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QrPageController(),fenix: true);
  }
}
