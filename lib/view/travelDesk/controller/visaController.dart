import 'dart:convert';
import 'dart:io';

import 'package:dreamcast/api_repository/api_service.dart';
import 'package:dreamcast/api_repository/app_url.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/file_manager.dart';
import 'package:dreamcast/utils/pref_utils.dart';
import 'package:dreamcast/view/home/screen/pdfViewer.dart';
import 'package:dreamcast/view/travelDesk/model/travelCabGetModel.dart';
import 'package:dreamcast/view/travelDesk/model/travelFlightGetModel.dart';
import 'package:dreamcast/view/travelDesk/model/travelHotelGetModel.dart';
import 'package:dreamcast/view/travelDesk/model/travelPassportGetModel.dart';
import 'package:dreamcast/view/travelDesk/model/travelVisaGetModel.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class VisaController extends GetxController {

  var loader = true.obs;

  @override
  void onInit() {
    super.onInit();
    callApi(false);
  }

  ///****** call Apis ********///
  Future<void> callApi(bool isRefresh)async{
    await travelVisaGetApi(requestBody: {}, isRefresh: isRefresh);
  }


  var travelVisaDetails = TravelVisaGetModel().obs;

  ///*********** Travel Visa get Api **************///
  Future<void> travelVisaGetApi(
      {required requestBody, required bool isRefresh}) async {
    try{
      loader(isRefresh ? false : true);
      var response = await apiService.dynamicGetRequest(
          url: "${AppUrl.passportApi}/getVisa");

      TravelVisaGetModel? model = TravelVisaGetModel.fromJson(json.decode(response));
      if (model.status! && model.code == 200) {
        travelVisaDetails(model);
      }
      loader(false);
    } on SocketException {
      loader(false);
    }catch(e){
      loader(false);
      rethrow ;
    }
  }


}