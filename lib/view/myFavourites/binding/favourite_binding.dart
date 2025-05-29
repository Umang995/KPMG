
import 'package:dreamcast/view/myFavourites/controller/favourite_controller.dart';
import 'package:get/get.dart';

import '../../home/controller/for_you_controller.dart';

class FavouriteDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ForYouController>(ForYouController());
    Get.put<FavouriteController>(FavouriteController());
  }
}
