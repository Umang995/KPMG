import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';

import '../routes/my_constant.dart';
import '../utils/pref_utils.dart';
import '../widgets/textview/customTextView.dart';
import 'app_colors.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillGray => BoxDecoration(
        color: colorLightGray,
      );

  ///used in speaker and exhibitor user detail and filter page also.
  static BoxDecoration get roundedBoxDecoration => BoxDecoration(
        color: Theme.of(Get.context!).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10.0,
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(19),
          topRight: Radius.circular(19),
        ),
      );

  //Ai profile decoration
  static BoxDecoration get aiRoundedBoxDecoration => BoxDecoration(
      shape: BoxShape.circle,
      color: colorSecondary,
      gradient: LinearGradient(
        colors: PrefUtils.getAiFeatures()
            ? [gradientBegin, gradientEnd]
            : [
                Colors.white,
                Colors.white,
              ],
      ));

  static BoxDecoration get aiBioDecoration => BoxDecoration(
      shape: BoxShape.rectangle,
      color: colorSecondary,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      gradient: LinearGradient(
        colors: PrefUtils.getAiFeatures()
            ? [gradientBegin, gradientEnd]
            : [
                Colors.white,
                Colors.white,
              ],
      ));

  static BoxDecoration profileCardDecoration(
      {required Color color, required BorderRadiusGeometry borderRadius}) {
    return BoxDecoration(color: color, borderRadius: borderRadius);
  }

  ///used in home top side
  static BoxDecoration get outlineBlack => BoxDecoration(
        color: white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 2.h,
            blurRadius: 10.h,
          )
        ],
      );

  static commonVerticalPadding() {
    return const EdgeInsets.symmetric(vertical: 12);
  }

  static userParentPadding() {
    return const EdgeInsets.all(12);
  }

  static commonTabPadding() {
    return const EdgeInsets.only(top: 8);
  }

  static editBoxGradientBorder() {
    return GradientOutlineInputBorder(
        width: 1,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        gradient: LinearGradient(colors: [gradientBegin, gradientEnd]));
  }

  static shortNameImageDecoration() {
    return BoxDecoration(
      color: white,
      shape: BoxShape.circle,
      border: Border.all(
        color: colorLightGray,
        width: 5.0,
      ),
    );
  }

  static editFieldDecoration({required createFieldBody}) {
    return InputDecoration(
      counter: const Offstage(),
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      labelText: "${createFieldBody.label}",
      hintText: createFieldBody.placeholder ?? "",
      hintStyle: TextStyle(
          fontSize: 15.fSize, color: colorGray, fontWeight: FontWeight.normal),
      labelStyle: TextStyle(
          fontSize: 15.fSize, color: colorGray, fontWeight: FontWeight.normal),
      fillColor: white,
      filled: true,
      prefixIconConstraints: const BoxConstraints(minWidth: 60),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorSecondary)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black)),
    );
  }

  static editLinkedinDecoration({required createFieldBody}) {
    return InputDecoration(
      counter: const Offstage(),
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      labelText: "${createFieldBody.label}",
      hintText: createFieldBody.placeholder ?? "",
      hintStyle: TextStyle(
          fontSize: 15.fSize, color: colorGray, fontWeight: FontWeight.normal),
      labelStyle: TextStyle(
          fontSize: 15.fSize, color: colorGray, fontWeight: FontWeight.normal),
      fillColor: white,
      filled: true,
      prefixIconConstraints: const BoxConstraints(minWidth: 60),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorSecondary)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black)),
    );
  }

  static editFieldDecorationDropdown({required createFieldBody}) {
    return InputDecoration(
      counter: const Offstage(),
      contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
      labelText: "${createFieldBody.label}",
      hintText: "",
      hintStyle: TextStyle(
          fontSize: 15.fSize, color: colorGray, fontWeight: FontWeight.normal),
      labelStyle: TextStyle(
          fontSize: 15.fSize, color: colorGray, fontWeight: FontWeight.normal),
      fillColor: white,
      filled: true,
      prefixIconConstraints: const BoxConstraints(minWidth: 60),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorSecondary)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black)),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor)),
    );
  }

  static editFieldDecorationArea({
    required String label,
    required String placeHolder,
    required Color color,
  }) {
    return InputDecoration(
      counter: const Offstage(),
      contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      hintText: placeHolder,
      hintStyle: TextStyle(
          fontSize: 15.fSize, color: colorGray, fontWeight: FontWeight.normal),
      labelStyle: TextStyle(
          fontSize: 15.fSize, color: colorGray, fontWeight: FontWeight.normal),
      fillColor: white,
      filled: true,
      prefixIconConstraints: const BoxConstraints(minWidth: 60),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black)),
    );
  }

  static outlineBorder(Color color) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black));
  }

  static recommendedDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: <Color>[gradientBegin, gradientEnd],
      ),
    );
  }

  static speakerDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: <Color>[colorPrimary, colorPrimary],
      ),
    );
  }

  ///used in add the event to calender
  static BoxDecoration get decorationAddEvent => BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: colorGray, width: 0.8),
      borderRadius: const BorderRadius.all(Radius.circular(20)));

  ///used in account page action page
  static BoxDecoration get decorationActionButton => BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: colorSecondary, width: 1),
      borderRadius: const BorderRadius.all(Radius.circular(16)));
// Grey decorations
  static BoxDecoration get grayFilterCardDialog => BoxDecoration(
        color: colorLightGray,
      );

  static Widget commonLabelTextWidget(String label) {
    return CustomTextView(
      text: label,
      color: colorSecondary,
      fontSize: 20,
      fontWeight: FontWeight.w500,
      textAlign: TextAlign.start,
      maxLines: 2,
    );
  }
}

class BorderRadiusStyle {
  // Custom borders
  static BorderRadius get customBorderTL10 => BorderRadius.horizontal(
        left: Radius.circular(10.h),
      );
  static BorderRadius get customBorderTL18 => BorderRadius.vertical(
        top: Radius.circular(18.h),
      );
// Rounded borders
  static BorderRadius get roundedBorder10 => BorderRadius.circular(
        10.h,
      );
  static BorderRadius get roundedBorder14 => BorderRadius.circular(
        14.h,
      );
  static BorderRadius get roundedBorder34 => BorderRadius.circular(
        34.h,
      );
  static BorderRadius get roundedBorder5 => BorderRadius.circular(
        5.h,
      );
  static BorderRadius get roundedBorder15 => BorderRadius.circular(
        15.h,
      );
}
