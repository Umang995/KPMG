import 'dart:ui';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../theme/ui_helper.dart';

class CustomWebViewController extends GetxController {
  ///used for the social wall
  var pageUrl = "".obs;
  var loading = false.obs;
  late final WebViewController webViewController;

  @override
  void onInit() {
    super.onInit();
    pageUrl(Get.arguments["page_url"]);
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (String url) {
          loading(true);
        },
        onPageFinished: (String url) {
          loading(false);
        },
        onNavigationRequest: (NavigationRequest request) {
          return _navigationDelegate(request);
        },
      ));

    loadAndUpdateUrl();
  }

  // Method to handle navigation decisions
  NavigationDecision _navigationDelegate(NavigationRequest request) {
    if (request.url.startsWith("https://www.google.com/maps")) {
      // Intercept URLs that begin with google maps and open in the native app
      UiHelper.inPlatformDefault(Uri.parse(request.url));
      return NavigationDecision.prevent; // Prevent the WebView from loading it
    } else if (request.url.toString().startsWith('tel') ||
        request.url.toString().startsWith('whatsapp') ||
        request.url.toString().startsWith('mailto')) {
      UiHelper.inAppWebView(Uri.parse(request.url));
      return NavigationDecision.prevent;
    } else {
      return NavigationDecision.navigate; // Allow WebView to handle other URLs
    }
  }

  void loadAndUpdateUrl() {
    webViewController.loadRequest(Uri.parse(pageUrl.value));
  }
}
