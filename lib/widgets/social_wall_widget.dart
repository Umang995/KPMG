import 'package:dreamcast/view/IFrame/socialWallController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../view/skeletonView/wall_skeleton_view.dart';

class SocialWallWidget extends StatelessWidget {
  SocialWallWidget({super.key});

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };

  @override
  Widget build(BuildContext context) {
    return GetX<SocialWallController>(
      builder: (controller) {
        return Stack(
          children: [
            Skeletonizer(
              enabled: controller.loadingChild.value,
              child: controller.loadingChild.value
                  ? const WallSkeletonView()
                  : WebViewWidget(
                      controller: controller.childWebViewController,
                      gestureRecognizers: gestureRecognizers,
                    ),
            ),
            controller.loadingChild.value ? const SizedBox() : const SizedBox()
          ],
        );
      },
    );
  }
}
