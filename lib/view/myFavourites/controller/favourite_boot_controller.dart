import 'dart:convert';

import 'package:dreamcast/api_repository/app_url.dart';
import 'package:dreamcast/view/exhibitors/model/exibitorsModel.dart';
import 'package:dreamcast/view/exhibitors/request_model/request_model.dart';
import 'package:dreamcast/view/myFavourites/controller/favourite_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../routes/my_constant.dart';
import '../../exhibitors/controller/exhibitorsController.dart';

class FavBootController extends GetxController {
  var favouriteBootList = <Exhibitors>[].obs;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  var loading = false.obs;
  var isFirstLoading = false.obs;
  FavouriteController favouriteController = Get.find();
  BootRequestModel bootRequestModel = BootRequestModel();
  final exhibitorsController = Get.put(BoothController());

  @override
  void onInit() {
    super.onInit();
    getApiData();
  }

  getApiData() async {
    bootRequestModel = BootRequestModel(
        favourite: 1,
        filters: RequestFilters(
            text: favouriteController.textController.value.text.trim() ?? "",
            sort: "ASC",
            notes: false),
        page: 1);
    getBookmarkExhibitor();
  }

  Future<void> getBookmarkExhibitor() async {
    exhibitorsController.isBookmarkLoaded(true);
    isFirstLoading(true);

    final model = ExhibitorsModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(body: bootRequestModel,
        url: "${AppUrl.exhibitorsListApi}/search",),
    ));

    exhibitorsController.isBookmarkLoaded(false);
    if (model.status! && model.code == 200) {
      favouriteBootList.clear();
      favouriteBootList.value = model.body!.exhibitors ?? [];
      exhibitorsController.bookMarkIdsList.clear();
      exhibitorsController.bookMarkIdsList
          .addAll(favouriteBootList.map((obj) => obj.id).toList());
    } else {
      print(model.code.toString());
    }
    isFirstLoading(false);
  }
}
