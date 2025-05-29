import 'dart:convert';

import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/breifcase/model/BriefcaseModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../commonController/bookmark_request_model.dart';
import '../../exhibitors/model/bookmark_common_model.dart';
import '../../myFavourites/model/BookmarkIdsModel.dart';
import '../model/common_document_request.dart';

class CommonDocumentController extends GetxController {
  var loading = false.obs;
  var isFirstLoadRunning = false.obs;
  var isBookmarkLoading = false.obs;

  var resourceCenterList = <DocumentData>[].obs;
  var launchpadResCenterList = <DocumentData>[].obs;

  var resourceCenterBookIds = <String>[].obs;
  var bannerList = <DocumentData>[].obs;
  var sessionBannerList = <DocumentData>[].obs;

  var briefcaseList = <DocumentData>[].obs;

  //used for match the ids to user ids
  var bookMarkIdsList = <dynamic>[].obs;
  var briefcaseIdsList = [];
  var isMoreData = false.obs;

  final AuthenticationManager authenticationManager =
      Get.find<AuthenticationManager>();

  @override
  void onInit() {
    super.onInit();
    if (authenticationManager.isLogin()) {
      getDocumentList(isRefresh: false, limitedMode: false);
    }
  }

  ///get the list of resource center

  Future<void> getDocumentList(
      {required bool isRefresh, bool? limitedMode}) async {
    resourceCenterBookIds.clear();
    if (!isRefresh) {
      isFirstLoadRunning(true);
    }
    if (limitedMode == true) {
      final model = ParentCommonDocumentModel.fromJson(json.decode(
        await apiService.dynamicPostRequest(
            body: CommonDocumentRequest(
                itemId: "",
                itemType: "event",
                favourite: 0,
                limitedMode: limitedMode),
            url: AppUrl.getCommonDocument),
      ));
      isFirstLoadRunning(false);
      if (model.status! && model.code == 200) {
        launchpadResCenterList.clear();
        bookMarkIdsList.clear();
        launchpadResCenterList.addAll(model.body?.items ?? []);
        resourceCenterBookIds
            .addAll(launchpadResCenterList.map((obj) => obj.id ?? ""));
        isMoreData(model.body?.hasNextPage ?? false);
        if (resourceCenterBookIds.isNotEmpty) {
          getBookmarkIds();
        }
      } else {
        print(model.code.toString());
      }
    } else {
      final model = CommonDocumentModel.fromJson(json.decode(
        await apiService.dynamicPostRequest(
            body: CommonDocumentRequest(
                itemId: "",
                itemType: "event",
                favourite: 0,
                limitedMode: limitedMode),
            url: AppUrl.getCommonDocument),
      ));

      isFirstLoadRunning(false);
      if (model.status! && model.code == 200) {
        resourceCenterList.clear();
        bookMarkIdsList.clear();
        resourceCenterList.addAll(model.body ?? []);
        resourceCenterBookIds
            .addAll(resourceCenterList.map((obj) => obj.id ?? ""));
        if (resourceCenterBookIds.isNotEmpty) {
          getBookmarkIds();
        }
      } else {
        print(model.code.toString());
      }
    }
  }

  Future<void> getBookmarkIds() async {
    if (!authenticationManager.isLogin()) {
      return;
    }
    try {
      isBookmarkLoading(true);

      final model = BookmarkIdsModel.fromJson(json.decode(
        await apiService.dynamicPostRequest(body: {
          "items": resourceCenterBookIds,
          "item_type": MyConstant.document
        }, url: AppUrl.commonListByItemIds),
      ));
      isBookmarkLoading(false);
      if (model.status! && model.code == 200) {
        bookMarkIdsList.addAll(model.body!
            .where((obj) => obj.favourite != null && obj.favourite!.isNotEmpty)
            .map((obj) => obj.id)
            .toList());
      }
    } catch (exception) {
      isBookmarkLoading(false);
    }
  }

  ///get the list of resource center
  Future<void> getBriefcaseList({required bool isRefresh}) async {
    if (!isRefresh) {
      isFirstLoadRunning(true);
    }

    final model = CommonDocumentModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: CommonDocumentRequest(
              itemId: "", itemType: "event", favourite: 1),
          url: AppUrl.getCommonDocument),
    ));

    isFirstLoadRunning(false);
    if (model.status! && model.code == 200) {
      briefcaseList.clear();
      briefcaseList.addAll(model.body ?? []);
      bookMarkIdsList.addAll(model.body!.map((obj) => obj.id).toList());
    } else {
      print(model.code.toString());
    }
  }

  ///get the list of banner list
  Future<void> getBannerList(
      {required String itemId, required String itemType}) async {
    isFirstLoadRunning(true);

    final model = CommonDocumentModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: CommonDocumentRequest(itemId: itemId, itemType: itemType ?? ""),
          url: AppUrl.getCommonDocument),
    ));

    isFirstLoadRunning(false);

    if (model.status! && model.code == 200) {
      switch (itemType) {
        case "home_banner":
          bannerList.clear();
          bannerList.addAll(model.body ?? []);
          break;
        case "webinar_banner":
          sessionBannerList.clear();
          sessionBannerList.addAll(model.body ?? []);
          break;
      }
    }
  }

  var isFavLoading = false.obs;

  ///used for the the bookmark to item of every type
  Future<Map> bookmarkToItem(
      {required BookmarkRequestModel requestBody}) async {
    var requestResponse = {};

    final model = BookmarkCommonModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: requestBody, url: AppUrl.commonBookmarkApi),
    ));

    if (model.status! && model.code == 200) {
      if (model.body?.id != null && model.body!.id!.isNotEmpty) {
        requestResponse = {"item_id": requestBody.itemId, "status": true};
      } else {
        requestResponse = {"item_id": requestBody.itemId, "status": false};
      }
    }
    return requestResponse;
  }

  Future<List<dynamic>> getCommonBookmarkIds({required items, itemType}) async {
    var bookMarkIdsList = [];
    if (items.isEmpty || !authenticationManager.isLogin()) {
      return bookMarkIdsList;
    }
    try {
      final model = BookmarkIdsModel.fromJson(json.decode(
        await apiService.dynamicPostRequest(
            body: {"items": items, "item_type": itemType},
            url: AppUrl.commonListByItemIds),
      ));

      if (model.status! && model.code == 200) {
        bookMarkIdsList.clear();
        bookMarkIdsList.addAll(
          model.body!
              .where((obj) =>
                  obj.favourite?.isNotEmpty ==
                  true) // Apply the where condition here
              .map((obj) => obj.id) // Map to the id
              .toList(),
        );
      }
      return bookMarkIdsList;
    } catch (exception) {
      print("@@ exception found");
      return bookMarkIdsList;
    }
  }

  ///get the block  list of user by ids
  Future<bool> getBlockListByIds(
      {required List<dynamic> items, String? itemType}) async {
    if (items.isEmpty) return false;

    try {
      final model = BookmarkIdsModel.fromJson(json.decode(
        await apiService.dynamicPostRequest(
            body: {"items": items}, url: AppUrl.blockListByItemIds),
      ));

      if (model?.status == true && model?.code == 200) {
        final body = model?.body;
        if (body != null && body.isNotEmpty) {
          final isBlockedList = body.first.isBlocked;
          return isBlockedList != null && isBlockedList.isNotEmpty;
        }
      }
    } catch (exception) {
      return false;
      // Handle exceptions if necessary, e.g., logging
    }

    return false;
  }

  @override
  void dispose() {
    super.dispose();
    loading(false);
  }
}
