import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/IFrame/socialWallController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../theme/app_colors.dart';
import '../../utils/image_constant.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/toolbarTitle.dart';
import '../dashboard/showLoadingPage.dart';
import '../skeletonView/wall_skeleton_view.dart';

class SocialWallPage extends GetView<SocialWallController> {
  dynamic title;
  bool showToolbar;

  SocialWallPage({Key? key, required this.title, required this.showToolbar})
      : super(key: key);
  final SocialWallController homeController = Get.find();

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };

  ///refresh the page.
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          title: ToolbarTitle(title: "social_wall".tr),
        ),
        body: RefreshIndicator(
          color: colorLightGray,
          backgroundColor: colorPrimary,
          strokeWidth: 1.0,
          key: _refreshIndicatorKey,
          onRefresh: () {
            return Future.delayed(
              const Duration(seconds: 1),
              () {
                refreshApiData(isRefresh: false);
              },
            );
          },
          child: Stack(
            children: <Widget>[
              Obx(() => controller.loading.value
                  ? const Skeletonizer(enabled: true, child: WallSkeletonView())
                  : controller.socialWallUrl.value.isEmpty
                      ? ShowLoadingPage(
                          refreshIndicatorKey: null,
                          message: controller.apiMessage,
                        )
                      : _buildWebView(context)),
            ],
          ),
        ));
  }

  refreshApiData({required bool isRefresh}) {
    controller.getSocialWallUrl();
  }

  _buildWebView(BuildContext context) {
    return WebViewWidget(
      controller: controller.parentWebViewController,
      gestureRecognizers: gestureRecognizers,
    );
  }
}
