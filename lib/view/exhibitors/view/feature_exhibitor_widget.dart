import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


import '../../../routes/my_constant.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/button/custom_icon_button.dart';
import '../../Notes/view/featureNetworkingPage.dart';

class FeatureExhibitorWidget extends StatelessWidget {
  const FeatureExhibitorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.only(right: 18),
        child: CustomIconButton(
          onTap: () {
            Get.toNamed(FeatureNetworkingPage.routeName,
                arguments: {MyConstant.isNotes: false});
          },
          height: 33,
          width: 161.adaptSize,
          decoration: BoxDecoration(
              color: colorLightGray, borderRadius: BorderRadius.circular(3)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    child: Text(
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  "Featured Attendees",
                  style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.fSize),
                )),
                const SizedBox(
                  width: 4,
                ),
                SvgPicture.asset(
                  "assets/svg/common_arrow.svg",
                  color: white,
                  height: 11,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
