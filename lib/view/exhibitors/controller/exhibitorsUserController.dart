import 'dart:convert';

import 'package:dreamcast/api_repository/app_url.dart';
import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/view/Notes/controller/my_notes_controller.dart';
import 'package:dreamcast/view/breifcase/controller/common_document_controller.dart';
import 'package:dreamcast/view/breifcase/model/common_document_request.dart';
import 'package:dreamcast/view/commonController/bookmark_request_model.dart';
import 'package:dreamcast/view/exhibitors/controller/exhibitorsController.dart';
import 'package:dreamcast/view/exhibitors/model/exibitors_detail_model.dart';
import 'package:dreamcast/view/myFavourites/controller/favourite_boot_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../model/common_model.dart';
import '../../../theme/ui_helper.dart';
import '../../Notes/model/common_notes_model.dart';
import '../../breifcase/model/BriefcaseModel.dart';
import '../../myFavourites/model/BookmarkIdsModel.dart';
import '../../representatives/model/user_count_model.dart';
import '../../representatives/model/save_notes_model.dart';
import '../model/exhibitorTeamModel.dart';
import '../model/exhibitors_filter_model.dart';
import '../model/exibitorsModel.dart';
import '../model/product_detail_model.dart';
import '../model/product_list_model.dart';
import '../request_model/request_model.dart';
import '../view/document_list_page.dart';
import '../view/exhibitors_details_page.dart';
import '../view/video_list_page.dart';

class BootUserController extends GetxController {
  late bool hasNextPage = false;

  var isFirstLoadRunning = false.obs;
  var isLoading = false.obs;
  var isFavLoading = false.obs;

  var isLoadMoreRunning = false.obs;

  ScrollController scrollController = ScrollController();

  var representativesList = <dynamic>[].obs;

  var repListCount = 0.obs;

  dynamic requestBodyForUser = {};

  //list of ids to send to check the bookmark
  var userIdsList = <dynamic>[];
  //used for match the ids to user ids

  ScrollController userScrollController = ScrollController();
  BoothController bootController = Get.find();

  ///used for the filter data
  @override
  void onInit() {
    super.onInit();
    getExhibitorUser(
        limited: true,
        requestBody: {"id": bootController.exhibitorsBody.value.id});
  }

  ///load Representatives list by exhibitor.json id
  Future<void> getExhibitorUser(
      {required requestBody, required limited}) async {
    requestBodyForUser = requestBody;

    final model = ExhibitorTeamListModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: requestBody,
        url: limited == true
            ? "${AppUrl.exhibitorsListApi}/representatives"
            : "${AppUrl.exhibitorsListApi}/getAllRepresentatives",
      ),
    ));
    if (model.status! && model.code == 200) {
      representativesList.value = model.body?.representatives ?? [];
      if (limited == true) {
        repListCount(model.body?.itemCount ?? 0);
      } else {
        hasNextPage = model.body!.hasNextPage!;
        loadMoreAttendee();
      }
    } else {
      update();
      representativesList.clear();
    }
  }

  ///add pagination for exhibitor team
  Future<void> loadMoreAttendee() async {
    userScrollController.addListener(() async {
      if (hasNextPage == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunning.value == false &&
          userScrollController.position.maxScrollExtent ==
              userScrollController.position.pixels) {
        isLoadMoreRunning(true);
        requestBodyForUser["page"] = requestBodyForUser["page"] + 1;
        try {
          final model = ExhibitorTeamListModel.fromJson(json.decode(
            await apiService.dynamicPostRequest(
              body: requestBodyForUser,
              url: "${AppUrl.exhibitorsListApi}/getAllRepresentatives",
            ),
          ));

          if (model.status! && model.code == 200) {
            hasNextPage = model.body!.hasNextPage!;
            requestBodyForUser["page"] = requestBodyForUser["page"] + 1;
            representativesList.addAll(model.body!.representatives!);
            update();
          }
        } catch (e) {
          print(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }
}
