import 'package:dreamcast/view/account/controller/account_controller.dart';
import 'package:dreamcast/view/guide/controller/info_guide_controller.dart';
import 'package:get/get.dart';

class InfoFaqBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<InfoFaqController>(InfoFaqController());
  }
}
