import 'dart:convert';
import 'dart:io';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/api_repository/app_url.dart';
import 'package:dreamcast/view/gallery/model/galleryModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../model/erro_code_model.dart';
import '../routes/app_pages.dart';
import '../theme/app_colors.dart';
import '../utils/pref_utils.dart';
import '../view/beforeLogin/globalController/authentication_manager.dart';
import '../widgets/textview/customTextView.dart';
import '../view/eventFeed/model/createPostModel.dart';
import '../widgets/button/common_material_button.dart';
import 'digestauthclient.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:http_parser/http_parser.dart';
import 'exceptions.dart';

ApiService apiService = Get.find<ApiService>();

class ApiService extends GetxService {
  var cphiHeaders;
  var authHeader;
  var DIGEST_AUTH_USERNAME = "";
  var DIGEST_AUTH_PASSWORD = "";
  var isDialogShow = false;

  Future<ApiService> init() async {
    DIGEST_AUTH_USERNAME = "41ab073b088c9b12b231643ff6f437d9";
    DIGEST_AUTH_PASSWORD = "9381edb30e889126282379eae2bf2aee";
    AuthenticationManager authManager = Get.find();
    cphiHeaders = {
      "Content-Type": "application/json; charset=utf-8",
      "X-Api-Key": "%2BiR%2Ftt9g8E1tk1%2BDCJgiO7i5XrI%3D",
      "X-Requested-With": "XMLHttpRequest",
      "dc-timezone": "-330",
      "User-Agent": authManager.osName.toUpperCase(),
      "Dc-OS": authManager.osName.toLowerCase(),
      "Dc-Device": authManager.dc_device.toLowerCase(),
      "Dc-Platform": "flutter",
      "Dc-OS-Version": authManager.platformVersion,
      "DC-UUID": "",
      "Dc-App-Version": authManager.currAppVersion.toString(),
    };
    return this;
  }

  dynamic getHeaders({bool? isMultipart}) {
    AuthenticationManager authManager = Get.find();
    authHeader = {
      "Content-Type": isMultipart == true
          ? "multipart/form-data"
          : "application/json; charset=utf-8",
      "X-Api-Key": '%2BiR%2Ftt9g8E1tk1%2BDCJgiO7i5XrI%3D',
      "X-Requested-With": "XMLHttpRequest",
      "dc-timezone": "-330",
      "Cookie": PrefUtils.getToken(),
      "User-Agent": authManager.osName.toUpperCase(),
      "Dc-OS": authManager.osName,
      "Dc-Device": authManager.dc_device,
      "Dc-Platform": "flutter",
      "Dc-OS-Version": authManager.platformVersion,
      "DC-UUID": "",
      "Dc-App-Version": authManager.currAppVersion.toString(),
      "dc-guest-id": PrefUtils.getGuestLoginId(),
    };
    return authHeader!;
  }

  Future<dynamic> dynamicPostRequest(
      {dynamic body, url, dynamic defaultHeader, dynamic isLoginApi}) async {
    try {
      debugPrint("api request: ${url}");
      debugPrint("api request: ${jsonEncode(body)}");
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(url),
                  headers: defaultHeader != null ? cphiHeaders : getHeaders(),
                  body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      debugPrint("api response: ${response.body}");
      if (isLoginApi == true) {
        if (json.decode(response.body)["status"]) {
          PrefUtils.setToken(response.headers['set-cookie'].toString());
        } else {
          PrefUtils.setToken("");
        }
      }
      if (ErrorCodeModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire(url);
      }
      return response.body;
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<dynamic> dynamicGetRequest({url, dynamic defaultHeader}) async {
    debugPrint("api url: ${url}");

    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .get(Uri.parse(url),
                  headers: defaultHeader != null ? cphiHeaders : getHeaders())
              .timeout(const Duration(seconds: 30));
      debugPrint("api get response: ${url + "  " + response.body}");
      if (ErrorCodeModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire(url);
      }
      return response.body;
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  ///used for the travel desk
  Future<dynamic> commonMultipartAPi({
    required Map<String, dynamic> requestBody, // Allow dynamic values
    required String url,
    required dynamic formFieldData,
  }) async {
    final uri = Uri.parse(url);
    final req = http.MultipartRequest("POST", uri);

    for (int index = 0; index < formFieldData.length; index++) {
      var data = formFieldData[index];

      // Attach image if provided
      if (data.type == "file") {
        var imageFile = data.value ?? "";
        if (imageFile != null &&
            imageFile.isNotEmpty &&
            imageFile.toString().contains("https") == false) {
          final mimeType = lookupMimeType(imageFile, headerBytes: [0xFF, 0xD8]);
          if (mimeType != null) {
            final mimeTypeData = mimeType.split('/');
            req.files.add(await http.MultipartFile.fromPath(
              data.name,
              imageFile,
              contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
            ));
          } else {
            debugPrint("Error: Unsupported file type.");
            return {"error": "Unsupported file type."};
          }
        }
      }
    }

    // Convert all values to string to avoid type mismatch
    req.fields.addAll(
        requestBody.map((key, value) => MapEntry(key, value.toString())));
    req.headers.addAll(authHeader);

    try {
      final response = await http.Response.fromStream(
        await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
            .send(req)
            .timeout(const Duration(seconds: 50)),
      );

      debugPrint("Response: ${response.body}");

      final responseData = json.decode(response.body);

      if (responseData["code"] == 440) {
        tokenExpire(url);
      }

      return responseData;
    } on TimeoutException {
      debugPrint("Error: Request Timed Out.");
      return {"error": "Request Timed Out."};
    } on SocketException {
      debugPrint("Error: No Internet Connection.");
      return {"error": "No Internet Connection."};
    } on FormatException {
      debugPrint("Error: Invalid Response Format.");
      return {"error": "Invalid Response Format."};
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      return {"error": e.toString()};
    }
  }

  Future<CreatePostModel?> createEventFeed(
      dynamic body, XFile? file, File? thumbnailFile, String? type) async {
    print("event feed body $body");
    final uri = Uri.parse(AppUrl.feedCreate);
    final req = http.MultipartRequest("POST", uri);

    if (file != null && file.path.isNotEmpty) {
      final mimeTypeData =
          lookupMimeType(file.path, headerBytes: [0xFF, 0xD8])!.split('/');
      if (type == "image" || type == "document") {
        req.files.add(await http.MultipartFile.fromPath("media", file.path,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
      } else {
        if (thumbnailFile != null) {
          final mimeTypeData =
              lookupMimeType(thumbnailFile.path, headerBytes: [0xFF, 0xD8])!
                  .split('/');
          req.files.add(await http.MultipartFile.fromPath(
              "media", thumbnailFile.path,
              contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
          req.files.add(await http.MultipartFile.fromPath("video", file.path,
              contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
        }
      }
    }

    print("event feed thumbnailFile ${thumbnailFile?.path}");
    print("event feed thumbnailFile ${file?.path}");
    print("event body ${jsonEncode(body)}");

    req.fields.addAll(body);
    req.headers.addAll(getHeaders());
    try {
      //final response =
      http.Response response1 = await http.Response.fromStream(
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .send(req)
              .timeout(const Duration(seconds: 120)));
      print("response1 ${response1.body}");
      if (CreatePostModel.fromJson(json.decode(response1.body)).code == 440) {
        tokenExpire(uri.toString());
      }
      return CreatePostModel.fromJson(json.decode(response1.body.toString()));
    } catch (e) {
      print(e.toString());
      checkException(e);
    }
    return null;
  }

  ///used for the common multipart
  Future<T?> uploadMultipartRequest<T>({
    required String url,
    required Map<String, String> fields,
    required Map<String, dynamic> files, // key: fieldName, value: file path
    Duration timeout = const Duration(seconds: 60),
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final uri = Uri.parse(url);
    final req = http.MultipartRequest("POST", uri);

    // Add fields
    req.fields.addAll(fields);

    // Add files
    for (var entry in files.entries) {
      final filePath = entry.value;
      if (filePath != null && filePath.toString().isNotEmpty) {
        final mimeTypeData =
            lookupMimeType(filePath, headerBytes: [0xFF, 0xD8])!.split('/');
        req.files.add(await http.MultipartFile.fromPath(
          entry.key,
          filePath,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ));
      }
    }

    // Add headers
    req.headers.addAll(getHeaders(isMultipart: true));

    try {
      final response = await http.Response.fromStream(
        await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
            .send(req)
            .timeout(timeout),
      );

      final decoded = json.decode(response.body);
      if (decoded is Map<String, dynamic>) {
        return fromJson(decoded);
      }
    } catch (e) {
      checkException(e);
      debugPrint(e.toString());
      UiHelper.showFailureMsg(null, e.toString());
    }

    return null;
  }

  tokenExpire(String? url) {
    print("url=> $url");

    print("url expired $isDialogShow");
    if (Get.isDialogOpen != true) {
      Get.defaultDialog(
        backgroundColor: white,
        title: "",
        barrierDismissible: false,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomTextView(
              fontSize: 22,
              textAlign: TextAlign.center,
              text: "Login Expired",
              fontWeight: FontWeight.bold,
              maxLines: 1,
            ),
            const SizedBox(
              height: 20,
            ),
            const CustomTextView(
              fontSize: 16,
              textAlign: TextAlign.center,
              text:
                  "You have either logged out or you were automatically logged out for security purposes",
              fontWeight: FontWeight.normal,
              maxLines: 4,
            ),
            const SizedBox(
              height: 20,
            ),
            CommonMaterialButton(
                height: 50,
                textSize: 16,
                width: 160,
                text: "Login Again",
                color: colorPrimary,
                onPressed: () {
                  isDialogShow = false;
                  PrefUtils.clearPreferencesData();
                  Get.offNamedUntil(Routes.LOGIN, (route) => false);
                }),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
        radius: 10,
        onWillPop: () async {
          return false;
        },
      );
    }
  }

  void checkException(Object exception) {
    if (exception is ServerException) {
      Get.snackbar(
        backgroundColor: Colors.red,
        colorText: Colors.white,
        "Http status error [500]",
        (exception).message.toString(),
      );
      print((exception).statusCode);
    } else if (exception is ClientException) {
      Get.snackbar(
        backgroundColor: Colors.red,
        colorText: Colors.white,
        "Http status error [500]",
        (exception as ServerException).message.toString(),
      );
    } else if (exception is HttpException) {
      Get.snackbar(
        backgroundColor: Colors.red,
        colorText: Colors.white,
        "Network",
        "Please check your internet connection.",
      );
    } else {
      UiHelper.isNoInternet();
    }
  }
}
