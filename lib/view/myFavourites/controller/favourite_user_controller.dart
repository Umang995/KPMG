import 'dart:convert';

import 'package:dreamcast/view/myFavourites/controller/favourite_controller.dart';
import 'package:dreamcast/view/myFavourites/model/bookmark_speaker_model.dart';
import 'package:dreamcast/view/representatives/request/network_request_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../routes/my_constant.dart';
import '../../representatives/controller/user_detail_controller.dart';
import '../../representatives/model/user_model.dart';

class FavUserController extends GetxController {
  var favouriteAttendeeList = <Representatives>[].obs;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  NetworkRequestModel networkRequestModel = NetworkRequestModel();
  var loading = false.obs;
  var isFirstLoading = false.obs;

  FavouriteController favouriteController = Get.find();
  late UserDetailController userController;

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<UserDetailController>()) {
      userController = Get.find();
    } else {
      userController = Get.put(UserDetailController());
    }
    getApiData();
  }

  getApiData() async {
    ///its a initial request for the get the data
    networkRequestModel = NetworkRequestModel(
        role: MyConstant.networking,
        page: 1,
        favorite: 1,
        filters: RequestFilters(
            text: favouriteController.textController.value.text.trim(),
            isBlocked: false,
            sort: "ASC",
            notes: false,
            params: {}));
    getBookmarkUser();
  }

  Future<void> getBookmarkUser() async {
    userController.isBookmarkLoaded(true);
    isFirstLoading(true);
    final model = RepresentativeModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: networkRequestModel,
        url: "${AppUrl.usersListApi}/search",
      ),
    ));
    userController.isBookmarkLoaded(false);
    if (model.status! && model.code == 200) {
      favouriteAttendeeList.clear();
      favouriteAttendeeList.addAll(model.body!.representatives ?? []);
      userController.bookMarkIdsList.clear();
      userController.bookMarkIdsList
          .addAll(favouriteAttendeeList.map((obj) => obj.id).toList());
    } else {
      print(model.code.toString());
    }
    isFirstLoading(false);
  }
}
