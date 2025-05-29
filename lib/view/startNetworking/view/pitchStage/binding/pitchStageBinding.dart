import 'package:dreamcast/view/speakers/controller/speakersController.dart';
import 'package:dreamcast/view/startNetworking/view/pitchStage/pitchStage_controller.dart';
import 'package:get/get.dart';
import '../../../../schedule/controller/session_controller.dart';
class PitchStageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PitchStageController(),fenix: true);
    Get.lazyPut(() => SessionController(),fenix: true);
    Get.lazyPut(() => SpeakersDetailController(),fenix: true);
  }
}
