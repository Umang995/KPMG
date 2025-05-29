import 'dart:convert';
import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/widgets/dialog/custom_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../model/common_model.dart';
import '../../../theme/ui_helper.dart';
import '../model/addEditNotesModel.dart';
import '../model/common_notes_model.dart';

class MyNotesController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final selectedTabIndex = 0.obs;
  late TabController _tabController;
  TabController get tabController => _tabController;
  ScrollController tabScrollController = ScrollController();

  //******** Tab List Items ***********
  var tabList = ["Attendees", "Exhibitors", "Speakers"];
  var commonNotesList = <NotesDataModel>[].obs;
  var boothNotesList = <NotesDataModel>[].obs;
  var speakerNotesList = <NotesDataModel>[].obs;

  var firstLoading = false.obs;
  var isLoading = false.obs;
  final AuthenticationManager authenticationManager =
      Get.find<AuthenticationManager>();

  @override
  void onInit() {
    super.onInit();
    //******** Initialize tab ***********
    _tabController = TabController(vsync: this, length: 3);
    getUserNotes(
        requestBody: {"item_type": MyConstant.networking, "item_id": ""});
  }

  //********** Call apis according to tab index ***********///
  callApis(int index) {
    commonNotesList.clear();
    if (index == 0) {
      // Attendees notes apis
      getUserNotes(
          requestBody: {"item_type": MyConstant.networking, "item_id": ""});
    } else if (index == 1) {
      // Exhibitor notes apis
      getUserNotes(
          requestBody: {"item_type": MyConstant.exhibitor, "item_id": ""});
    } else if (index == 2) {
      // Speakers notes apis
      getUserNotes(
          requestBody: {"item_type": MyConstant.speakers, "item_id": ""});
    }
  }

  //get notes text
  Future<void> getUserNotes({required requestBody}) async {
    if (!authenticationManager.isLogin()) {
      return;
    }
    try {
      firstLoading(true);

      final model = CommonNotesModel.fromJson(json.decode(
        await apiService.dynamicPostRequest(
          body: requestBody,
          url: AppUrl.getNotes,
        ),
      ));

      firstLoading(false);
      if (model.status! && model.code == 200) {
        commonNotesList.clear();
        commonNotesList.addAll(model.body ?? []);
        commonNotesList.refresh();
      }
      commonNotesList.refresh();
    } catch (e) {
      print(e.toString());
      firstLoading(false);
    }
  }

  // Delete saved note api
  Future<void> deleteSavedNote({required requestBody}) async {
    isLoading(true);

    final model = CommonNotesModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: requestBody,
        url: AppUrl.deleteNote,
      ),
    ));
    isLoading(false);
    if (model.status! && model.code == 200) {
      // Find the index
      int index =
          commonNotesList.indexWhere((user) => user.id == requestBody['id']);
      commonNotesList.removeAt(index);
      commonNotesList.refresh();
    }
  }

  //add notes text
  Future<Map> addNotesToUser(
    dynamic requestBody,
  ) async {
    var result = {};
    isLoading(true);

    final model = AddEditNotesModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: requestBody,
        url: AppUrl.saveNotes,
      ),
    ));
    isLoading(false);
    if (model.status! && model.code == 200 && model.body != null) {
      result = {
        "status": true,
        "text": model.body?.text,
        "message": model.message ?? "",
        "id": model.body?.id ?? ""
      };
      UiHelper.showSuccessMsg(null, model.message ?? "");
    } else {
      result = {
        "status": false,
        "text": requestBody["text"],
        "message": model.message ?? "",
        "id": ""
      };
    }
    return result;
  }

  void hideAllMenu(String id) {
    commonNotesList.map((value) {
      if (value.id != id) {
        value.showPopup(false);
      }
    }).toList();
  }

  void showDeleteNoteDialog({
    required context,
    required content,
    required title,
    required logo,
    required confirmButtonText,
    required body,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogWidget(
          logo: logo,
          title: title,
          description: content,
          buttonAction: "Yes, $confirmButtonText",
          buttonCancel: "cancel".tr,
          onCancelTap: () {},
          onActionTap: () async {
            deleteSavedNote(requestBody: body);
          },
        );
      },
    );
  }
}
