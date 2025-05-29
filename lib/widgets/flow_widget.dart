import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../view/account/model/createProfileModel.dart';

class MyFlowWidget extends StatelessWidget {
  final String text;
  bool isBgColor = false;

  MyFlowWidget(this.text, {super.key, required this.isBgColor});

  @override
  Widget build(BuildContext context) {
    return text.isNotEmpty
        ? Container(
            margin: const EdgeInsets.only(top: 6),
            padding: EdgeInsets.all(isBgColor ? 6 : 0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color: white,
                border: Border.all(
                    color: isBgColor ? colorLightGray : Colors.transparent)),
            child: CustomTextView(
              text: text,
              color: colorSecondary,
              textAlign: TextAlign.start,
              fontSize: 14,
              fontWeight: FontWeight.normal,
              maxLines: 3,
            ),
          )
        : const SizedBox();
  }
}

///used in profile section
class MyFlowWidgetCross extends StatelessWidget {
  final String text;
  ProfileFieldData createFieldBody;
  final Function press;

  MyFlowWidgetCross(
    this.text, {
    super.key,
    required this.createFieldBody,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return text.isNotEmpty
        ? SizedBox(
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 3, right: 8,bottom: 5),
                  padding: const EdgeInsets.all(true ? 6 : 0),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: white,
                      border: Border.all(color: borderColor)),
                  child: CustomTextView(
                    text: text,
                    color: colorSecondary,
                    textAlign: TextAlign.start,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    maxLines: 3,
                  ),
                ),
                Positioned(
                  right: -0,
                  top: -5,
                  child: GestureDetector(
                    onTap: () {
                      if (createFieldBody.value.contains(text.toString())) {
                        createFieldBody.value.remove(text);
                      }
                      press();
                    },
                    child: SvgPicture.asset(
                      "assets/svg/img_close.svg",
                      width: 22,
                    ),
                  ),
                )
              ],
            ),
          )
        : const SizedBox();
  }
}

class FlowWidgetWithClose extends StatelessWidget {
  final String text;
  final Function(String)? onTap;
  bool isBgColor = false;
  FlowWidgetWithClose(
      {super.key,
      required this.text,
      required this.isBgColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return text.isNotEmpty
        ? SizedBox(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 3, right: 8),
                  padding: EdgeInsets.all(isBgColor ? 6 : 0),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: white,
                      border: Border.all(color: borderColor)),
                  child: CustomTextView(
                    text: text,
                    color: colorSecondary,
                    textAlign: TextAlign.start,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    maxLines: 3,
                  ),
                ),
                Positioned(
                  right: -0,
                  top: -5,
                  child: GestureDetector(
                    onTap: () {
                      onTap?.call(text);
                    },
                    child: SvgPicture.asset(
                      "assets/svg/img_close.svg",
                      width: 22,
                    ),
                  ),
                )
              ],
            ),
          )
        : const SizedBox();
  }
}

class FlowWidgetWithObjectClose extends StatelessWidget {
  final String text;
  final String id;
  final Function(String)? onTap;
  FlowWidgetWithObjectClose(
      {super.key, required this.text, required this.id, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return text.isNotEmpty
        ? SizedBox(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 3, right: 8),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: white,
                      border: Border.all(color: borderColor)),
                  child: CustomTextView(
                    text: text,
                    color: colorSecondary,
                    textAlign: TextAlign.start,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    maxLines: 3,
                  ),
                ),
                Positioned(
                  right: -0,
                  top: -5,
                  child: GestureDetector(
                    onTap: () {
                      onTap?.call(id);
                    },
                    child: SvgPicture.asset(
                      "assets/svg/img_close.svg",
                      width: 22,
                    ),
                  ),
                )
              ],
            ),
          )
        : const SizedBox();
  }
}

///used for the global search
class SearchFlowWidget extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final Function(String)? onTap;

  SearchFlowWidget(this.text,
      {super.key,
      required this.color,
      required this.textColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return text.isNotEmpty
        ? InkWell(
            onTap: () {
              onTap?.call(text);
            },
            child: Container(
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  color: color,
                  border: Border.all(color: white)),
              child: CustomTextView(
                text: text,
                color: textColor,
                textAlign: TextAlign.start,
                fontSize: 18,
                fontWeight: FontWeight.normal,
                maxLines: 3,
              ),
            ),
          )
        : const SizedBox();
  }
}
