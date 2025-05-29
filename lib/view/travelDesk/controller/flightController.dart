import 'dart:convert';
import 'dart:io';
import 'package:dreamcast/api_repository/api_service.dart';
import 'package:dreamcast/api_repository/app_url.dart';
import 'package:dreamcast/view/travelDesk/model/travelFlightGetModel.dart';
import 'package:get/get.dart';

class FlightController extends GetxController {
  var loader = false.obs;
  var travelFlightDetails = TravelFlightGetModel().obs;

  @override
  void onInit() {
    super.onInit();
    travelFlightGetApi(requestBody: {}, isRefresh: false);
  }

  ///*********** Travel Flight get Api **************///
  Future<void> travelFlightGetApi(
      {required requestBody, required bool isRefresh}) async {
    try {
      loader(isRefresh ? false : true);
      var response = await apiService.dynamicPostRequest(
          body: requestBody,
          url: AppUrl.travelFlightGet);
      TravelFlightGetModel? model = TravelFlightGetModel.fromJson(json.decode(response));
      if (model.status! && model.code == 200) {
        travelFlightDetails(model);
      }
      loader(false);
    } on SocketException {
      loader(false);
    } catch (e) {
      loader(false);
      rethrow;
    }
  }
}
