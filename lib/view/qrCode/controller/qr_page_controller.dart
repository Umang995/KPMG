import 'dart:convert';
import 'dart:io';

import 'package:dreamcast/view/contact/controller/contact_controller.dart';
import 'package:dreamcast/view/qrCode/model/qrScannedUserDetails_Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../model/badge_model.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/file_manager.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/dialog/custom_animated_dialog_widget.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../model/unique_code_model.dart';
import '../model/user_detail_model.dart';
import 'package:http/http.dart' as http;

class QrPageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var loading = false.obs;
  var userFound = false.obs;
  final AuthenticationManager controller = Get.find();
  var vCard = ContactCard.create("", "", "", "", "", "", "").obs;
  var badgeMessage = "".obs;
  var qrBadge = "".obs;
  late TabController _tabController;
  TabController get tabController => _tabController;
  var isCameraPermissionDenied = false.obs;
  var localQrCodePath = "".obs;

  @override
  void onInit() {
    super.onInit();
    _tabController = TabController(vsync: this, length: 3);
    if (Get.arguments != null && Get.arguments["tab_index"] != null) {
      _tabController.index = Get.arguments["tab_index"];
    }
    getUniqueCode();
  }

  clearQr() {
    qrBadge = "".obs;
    loading(true);
    controller.update();
  }

  ///get badge detail
  Future<void> getUniqueCode() async {
    await checkIfImageExists();
    controller.update();

    if (await UiHelper.isInternetConnect()) {

      final model = BadgeModel.fromJson(json.decode(
        await apiService.dynamicPostRequest(
          body: {"type": "mbadge"},
          url: AppUrl.getBadge,
        ),
      ));
      if (model.status ?? false) {
        String badgeUrl = model.body?.mbadge ?? "";
        qrBadge(badgeUrl);
        badgeMessage(model.body?.message?.body ?? "");

        final fileExtension = FileManager.instance.getFileExtension(badgeUrl);
        final fileName = 'qr_code$fileExtension';
        final directory = await FileManager.instance.getDocumentsDirectoryPath;
        final filePath =
            "$directory/qr_code${fileExtension == '.pdf' ? '.pdf' : '.png'}";

        debugPrint("Saving QR code as: $fileName");

        await downloadAndSaveImage(badgeUrl, fileName, filePath);
      }
    }
  }

  Future<void> checkIfImageExists() async {
    final directory = await FileManager.instance.getDocumentsDirectoryPath;
    final filePaths = ["$directory/qr_code.png", "$directory/qr_code.pdf"];

    for (String path in filePaths) {
      if (await File(path).exists()) {
        localQrCodePath.value = path;
        debugPrint('File exists: $path');
        return;
      }
    }
    debugPrint('No QR code file found.');
  }

  Future<void> downloadAndSaveImage(
      String qrCodeUrl, String fileName, String oldFile) async {
    try {
      final response = await http.get(Uri.parse(qrCodeUrl));

      if (response.statusCode == 200) {
        await FileManager.instance.deleteFile1(oldFile);
        debugPrint('Deleted old file: $oldFile');

        final savedPath =
            await FileManager.instance.saveFile(fileName, response.bodyBytes);
        localQrCodePath.value = savedPath;
        debugPrint('QR code downloaded and saved at: $savedPath');
      } else {
        debugPrint(
            'Failed to download QR code. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error downloading QR code: $e');
    }
  }

  ///get the user detail by unique code.
  Future<QrScannedUserDetailsModel> getUserDetail(
      BuildContext context, uniqueCode) async {
    loading(true);

    final model = QrScannedUserDetailsModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: {"qrcode": uniqueCode},
        url: AppUrl.getUserDetail,
      ),
    ));
    loading(false);
    if (model.status ?? false) {
      uniqueCode = uniqueCode;
      // await Get.to(SaveContactPage(
      //   userModel: model,
      //   code: uniqueCode,
      // ));
      _tabController.index = 2;
      return model;
    } else {
      // Reset QR scanner
      UiHelper.showFailureMsg(context, "data_not_found".tr);
      return model;
    }
  }

  ///save the context to app contact list
  Future<UniqueCodeModel?> saveUserToContact(
      BuildContext context, dynamic data) async {
    loading(true);
    final model = UniqueCodeModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: data,
        url: AppUrl.saveContact,
      ),
    ));
    if (model?.status ?? false) {
      if (Get.isRegistered<ContactController>()) {
        ContactController controller = Get.find();
        controller.getContactList(requestBody: {
          "page": "1",
          "filters": {
            "search": "",
            "sort": "ASC",
          }
        });
      }
      _tabController.index = 2;
      await Get.dialog(
          barrierDismissible: false,
          CustomAnimatedDialogWidget(
            title: "",
            logo: ImageConstant.icSuccessAnimated,
            description: model.message ?? "",
            buttonAction: "okay".tr,
            buttonCancel: "cancel".tr,
            isHideCancelBtn: true,
            onCancelTap: () {},
            onActionTap: () async {
              //Get.back();
            },
          ));
      return model;
    } else {
      UiHelper.showFailureMsg(context, model?.message ?? "");
    }
    loading(false);
    return null;
  }

  refreshTheContact() async {
    if (Get.isRegistered<ContactController>()) {
      ContactController controller = Get.find();
      await controller.getContactList(requestBody: {
        "page": "1",
        "filters": {"search": "", "sort": "ASC", "type": ""}
      });
      Get.back(result: true);
    } else {
      Get.back(result: true);
    }
  }

  String textSelect(String str) {
    str = str.replaceAll(';', '');
    str = str.replaceAll('type', '');
    str = str.replaceAll('tel', '');
    str = str.replaceAll('adr', '');
    str = str.replaceAll('pref', '');
    str = str.replaceAll('=', '');
    str = str.replaceAll(',', '');
    str = str.replaceAll('work', '');
    str = str.replaceAll('TELTYPE', '');
    return str;
  }
}

class ContactCard {
  String? name;
  String? mobile;
  String? email;
  String? company;
  String? uniqueCode;
  String? avtar;
  String shortName;
  ContactCard.create(this.name, this.email, this.company, this.uniqueCode,
      this.avtar, this.shortName, this.mobile);
}
