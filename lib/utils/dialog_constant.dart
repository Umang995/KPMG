import 'dart:io';
import 'package:dreamcast/routes/app_pages.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/beforeLogin/login/login_controller.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import '../theme/app_colors.dart';
import '../theme/app_colors.dart';
import '../theme/controller/theme_controller.dart';
import '../view/beforeLogin/login/login_page_otp.dart';
import '../view/beforeLogin/widget/loginFormWidget.dart';
import '../widgets/button/common_material_button.dart';
import '../widgets/dialog/custom_dialog_widget.dart';
import 'pref_utils.dart';

class DialogConstantHelper {
  ///common used   show dialog in case of not login

  static showLoginDialog(
      BuildContext context, AuthenticationManager authManager) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: true,
        isScrollControlled: true, // <- this is important!
        barrierColor: Colors.black.withOpacity(0.5),
        builder: (context) {
          return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              //onWillPop: () async => false, // Prevents back button press
              child: Container(
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.30),
                      blurRadius: 20,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(30.adaptSize),
                width: context.width,
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextView(
                              text: "login_required".tr,
                              textAlign: TextAlign.start,
                              fontSize: 20.0,
                              color: colorSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                            InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                          ImageConstant.icClose,
                                          height: 20,
                                          colorFilter: ColorFilter.mode(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              BlendMode.srcIn)),
                                    )))
                          ],
                        ),
                        SizedBox(height: 3.v),
                        CustomTextView(
                          text: "uou_need_login_this_features".tr,
                          textAlign: TextAlign.center,
                          fontSize: 16.0,
                          color: colorGray,
                          fontWeight: FontWeight.w600,
                        ),
                        Divider(
                          height: 20.v,
                          color: borderColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: LoginFormWidget(
                            isGuestForm: true,
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ],
                ),
              ));
        });
  }

  static showPermissionDialog({String? message}) {
    Get.dialog(AlertDialog(
      content: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 0, right: 0),
          child: CustomTextView(
              text: message ?? "camera_permission_content".tr,
              color: Colors.black, // Adjust text color if needed
              fontSize: 18,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w500)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colorSecondary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: CustomTextView(
                    text: "cancel".tr,
                    color: colorSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500, // Medium font weight
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CommonMaterialButton(
                  text: "Settings".tr,
                  height: 46,
                  color: colorPrimary,
                  onPressed: () async {
                    Get.back();
                    await openAppSettings();
                  },
                  weight: FontWeight.w500, // Medium font weight
                ),
              ),
            ],
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12), // Adjust border radius for dialog
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
    ));
  }
}
