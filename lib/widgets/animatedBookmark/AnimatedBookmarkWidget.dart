import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../utils/dialog_constant.dart';
import '../../utils/image_constant.dart';

class AnimatedBookmarkWidget extends StatelessWidget {
  final List<dynamic> bookMarkIdsList;
  final String id;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double? height;
  final bool
      isDocumentBookmark; // Add a parameter to differentiate bookmark types

  AnimatedBookmarkWidget({
    Key? key,
    required this.bookMarkIdsList,
    required this.id,
    required this.onTap,
    required this.padding,
    this.height,
    this.isDocumentBookmark =
        false, // Required parameter to differentiate widgets
  }) : super(key: key);

  AuthenticationManager authenticationManager = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!authenticationManager.isLogin()) {
          DialogConstantHelper.showLoginDialog(context, authenticationManager);
          return;
        }
        // Haptic Feedback
        HapticFeedback.heavyImpact();
        onTap?.call();
      },
      child: Container(
        color: Colors.transparent,
        padding: padding,
        child: Obx(() => AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final flipAnimation =
                    Tween(begin: 2.0, end: 0.0).animate(animation);
                return AnimatedBuilder(
                  animation: flipAnimation,
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform:
                          Matrix4.rotationY(flipAnimation.value * 3.1416),
                      child: child,
                    );
                  },
                  child: child,
                );
              },
              child: SvgPicture.asset(
                key: ValueKey<bool>(bookMarkIdsList.contains(id)),
                bookMarkIdsList.contains(id)
                    ? (isDocumentBookmark
                        ? ImageConstant.add_to_briefcase_sel
                        : ImageConstant.bookmarkIcon)
                    : (isDocumentBookmark
                        ? ImageConstant.add_to_briefcase
                        : ImageConstant.unBookmarkIcon),
                height: isDocumentBookmark ? 32 : height ?? 18,
              ),
            )),
      ),
    );
  }
}
