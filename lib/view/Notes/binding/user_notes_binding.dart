import 'package:dreamcast/view/Notes/controller/my_notes_controller.dart';
import 'package:dreamcast/view/representatives/controller/user_detail_controller.dart';
import 'package:get/get.dart';
/// A binding class for the SpeakerScreen.
///
/// This class ensures that the SpeakerController is created when the
/// SpeakerScreen is first loaded.
class UserNotesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserDetailController(),fenix: true);
    Get.lazyPut(() => MyNotesController(),fenix: true);
  }
}
