import 'package:dreamcast/theme/ui_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LocationMapViewWidget extends StatefulWidget {
  final String url;
  const LocationMapViewWidget({super.key, required this.url});

  @override
  State<LocationMapViewWidget> createState() => _LocationMapViewWidgetState();
}

class _LocationMapViewWidgetState extends State<LocationMapViewWidget> {
  late final WebViewController _controller;

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };

  late NavigationDelegate delegate;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..enableZoom(true)
      ..loadHtmlString(_iframeHtml2())
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          return _navigationDelegate(request);
        },
      ));
  }

  // Method to handle navigation decisions
  NavigationDecision _navigationDelegate(NavigationRequest request) {
    debugPrint(
        " 420 map-: ${request.url} is main frame ${request.isMainFrame}");
    if (request.url.startsWith("https://www.google.com/maps") &&
        request.isMainFrame) {
      // Intercept URLs that begin with google maps and open in the native app
      UiHelper.inPlatformDefault(Uri.parse(request.url));
      return NavigationDecision.prevent; // Prevent the WebView from loading it
    }
    return NavigationDecision.navigate; // Allow WebView to handle other URLs
  }

  String _iframeHtml2() {
    return '''
    <!DOCTYPE html>
    <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
          html, body { margin: 0; padding: 0; height: 100%; }
          iframe { border: 0; width: 100%; height: 100%; }
          /* Hide the "View Larger Map" button */
          a[href^="https://www.google.com/maps"] {
            display: none !important;
          }
        </style>
      </head>
      <body>
        <iframe
  src=${widget.url}=embed&zoom=15&hl=en"
  style="border:0;"
  allowfullscreen=""
  loading="lazy">
</iframe>
      </body>
    </html>
  ''';
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
        controller: _controller, gestureRecognizers: gestureRecognizers);
  }
}
