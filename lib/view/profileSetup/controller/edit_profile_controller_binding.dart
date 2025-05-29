import 'package:dreamcast/view/profileSetup/controller/profileSetupController.dart';
import 'package:get/get.dart';

class EditProfileControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileController());
  }
}
