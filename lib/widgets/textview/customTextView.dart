import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/color_extensions.dart';

abstract class BaseTextView extends StatelessWidget {
  final String text;
  final Color? color;
  final double fontSize;
  final bool underline;
  final bool centerUnderline;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final int? maxLines;
  final bool softWrap;
  final TextOverflow? textOverflow;
  final double? height;

  const BaseTextView({
    Key? key,
    required this.text,
    required this.color,
    required this.fontSize,
    required this.underline,
    required this.centerUnderline,
    required this.textAlign,
    required this.fontWeight,
    this.maxLines,
    this.softWrap = true,
    this.textOverflow,
    this.height,
  }) : super(key: key);

  TextStyle getTextStyle() {
    return TextStyle(
      color: color ?? colorSecondary,
      fontWeight: fontWeight,
      fontSize: fontSize.fSize,
      height: height,
      decoration: underline
          ? TextDecoration.underline
          : centerUnderline
              ? TextDecoration.lineThrough
              : TextDecoration.none,
    );
  }
}

class CustomTextView extends BaseTextView {
  const CustomTextView({
    Key? key,
    required String text,
    Color? color,
    double fontSize = 14,
    bool underline = false,
    bool centerUnderline = false,
    TextAlign textAlign = TextAlign.start,
    FontWeight fontWeight = FontWeight.w500,
    int? maxLines,
    bool softWrap = true,
    TextOverflow? overflow,
  }) : super(
          key: key,
          text: text,
          color: color,
          fontSize: fontSize,
          underline: underline,
          centerUnderline: centerUnderline,
          textAlign: textAlign,
          fontWeight: fontWeight,
          maxLines: maxLines,
          softWrap: softWrap,
          textOverflow: overflow,
        );

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines ?? 500,
      softWrap: softWrap,
      overflow: textOverflow ?? TextOverflow.ellipsis,
      style: getTextStyle(),
    );
  }
}

class CustomTextDescView extends BaseTextView {
  const CustomTextDescView({
    Key? key,
    required String text,
    Color color = Colors.black,
    double fontSize = 14,
    bool underline = false,
    bool centerUnderline = false,
    TextAlign textAlign = TextAlign.start,
    FontWeight fontWeight = FontWeight.bold,
    int? maxLines,
    bool softWrap = true,
  }) : super(
          key: key,
          text: text,
          color: color,
          fontSize: fontSize,
          underline: underline,
          centerUnderline: centerUnderline,
          textAlign: textAlign,
          fontWeight: fontWeight,
          maxLines: maxLines,
          softWrap: softWrap,
          height: 2,
        );

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines ?? 500,
      softWrap: softWrap,
      style: getTextStyle(),
    );
  }
}

class CustomReadMoreText extends BaseTextView {
  const CustomReadMoreText({
    Key? key,
    required String text,
    Color color = Colors.black,
    double fontSize = 14,
    bool underline = false,
    bool centerUnderline = false,
    TextAlign textAlign = TextAlign.start,
    FontWeight fontWeight = FontWeight.bold,
    int? maxLines,
    bool softWrap = true,
  }) : super(
          key: key,
          text: text,
          color: color,
          fontSize: fontSize,
          underline: underline,
          centerUnderline: centerUnderline,
          textAlign: textAlign,
          fontWeight: fontWeight,
          maxLines: maxLines,
          softWrap: softWrap,
        );

  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      text,
      trimMode: TrimMode.Line,
      trimLines: maxLines ?? 4,
      colorClickableText: accentColor,
      trimCollapsedText: 'Read more',
      trimExpandedText: ' Read less',
      lessStyle: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w500, color: colorPrimary),
      textAlign: textAlign,
      style: getTextStyle(),
      moreStyle: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w500, color: colorPrimary),
    );
  }
}

class AutoCustomTextView extends BaseTextView {
  final double height;

  const AutoCustomTextView({
    Key? key,
    required String text,
    Color? color,
    double fontSize = 14,
    bool underline = false,
    bool centerUnderline = false,
    TextAlign textAlign = TextAlign.start,
    int maxLines = 1,
    FontWeight fontWeight = FontWeight.normal,
    this.height = 1.0,
  }) : super(
          key: key,
          text: text,
          color: color,
          fontSize: fontSize,
          underline: underline,
          centerUnderline: centerUnderline,
          textAlign: textAlign,
          fontWeight: fontWeight,
          maxLines: maxLines,
          height: height,
        );

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      minFontSize: fontSize,
      maxFontSize: double.infinity,
      style: getTextStyle(),
    );
  }
}
