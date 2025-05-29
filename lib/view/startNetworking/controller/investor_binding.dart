
import 'package:get/get.dart';
import 'invenstorController.dart';

class InvestorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InvestorController(),fenix: true);
  }
}
