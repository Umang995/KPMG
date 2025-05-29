
import 'package:dreamcast/view/partners/controller/partnersController.dart';
import 'package:get/get.dart';

class SponsorPartnerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SponsorPartnersController());
  }
}
