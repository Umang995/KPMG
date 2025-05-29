import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../theme/ui_helper.dart';
import '../../widgets/textview/customTextView.dart';
class AboutSkeletonWidget extends StatelessWidget {
  const AboutSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding: const EdgeInsets.all(16),
                decoration:  BoxDecoration(
                  color: colorLightGray,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: CustomTextDescView(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  textAlign: TextAlign.start,
                  color: colorSecondary,
                  text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type when an unknown printer took a galley of type  and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. Letraset sheets containing Lorem Ipsum passages, and more recently with desktop. publishing software like Aldus PageMaker including versions of Lorem Ipsum. Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy  Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries",
                ),
              ),
            ),
            SizedBox(
              height: 12.v,
            ),
           // buildSocialLink(context)
          ],
        ),
      ],
    );
  }
  Widget buildSocialLink(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorLightGray,
        borderRadius: BorderRadius.circular(15.adaptSize),
      ),
      padding: EdgeInsets.symmetric(
          vertical: 25.adaptSize, horizontal: 20.adaptSize),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomTextView(
            text: "social_media".tr,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
          SizedBox(width: 10,),
          Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  spacing: 10,
                  children: <Widget>[
                    for (var i=0;i<5; i++)
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: SizedBox(
                          height: 32,
                          width: 40,
                          child: SvgPicture.asset(
                            UiHelper.getSocialIcon(
                                "facebook"),
                          ),
                        ),
                      ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

}
