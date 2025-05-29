import 'package:dreamcast/core/extension/content_extension.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'base_button.dart';

class CommonMenuButton extends StatelessWidget {
  final Function onTap;
  final Color? color, borderColor;
  final double height;
  final double borderWidth;
  final double borderRadius;
  final Widget widget;

  CommonMenuButton({
    Key? key,
    required this.onTap,
    required this.widget,
    this.color,
    this.borderColor,
    this.borderWidth = 0.0,
    this.borderRadius = 20,
    this.height = 90,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final themeColor = color ?? colorPrimary;
    final themeBorderColor = borderColor ?? colorLightGray;

    return SizedBox(
      //height: height,
      width: context.width,
      child: MaterialButton(
        elevation: 0.3,
        color: themeColor,
        padding: const EdgeInsets.all(5),
        hoverColor: colorSecondary,
        //animationDuration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(width: borderWidth, color: themeBorderColor)),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () {
          Future.delayed(Duration.zero, () async {
            onTap();
          });
        },
        child: widget,
      ),
    );
  }
}
