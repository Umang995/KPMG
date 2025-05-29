import 'dart:io';

import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/login/login_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/my_constant.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/Validations.dart';
import '../../../widgets/input_form_field.dart';

class LoginEmailWidget extends GetView<LoginController> {
  bool isGuestForm;
  LoginEmailWidget({super.key, required this.isGuestForm});

  @override
  Widget build(BuildContext context) {
    return /*isGuestForm == false*/ true
        ? InputFormField(
            controller: controller.emailCtr,
            isMobile: false,
            inputAction: TextInputAction.done,
            inputType: TextInputType.emailAddress,
            inputFormatters: Validations.emailFormatters,
            hintText: "loginId".tr,
            maxLength: 50,
            enableFocusBorderColor: colorGray,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "enter_email_address".tr;
              } else if (!UiHelper.isEmail(value.toString())) {
                return "enter_valid_email_address".tr;
              } else {
                return null;
              }
            },
          )
        : TextFormField(
            controller: controller.emailCtr,
            keyboardType: TextInputType.emailAddress,
            inputFormatters: Validations.emailFormatters,
            decoration: InputDecoration(
              labelText: "Email Address",
              labelStyle: TextStyle(
                  color: colorGray,
                  fontWeight: FontWeight.w600,
                  fontSize: 17.adaptSize),
              hintText: "Enter your email address",
              hintStyle: TextStyle(
                  color: colorGray,
                  fontWeight: FontWeight.w600,
                  fontSize: Platform.isAndroid ? 20.adaptSize : 17.adaptSize),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10), // Rounded border
                borderSide: BorderSide(color: colorGray, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10), // Rounded border
                borderSide: BorderSide(color: colorGray, width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10), // Rounded border
                borderSide: BorderSide(color: colorGray, width: 1),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10), // Rounded border
                borderSide: BorderSide(color: colorGray, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colorGray, width: 1),
              ),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "enter_email_address".tr;
              } else if (!UiHelper.isEmail(value.toString())) {
                return "enter_valid_email_address".tr;
              } else {
                return null;
              }
            },
          );
  }
}
