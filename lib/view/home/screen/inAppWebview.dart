import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../IFrame/customWebviewController.dart';
import '../../skeletonView/wall_skeleton_view.dart';

class CustomWebViewPage extends GetView<CustomWebViewController> {
  CustomWebViewPage({Key? key}) : super(key: key);

  static const routeName = "/CustomWebViewPage";

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          height: 72.v,
          leadingWidth: 45.h,
          leading: AppbarLeadingImage(
            imagePath: ImageConstant.imgArrowLeft,
            margin: EdgeInsets.only(
              left: 7.h,
              top: 3,
              // bottom: 12.v,
            ),
            onTap: () {
              Get.back();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                // Reload the web view when the refresh button is pressed
                controller.loadAndUpdateUrl();
              },
            ),
          ],
          title: ToolbarTitle(title: Get.arguments["title"]),
        ),
        body: Stack(
          children: <Widget>[
            _buildWebView(context),
            Obx(() => controller.loading.value
                ? const Skeletonizer(enabled: true, child: WallSkeletonView())
                : const SizedBox()),
          ],
        ));
  }

  _buildWebView(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          WebViewWidget(
            controller: controller.webViewController,
            gestureRecognizers: gestureRecognizers,
          ),
          controller.loading.value ? const Loading() : const SizedBox()
        ],
      );
    });
  }

  /* Widget wibViewWidget(BuildContext context) {
    return GetX<CustomWebViewController>(
        builder: (controller) {
      return Skeletonizer(
          enabled: controller.loading.value,
          child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(controller.pageUrl.value
)),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                mediaPlaybackRequiresUserGesture: false,
                useShouldOverrideUrlLoading: true,
              ),
              ios: IOSInAppWebViewOptions(
                allowsInlineMediaPlayback: true,
              ),
            ),
            shouldOverrideUrlLoading: (controller, shouldOverrideUrlLoadingRequest) async {
              var url = shouldOverrideUrlLoadingRequest.request.url.toString();
              var uri = Uri.parse(url);
              if ((uri.toString()).contains('amazonaws.com')) {
                return NavigationActionPolicy.ALLOW;
              } else if (uri.toString().startsWith('tel') ||
                  uri.toString().startsWith('whatsapp') ||
                  uri.toString().startsWith('mailto')) {
                launch(uri.toString());
                return NavigationActionPolicy.CANCEL;
              } else {
                return NavigationActionPolicy.ALLOW;
              }
            },
            androidOnPermissionRequest: (InAppWebViewController controller, String origin, List<String> resources) async {
              await Permission.camera.request();
              await Permission.microphone.request();
              return PermissionRequestResponse(
                resources: resources,
                action: PermissionRequestResponseAction.GRANT,
              );
            },
          ),
        );
      },
    );
  }*/
}
