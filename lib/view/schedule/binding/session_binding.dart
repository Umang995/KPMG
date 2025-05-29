import 'package:dreamcast/view/speakers/controller/speakersController.dart';
import 'package:get/get.dart';
import '../../myFavourites/controller/favourite_speaker_controller.dart';
import '../controller/session_controller.dart';

class SessionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SessionController());
    Get.lazyPut(() => SpeakersDetailController(),fenix: true);
    Get.lazyPut(() => FavSpeakerController(),fenix: true);
  }
}
