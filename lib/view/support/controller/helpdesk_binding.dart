import 'package:dreamcast/view/account/controller/account_controller.dart';
import 'package:dreamcast/view/quiz/controller/feedbackController.dart';
import 'package:dreamcast/view/support/controller/faq_controller.dart';
import 'package:dreamcast/view/support/controller/helpdesk_dashboard_controller.dart';
import 'package:dreamcast/view/support/controller/supportController.dart';
import 'package:get/get.dart';

import '../../guide/controller/info_guide_controller.dart';

class HelpDeskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HelpdeskDashboardController());
    Get.lazyPut(() => SupportController(),fenix: true);
    Get.lazyPut(() => SOSFaqController(),fenix: true);
  }
}
