import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/button/common_material_button.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ShowLoadingPage extends StatelessWidget {
  GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;
  String? message;
  String? title;
  String? iconUrl;
  bool? isLoggedIn;
  ShowLoadingPage(
      {Key? key,
      required this.refreshIndicatorKey,
      this.message,
      this.title,
      this.iconUrl,
      this.isLoggedIn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 85,
                  width: 85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color.fromRGBO(244, 243, 247, 1),
                  ),
                  child: iconUrl != null && iconUrl!.isNotEmpty
                      ? iconUrl!.contains("http") || iconUrl!.contains("https")
                          ? Image.network(iconUrl!, scale: 2.5)
                          : iconUrl!.contains("json")
                              ? Lottie.asset(iconUrl!, width: 100)
                              : iconUrl!.contains("svg")
                                  ? SvgPicture.asset(iconUrl!,
                                      height: 100.adaptSize)
                                  : Image.asset(iconUrl!, scale: 2.5)
                      : isLoggedIn == null
                          ? Image.asset(ImageConstant.noData, scale: 2.5)
                          : Image.asset(ImageConstant.actionDoneIcon,
                              scale: 2.5),
                ),
                const SizedBox(
                  height: 25,
                ),
                CustomTextView(
                  text: isLoggedIn == null
                      ? (title?.isNotEmpty ?? false)
                          ? title!
                          : "no_data_found".tr
                      : "Login Required",
                  color: colorSecondary, // Adjust text color if needed
                  fontSize: 22,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextView(
                  text: isLoggedIn == null
                      ? (message?.isNotEmpty ?? false)
                          ? message!
                          : "no_data_found_description".tr
                      : "To access this feature, you need to be logged in.",
                  color: colorSecondary, // Adjust text color if needed
                  fontSize: 16,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
