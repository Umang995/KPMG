
import 'package:dreamcast/view/eventFeed/controller/eventFeedController.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
class EventFeedBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<EventFeedController>(EventFeedController());
   // Get.lazyPut(() => EventFeedController(),fenix: true);
   // Get.lazyPut<EventFeedController>(() => EventFeedController());
  }
}