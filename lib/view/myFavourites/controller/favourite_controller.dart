import 'package:dreamcast/view/myFavourites/controller/favourite_boot_controller.dart';
import 'package:dreamcast/view/myFavourites/controller/favourite_session_controller.dart';
import 'package:dreamcast/view/myFavourites/controller/favourite_speaker_controller.dart';
import 'package:dreamcast/view/myFavourites/controller/favourite_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/my_constant.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../schedule/controller/session_controller.dart';

class FavouriteController extends GetxController {
  late final AuthenticationManager _authManager;
  AuthenticationManager get authManager => _authManager;

  final tabIndex = 0.obs;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final String title = 'home_title'.tr;
  var loading = false.obs;
  var isFirstLoading = false.obs;
  var tabList = <String>[].obs;


  final textController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    _authManager = Get.find();
    createTab();
    initController();
  }

  Future<void> initController() async {
    Get.lazyPut(() => FavUserController(), fenix: true);
    Get.lazyPut(() => FavSessionController(), fenix: true);
    Get.lazyPut(() => FavSpeakerController(), fenix: true);
    Get.lazyPut(() => FavBootController(), fenix: true);
    Get.lazyPut(() => SessionController(), fenix: true);
  }

  Future<void> createTab() async {
    tabList.clear();
    tabList.add("attendee".tr);
    tabList.add("allSession".tr);
    tabList.add("speakers".tr);
    tabList.add("exhibitors".tr);
  }

  tabIndexAndSearch(bool isRefresh) {
    switch (tabIndex.value) {
      case 0:
        if (Get.isRegistered<FavUserController>()) {
          FavUserController controller = Get.find();
          controller.getApiData();
        }
        break;
      case 1:
        if (Get.isRegistered<FavSessionController>()) {
          FavSessionController controller = Get.find();
          controller.getApiData();
        }
        break;
      case 2:
        if (Get.isRegistered<FavSpeakerController>()) {
          FavSpeakerController controller = Get.find();
          controller.getApiData();
        }

        break;
      case 3:
        if (Get.isRegistered<FavBootController>()) {
          FavBootController controller = Get.find();
          controller.getApiData();
        }
        break;
    }
  }
}
