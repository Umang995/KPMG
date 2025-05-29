import 'package:dreamcast/core/extension/content_extension.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../theme/app_decoration.dart';

class CommonMaterialButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color, textColor, borderColor;
  final double textSize;
  final double height;
  final double? width;
  final double radius;
  final double borderWidth;
  final FontWeight weight;
  final String? svgIcon;
  final double? iconHeight;
  final bool isLoading;
  final bool isWrap;
  final Color? iconColor;

  const CommonMaterialButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.textSize = 20,
    this.height = 55,
    this.width,
    this.radius = 10,
    this.svgIcon,
    this.borderWidth = 0,
    this.borderColor,
    this.iconHeight,
    this.isLoading = false,
    this.isWrap = false,
    this.iconColor,
    this.weight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? Theme.of(context).colorScheme.primary;
    final themeTextColor = textColor ?? Theme.of(context).highlightColor;
    final themeBorderColor = borderColor ?? Colors.transparent;
    final size = MediaQuery.of(context).size;

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          margin: isWrap
              ? null
              : EdgeInsets.fromLTRB(0, 10, 0, svgIcon != null ? 0 : 10),
          width: isWrap ? null : width ?? size.width,
          height: /*isWrap ? null :*/ height,
          child: MaterialButton(
            elevation: 0,
            animationDuration: const Duration(milliseconds: 300),
            color: themeColor,
            disabledColor: themeColor,
            hoverColor: themeColor.withOpacity(0.85),
            splashColor: themeColor.withOpacity(0.65),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: BorderSide(
                color: themeBorderColor,
                width: borderWidth,
              ),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: isLoading ? () {} : onPressed,
            child: isLoading
                ? SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      color: themeTextColor,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (svgIcon != null) ...[
                        SvgPicture.asset(svgIcon!,
                            height: iconHeight ?? 12,
                            colorFilter: text == "continue_with_linkedin".tr
                                ? null
                                : ColorFilter.mode(
                                    iconColor ??
                                        Theme.of(context).colorScheme.onSurface,
                                    BlendMode.srcIn)),
                        const SizedBox(width: 10),
                      ],
                      Flexible(
                        child: CustomTextView(
                          text: text,
                          color: themeTextColor,
                          fontSize: textSize,
                          fontWeight: weight,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
