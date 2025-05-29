import 'package:dreamcast/view/alert/controller/alert_controller.dart';
import 'package:get/get.dart';

class AlertPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AlertController());
 }
}
