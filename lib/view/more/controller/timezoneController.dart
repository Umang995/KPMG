import 'dart:convert';

import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/home/model/timezone_model.dart';
import 'package:get/get.dart';
import 'package:dreamcast/api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../model/common_model.dart';
import '../../../utils/pref_utils.dart';

class TimezoneController extends GetxController {
  final AuthenticationManager _authController = Get.find();

  AuthenticationManager get authController => _authController;

  var isLoading = false.obs;
  var timezoneList = <TimezoneBody>[].obs;
  var tempList = <TimezoneBody>[].obs;
  var selectedTimezone = "".obs;

  @override
  void onInit() {
    super.onInit();
    selectedTimezone.value = PrefUtils.getTimezone() ?? "";
    getTimezoneData();
  }

  /// Get the timezone name based on the ID
  String? getTimezoneNameById(String id) {
    final matchedTimezone = timezoneList.firstWhere(
      (timezone) => timezone.value == id,
      orElse: () => TimezoneBody(),
    );

    return "${matchedTimezone.offset?.text ?? ""} ${matchedTimezone.text ?? ""}";
  }

  /// Fetch timezone data from the API
  Future<void> getTimezoneData({String? slug}) async {
    isLoading(true);
    try {

      final model = TimezoneModel.fromJson(json.decode(
        await apiService.dynamicGetRequest(
          url: "${AppUrl.timezone}/get",),
      ));
      if (model.status == true && model.code == 200) {
        timezoneList.assignAll(model.body ?? []);
        tempList.assignAll(model.body ?? []);
      } else {
        timezoneList.clear();
      }
    } finally {
      isLoading(false);
    }
  }

  /// Set the selected timezone and update the backend
  Future<void> setTimezone({
    required dynamic context,
    required String timezone,
  }) async {
    isLoading(true);
    try {
      final model = CommonModel.fromJson(json.decode(
        await apiService.dynamicPostRequest(
            body: {"timezone": timezone}, url: "${AppUrl.timezone}/update"),
      ));
      if (model.status == true && model.code == 200) {
        PrefUtils.saveTimezone(timezone);
        Get.back();
        UiHelper.showSuccessMsg(null, model.message ?? "");
      } else {
        print("Error: ${model.status}");
      }
    } finally {
      isLoading(false);
    }
  }

  /// Filter the timezone list based on a search query
  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      final filteredList = timezoneList
          .where((item) =>
              item.text?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();

      tempList.assignAll(filteredList);
    } else {
      tempList.assignAll(timezoneList);
    }
  }
}
