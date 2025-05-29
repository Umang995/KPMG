import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'base_button.dart';

class CustomOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final ButtonStyle? buttonStyle;
  final TextStyle? buttonTextStyle;
  final bool? isDisabled;
  final String text;
  final double? height;
  final double? width;

  final EdgeInsetsGeometry? margin;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.buttonStyle,
    this.buttonTextStyle,
    this.isDisabled,
    this.height,
    this.width,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 48,
      width: double.maxFinite,
      margin: margin,
      child: OutlinedButton(
        style: buttonStyle,
        onPressed: isDisabled == true ? null : onPressed,
        child: Text(
          text,
          style: buttonTextStyle,
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
