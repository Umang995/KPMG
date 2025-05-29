import 'package:dreamcast/view/meeting/controller/meetingController.dart';
import 'package:get/get.dart';


class MeetingDashboardBinding extends Bindings {
  @override
  void dependencies() {
    //Get.put<UserDetailController>(UserDetailController());
    Get.put<MeetingController>(MeetingController());
    /*this is used for the reschedule the meeting*/

  }
}
