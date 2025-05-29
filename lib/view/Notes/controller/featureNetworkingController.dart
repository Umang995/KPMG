import 'dart:convert';

import 'package:dreamcast/view/representatives/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../routes/my_constant.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../myFavourites/model/BookmarkIdsModel.dart';
import '../../representatives/controller/user_detail_controller.dart';
import '../../representatives/model/user_filter_model.dart';

class FeatureNetworkingController extends GetxController {
  late final AuthenticationManager _authenticationManager;
  AuthenticationManager get authenticationManager => _authenticationManager;

  late bool hasNextPage;
  late int _pageNumber;
  var isFirstLoading = false.obs;
  var isLoading = false.obs;
  var isFavLoading = false.obs;
  var isLoadMoreRunning = false.obs;

  final textController = TextEditingController().obs;

  ScrollController scrollControllerAttendee = ScrollController();

  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  ItemScrollController itemScrollController = ItemScrollController();

  var attendeeList = <Representatives>[].obs;
  var userFilterBody = UserBodyFilter().obs;

  var role = MyConstant.attendee;
  //extra field.
  var selectedSort = "ASC".obs;
  var isNotesFilter = false.obs;
  var isBlockedFilter = false.obs;

  dynamic newRequestBody = {};

  TextEditingController searchController = TextEditingController();

  UserDetailController userDetailController = Get.find();

  //used for match the ids to user ids
  var bookMarkIdsList = <dynamic>[].obs;
  var recommendedIdsList = <dynamic>[].obs;
  var userIdsList = <dynamic>[];

  @override
  void onInit() {
    _authenticationManager = Get.find();
    _pageNumber = 0;
    hasNextPage = false;
    super.onInit();
    attendeeAPiCall(isRefresh: true);
  }

  //its used for the binding the other controller.
  Future<void> bindingController() async {}

  Future<void> attendeeAPiCall({required isRefresh}) async {
    await getAttendeeList(requestBody: {
      "page": "1",
      "role": MyConstant.attendee,
      "filters": {
        "text": "",
        "is_blocked": isBlockedFilter.value,
        "notes": false,
        "sort": "ASC",
        "params": {"featured": true}
      }
    }, isRefresh: isRefresh);
  }

  Future<void> getAttendeeList(
      {required requestBody, required isRefresh}) async {
    newRequestBody = requestBody;
    isFirstLoading(isRefresh);
    final model = RepresentativeModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: requestBody,
        url: "${AppUrl.usersListApi}/search",
      ),
    ));
    if (model.status! && model.code == 200) {
      clearDefaultList();
      attendeeList.clear();
      attendeeList.addAll(model.body!.representatives!);
      userIdsList.clear();
      userIdsList
          .addAll(model.body!.representatives!.map((obj) => obj.id).toList());
      hasNextPage = model.body?.hasNextPage ?? false;
      getBookmarkAndRecommendedByIds();
      _pageNumber = 2;
      _azLoadMore();
      isFirstLoading(false);
    } else {
      isFirstLoading(false);
    }
  }

  Future<void> _azLoadMore() async {
    itemPositionsListener.itemPositions.addListener(() async {
      final positions = itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        final lastVisibleIndex = positions
            .where((element) => element.itemTrailingEdge <= 1)
            .reduce((max, element) =>
                max.itemTrailingEdge > element.itemTrailingEdge ? max : element)
            .index;

        if (hasNextPage == true &&
            isFirstLoading.value == false &&
            isLoadMoreRunning.value == false &&
            lastVisibleIndex >= attendeeList.length - 5) {
          // Load more when close to the end
          isLoadMoreRunning(true);
          newRequestBody["page"] = _pageNumber.toString();
          try {

            final model = RepresentativeModel.fromJson(json.decode(
              await apiService.dynamicPostRequest(
                body: newRequestBody,
                url: "${AppUrl.usersListApi}/search",
              ),
            ));

            if (model.status! && model.code == 200) {
              hasNextPage = model.body!.hasNextPage!;
              _pageNumber = _pageNumber + 1;
              attendeeList.addAll(model.body!.representatives!);
              userIdsList.clear();
              if (model.body!.representatives != null &&
                  model.body!.representatives!.isNotEmpty) {
                userIdsList.addAll(
                    model.body!.representatives!.map((obj) => obj.id).toList());
              }
              getBookmarkAndRecommendedByIds();
              update();
            }
          } catch (e) {
            print(e.toString());
          }
          isLoadMoreRunning(false);
        }
      }
    });
  }

  Future<void> getBookmarkAndRecommendedByIds() async {
    getBookmarkIds();
    getRecommendedIds();
  }

  ///get bookmark Ids
  Future<void> getBookmarkIds() async {
    try {
      if (userIdsList.isEmpty || !authenticationManager.isLogin()) {
        return;
      }

      final model = BookmarkIdsModel.fromJson(json.decode(
        await apiService.dynamicPostRequest(
            body: {"items": userIdsList, "item_type": MyConstant.attendee},
            url: AppUrl.commonListByItemIds),
      ));

      if (model.status! && model.code == 200) {
        if (model.body != null) {
          bookMarkIdsList.addAll(model.body!.map((obj) => obj.id).toList());
        }
      } else {
        print(model.code.toString());
      }
    } catch (exception) {
      debugPrint("exception ${exception.toString()}");
    } finally {
      // Code here will run whether or not an exception was thrown
      debugPrint("Completed the process of fetching bookmark IDs");
    }
  }

  ///get getRecommendedIds
  Future<void> getRecommendedIds() async {
    try {
      if (userIdsList.isEmpty) {
        return;
      }
      final model = BookmarkIdsModel.fromJson(json.decode(
        await apiService.dynamicPostRequest(
            body: {"users": userIdsList},
            url: "${AppUrl.usersListApi}/getAiRecommended"),
      ));
      if (model.status! && model.code == 200) {
        // Extract the list from the body and filter items with recommended == true
        if (model.body != null) {
          recommendedIdsList.addAll(model.body!
              .where((item) => item.isRecommended == true)
              .map((item) => item.id)
              .toList());
        }
      } else {
        print(model.code.toString());
        return;
      }
    } catch (exception) {
      debugPrint(exception.toString());
    } finally {
      // Code here will run whether or not an exception was thrown
      debugPrint("Completed the process of fetching recommended IDs");
    }
  }

  clearDefaultList() {
    bookMarkIdsList.clear();
    recommendedIdsList.clear();
  }
}
