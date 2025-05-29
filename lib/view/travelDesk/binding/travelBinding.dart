import 'package:dreamcast/view/speakers/controller/speakerNetworkController.dart';
import 'package:dreamcast/view/travelDesk/controller/cabController.dart';
import 'package:dreamcast/view/travelDesk/controller/flightController.dart';
import 'package:dreamcast/view/travelDesk/controller/travelSaveFormController.dart';
import 'package:dreamcast/view/travelDesk/controller/hotelController.dart';
import 'package:dreamcast/view/travelDesk/controller/passportController.dart';
import 'package:dreamcast/view/travelDesk/controller/travelDeskController.dart';
import 'package:dreamcast/view/travelDesk/controller/visaController.dart';
import 'package:get/get.dart';

class TravelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TravelDeskController(),fenix: true);
    Get.lazyPut(() => FlightController(),fenix: true);
    Get.lazyPut(() => CabController(),fenix: true);
    Get.lazyPut(() => HotelController(),fenix: true);
    Get.lazyPut(() => VisaController(),fenix: true);
    Get.lazyPut(() => PassportController(),fenix: true);
    Get.lazyPut(() => TravelSaveFormController(),fenix: true);
  }
}
