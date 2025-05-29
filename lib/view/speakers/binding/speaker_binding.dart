import 'package:dreamcast/view/speakers/controller/speakerNetworkController.dart';
import 'package:get/get.dart';
import '../../schedule/controller/session_controller.dart';
import '../controller/speakersController.dart';

/// A binding class for the SpeakerScreen.
///
/// This class ensures that the SpeakerController is created when the
/// SpeakerScreen is first loaded.
class SpeakerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SpeakersDetailController());
    Get.lazyPut(() => SpeakersDetailController(), fenix: true);
    Get.lazyPut(() => SpeakerNetworkController(), fenix: true);
  }
}
