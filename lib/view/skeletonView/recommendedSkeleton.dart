
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import '../../widgets/customImageWidget.dart';
import '../../widgets/textview/customTextView.dart';

class Recommendedskeleton extends StatelessWidget {
  const Recommendedskeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * .22,
      child: ListView.separated(
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 130.adaptSize,
              width: 122.adaptSize,
              child: CustomSqureImageWidget(
                  imageUrl: "",
                  shortName: "hello".tr),
            ),
            SizedBox(
              height: 8.v,
            ),
             CustomTextView(
              text: "type",
              color: colorPrimary,
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
             CustomTextView(
              text: "user name",
              color: colorSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
             Flexible(
                child: CustomTextView(
                  text: "dremacast",
                  color: colorGray,
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                )),
          ],
        ), separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 17.v);
      },
      ),
    );
  }
}
