import 'dart:convert';
import 'dart:io';

import 'package:dreamcast/api_repository/api_service.dart';
import 'package:dreamcast/api_repository/app_url.dart';
import 'package:dreamcast/view/travelDesk/controller/passportController.dart';
import 'package:dreamcast/view/travelDesk/controller/visaController.dart';
import 'package:dreamcast/view/travelDesk/model/flightFieldModule.dart';
import 'package:dreamcast/view/travelDesk/model/getAirportsModel.dart';
import 'package:dreamcast/view/travelDesk/model/travelSaveModel.dart';
import 'package:dreamcast/view/travelDesk/view/travelSaveFormPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/dialog/custom_animated_dialog_widget.dart';
import 'flightController.dart';

class TravelSaveFormController extends GetxController {
  // Observable list to store flight fields
  var formFieldData = <FlightFields>[].obs;
  var airportsListData = <AirportsDetails>[].obs;
  var selectedItem = "".obs;
  var filteredItems = <AirportsDetails>[].obs;
  TextEditingController searchControllerArrival = TextEditingController();
  TextEditingController searchControllerDeparture = TextEditingController();
  var showSearchArrivalResults = false.obs;
  var showSearchDepartureResults = false.obs;

  final TextEditingController pdfPath = TextEditingController();
  FlightController flightController = Get.find();
  VisaController visaController = Get.find();
  PassportController passportController = Get.find();

  var loader = false.obs;
  var buttonLoading = false.obs;

  var showArrivalFields = false.obs;
  var showDepartureFields = false.obs;
  var buttonEnabled = false.obs;

  var type = "";
  var toolbarTitle = ""; // ✅ Made observable for UI updates

  @override
  void onInit() {
    super.onInit();
    type = Get.arguments?['type'] ?? ""; // ✅ Safe null check using `?`
    print("type: $type");
    if (type.isNotEmpty) {
      fetchFormFields(type);
    }
  }

  void toggleArrivalSearch(bool state) {
    showSearchArrivalResults.value = state;
    if (state) {
      filteredItems.value = List.from(airportsListData);
    }
  }

  void toggleDepartureSearch(bool state) {
    showSearchDepartureResults.value = state;
    if (state) {
      filteredItems.value = List.from(airportsListData);
    }
  }

  void selectArrivalAirport(String name) {
    searchControllerArrival.text = name;
    showSearchArrivalResults.value = false;
  }

  void selectDepartureAirport(String name) {
    searchControllerDeparture.text = name;
    showSearchDepartureResults.value = false;
  }

  /// ✅ Fetches form fields based on the provided `slug`
  void fetchFormFields(String slug) {
    final Map<String, String> slugToUrl = {
      MyConstant.flightArrival: AppUrl.travelFlightFormFieldArrival,
      MyConstant.flightDeparture: AppUrl.travelFlightFormFieldDeparture,
      MyConstant.passport: "${AppUrl.passportApi}/getProfileFields",
      MyConstant.visa: "${AppUrl.passportApi}/getVisaFields",
    };
    final Map<String, String> titleMap = {
      MyConstant.flightArrival: "addArrivalDetails".tr,
      MyConstant.flightDeparture: "addDepartureDetails".tr,
      MyConstant.passport: "addPassportDetails".tr,
      MyConstant.visa: "addVisaDetails".tr,
    };
    if (slugToUrl.containsKey(slug)) {
      toolbarTitle = titleMap[slug] ?? "";
      getFormFields(url: slugToUrl[slug]!);
      getAirports();
    }
  }

  /// ✅ Calls the API to retrieve form fields and updates the state
  Future<void> getFormFields({required String url}) async {
    print("url: $url");
    try {
      loader(true); // Show loader
      var response = await apiService.dynamicGetRequest(url: url);
      FlightFieldModel? model =
          FlightFieldModel.fromJson(json.decode(response));
      // Hide loader
      if (model?.status == true && model?.code == 200) {
        formFieldData.assignAll(model!.body ?? []);
        print("Form Field Data: ${formFieldData.length}");
      }
      loader(false);
    } on SocketException {
      Get.snackbar(
          "Error", "No internet connection"); // ✅ User-friendly error message
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      // loader(false); // ✅ Ensures loader is turned off in all cases
    }
  }

  callSaveFormApi() {
    if (type == MyConstant.flightArrival ||
        type == MyConstant.flightDeparture) {
      saveCommonTravelData(AppUrl.saveFlightDetails);
    } else if (type == MyConstant.passport) {
      saveCommonTravelData("${AppUrl.passportApi}/save");
    } else if (type == MyConstant.visa) {
      saveCommonTravelData("${AppUrl.passportApi}/saveVisa");
    }
  }

  ///*********** Save Flight Details **************///
  Future<void> saveCommonTravelData(String url) async {
    final Map<String, String> getTypeBySlug = {
      MyConstant.flightArrival: "arrival",
      MyConstant.flightDeparture: "departure",
    };
    var formData = <String, dynamic>{};
    int count = 0;
    for (int index = 0; index < formFieldData.length; index++) {
      var mapList = [];
      var data = formFieldData[index];
      if (data.value != null && data.value!.isNotEmpty) {
        if (data.value is List) {
          for (int cIndex = 0; cIndex < data.value!.length; cIndex++) {
            mapList.add(data.value?[cIndex]);
          }
          formData["${data.name}"] = mapList;
        } else {
          formData["${data.name}"] = data.value.toString();
        }
      } else {
        formData["${data.name}"] = data.value ?? "";
        if (data.rules == "required") {
          count = count + 1;
        }
      }
    }
    if (type == MyConstant.flightArrival ||
        type == MyConstant.flightDeparture) {
      formData["type"] = getTypeBySlug[type]; //arrival or departure
    }
    debugPrint("Form Data: ${jsonEncode(formData)}");
    if (count > 0) {
      UiHelper.showFailureMsg(null, "select_required_field".tr);
      return;
    }
    try {
      buttonLoading(true);
      dynamic response = await apiService.commonMultipartAPi(
          requestBody: formData, url: url, formFieldData: formFieldData);
      TravelSaveModel model = TravelSaveModel.fromJson(response);
      buttonLoading(false);
      if (model.status! && model.code == 200) {
        await Get.dialog(
            barrierDismissible: false,
            CustomAnimatedDialogWidget(
              title: "success_action".tr,
              logo: ImageConstant.icSuccessAnimated,
              description: model.body?.message ?? "",
              buttonAction: "okay".tr,
              buttonCancel: "cancel".tr,
              isHideCancelBtn: true,
              onCancelTap: () {},
              onActionTap: () async {
                switch (type) {
                  case MyConstant.flightArrival:
                    flightController
                        .travelFlightGetApi(requestBody: {}, isRefresh: false);
                    break;
                  case MyConstant.flightDeparture:
                    flightController
                        .travelFlightGetApi(requestBody: {}, isRefresh: false);
                    break;
                  case MyConstant.visa:
                    visaController
                        .travelVisaGetApi(requestBody: {}, isRefresh: false);
                    break;
                  case MyConstant.passport:
                    passportController
                        .travelPassportGetApi(requestBody: {}, isRefresh: false);
                    break;
                }
                Get.back();
              },
            ));
      }
      buttonLoading(false);
    } on SocketException {
      buttonLoading(false);
    } catch (e) {
      buttonLoading(false);
      rethrow;
    }
  }

  Future<void> getAirports() async {
    try {
      loader(true); // Show loader
      final response =
          await apiService.dynamicGetRequest(url: AppUrl.getAirports);
      GetAirportsModel? model =
          GetAirportsModel.fromJson(json.decode(response));

      if (model?.status == true && model?.code == 200) {
        airportsListData.assignAll(model!.body ?? []);
      }
    } on SocketException {
      Get.snackbar("Error", "No internet connection");
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      loader(false);
    }
  }

  /// ✅ Dispose controllers to prevent memory leaks
  @override
  void onClose() {
    pdfPath.dispose();
    super.onClose();
  }

  void filterSearch(String query) {
    if (query.isEmpty) {
      filteredItems.value = List.from(airportsListData);
    } else {
      final lowerQuery = query.toLowerCase();
      filteredItems.value = airportsListData.where((airport) {
        return airport.name!.toLowerCase().contains(lowerQuery) ||
            airport.city!.toLowerCase().contains(lowerQuery) ||
            airport.code!.toLowerCase().contains(lowerQuery);
      }).toList();
    }
    filteredItems.refresh();
    print("Filtered Items: ${filteredItems.length}");
  }
}
