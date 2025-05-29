import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/image_constant.dart';
import '../../widgets/textview/customTextView.dart';

class ResourceCenterSkeleton extends StatelessWidget {
  bool? isFromHome;
  ResourceCenterSkeleton({Key? key, this.isFromHome}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isFromHome ?? false ? colorLightGray : Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        itemCount: 10,
        itemBuilder: (context, index) => Container(
          padding: EdgeInsets.symmetric(vertical: 18.v, horizontal: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 12.h,
                    ),
                    Expanded(
                      child: CustomTextView(
                        text: "title of the resource center and skleton",
                        maxLines: 2,
                        color: colorSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.fSize,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 30,
                width: 30,
                color: Colors.white,
              )
            ],
          ),
        ),
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 1,
            color: borderColor,
          );
        },
      ),
    );
  }
}
