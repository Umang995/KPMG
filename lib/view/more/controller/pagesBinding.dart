import 'package:get/get.dart';
import 'package:dreamcast/view/more/controller/timezoneController.dart';

class PagesBinding extends Bindings{
  @override
  void dependencies() {
    Get.put<TimezoneController>(TimezoneController());
  }

}