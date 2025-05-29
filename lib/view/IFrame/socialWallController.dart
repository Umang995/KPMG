import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../api_repository/api_service.dart';
import '../../../model/guide_model.dart';
import '../../api_repository/app_url.dart';
import '../../routes/my_constant.dart';
import '../../theme/ui_helper.dart';

class SocialWallController extends GetxController {
  ///used for the social wall
  var socialWallUrl = "".obs;
  var loading = false.obs;
  var loadingChild = false.obs;
  late var apiMessage;

  late final WebViewController childWebViewController;

  late final WebViewController parentWebViewController;

  @override
  void onInit() {
    super.onInit();
    childWebViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..enableZoom(false)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (String url) {
          print("121 onPageStarted");
          loadingChild(true);
        },
        onPageFinished: (String url) {
          print("121 onPageFinished");
          Future.delayed(const Duration(seconds: 1), () {
            loadingChild(false);
          });
        },
        onNavigationRequest: (NavigationRequest request) {
          return _navigationDelegate(request);
        },
      ));

    parentWebViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..enableZoom(false)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (String url) {
          loading(true);
        },
        onPageFinished: (String url) {
          Future.delayed(const Duration(seconds: 1), () {
            loading(false);
          });
        },
        onNavigationRequest: (NavigationRequest request) {
          return _navigationDelegate(request);
        },
      ));
  }

  // Method to handle navigation decisions
  NavigationDecision _navigationDelegate(NavigationRequest request) {
    if (request.url.isNotEmpty &&
        !request.url.contains("https://widget.socialwalls.com") &&
        request.isMainFrame) {
      // Intercept URLs that begin with google maps and open in the native app
      UiHelper.inAppWebView(Uri.parse(request.url));
      return NavigationDecision.prevent; // Prevent the WebView from loading it
    } else if ((request.url.toString().startsWith('tel') ||
        request.url.toString().startsWith('whatsapp') ||
        request.url.toString().startsWith('mailto') && request.isMainFrame)) {
      UiHelper.inAppWebView(Uri.parse(request.url));
      return NavigationDecision.prevent;
    } else {
      return NavigationDecision.navigate; // Allow WebView to handle other URLs
    }
  }

  Future<dynamic> getSocialWallUrl() async {
    var result;
    loading(true);
    final model = IFrameModel.fromJson(json.decode(
      await apiService.dynamicGetRequest(
        url: "${AppUrl.iframe}/${MyConstant.slugSocialWall}",
      ),
    ));
    if (model.status ?? false) {
      result = {"status": model.body?.status ?? false};
      apiMessage = model.body?.messageData?.body ?? "";
      socialWallUrl(
          model.body?.status ?? false ? model.body?.webview ?? "" : "");
      parentSocialUpdateUrl(socialWallUrl.value);
      childSocialUpdateUrl(socialWallUrl.value);
      refresh();
      loading(false);
    } else {
      loading(false);
      result = {"status": false};
      apiMessage = model.body?.messageData?.body ?? "";
    }
    return result;
  }

  void parentSocialUpdateUrl(String url) {
    if (url?.isEmpty ?? false) {
      return;
    }
    parentWebViewController.loadRequest(Uri.parse(url));
  }

  void childSocialUpdateUrl(String url) {
    if (url?.isEmpty ?? false) {
      return;
    }
    childWebViewController.loadRequest(Uri.parse(url));
  }
}
