import 'dart:convert';

import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/partners/model/homeSponsorsPartnersListModel.dart';
import 'package:dreamcast/view/partners/model/AllSponsorsPartnersListModel.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';

class SponsorPartnersController extends GetxController {
  var isLoading = false.obs;
  var isMoreData = false.obs;
  final AuthenticationManager _manager = Get.find();

  @override
  void onInit() {
    homeSponsorsPartnersListApi(
        requestBody: {"limited_mode": true}, isRefresh: false);
    super.onInit();
  }

  var sponsorsLoader = false.obs;
  List<Items> homeSponsorsList = <Items>[].obs;

  ///*********** Home Sponsors Partners list Api **************///
  Future<void> homeSponsorsPartnersListApi(
      {required requestBody, required bool isRefresh}) async {
    /*if(!_manager.isLogin()){
      return;
    }*/
    if (isRefresh) {
      sponsorsLoader(true);
    }

    final model = HomeSponsorsPartnerListModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: requestBody,
        url: AppUrl.getPartnerList,
      ),
    ));

    sponsorsLoader(false);
    if (model.status! && model.code == 200) {
      isMoreData(model.body?.hasNextPage ?? false);
      homeSponsorsList.clear();
      homeSponsorsList.addAll(model.body?.items ?? []);
      update();
    }
  }

  List<PartnerData> allSponsorsList = <PartnerData>[].obs;

  ///*********** Home Sponsors Partners list Api **************///
  Future<void> allSponsorsPartnersListApi(
      {required requestBody, required bool isRefresh}) async {
    if (isRefresh) {
      sponsorsLoader(true);
    }

    final model = AllSponsorsPartnerListModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: requestBody,
        url: AppUrl.getPartnerList,
      ),
    ));

    sponsorsLoader(false);
    if (model.status! && model.code == 200) {
      allSponsorsList.clear();
      allSponsorsList.addAll(model.body ?? []);
      update();
    }
  }

  Future<void> userLogActivity({jsonRequest}) async {
    try {
      dynamic response = await apiService.dynamicPostRequest(
          url: AppUrl.userLogActivity, body: jsonRequest);
      if (response != null) {
        print("User Log Activity: $response");
      }
    } catch (e) {}
  }
}
