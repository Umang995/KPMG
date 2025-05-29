import 'package:dreamcast/view/exhibitors/controller/exhibitorsController.dart';
import 'package:dreamcast/view/representatives/controller/user_detail_controller.dart';
import 'package:get/get.dart';
import '../../schedule/controller/session_controller.dart';
import '../../speakers/controller/speakersController.dart';
import '../controller/aiMatchController.dart';

class AiMatchDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AiMatchController());
    Get.lazyPut(() => UserDetailController(),fenix: true);
    Get.lazyPut(() => SessionController(),fenix: true);
    Get.lazyPut(() => BoothController(),fenix: true);
    Get.lazyPut(() => SpeakersDetailController(),fenix: true);
  }
}
