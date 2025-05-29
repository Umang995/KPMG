import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:dreamcast/core/extension/content_extension.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/app_decoration.dart';
import '../utils/image_constant.dart';
import 'textview/customTextView.dart';
import 'button/custom_icon_button.dart';

class AddCalenderWidget extends StatelessWidget {
  const AddCalenderWidget({
    super.key,
    this.onTap,
  });
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      // width: context.width*0.18.adaptSize,
      width: 71.adaptSize,
      height: 32.adaptSize,
      decoration: AppDecoration.decorationAddEvent,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.adaptSize),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ImageConstant.icAddEvent,
              height: 14.adaptSize,
              color: colorSecondary,
            ),
            SizedBox(
              width: 6.adaptSize,
            ),
            Flexible(
                child: CustomTextView(
              text: "Add",
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: colorSecondary,
            ))
          ],
        ),
      ),
    );
  }
}
