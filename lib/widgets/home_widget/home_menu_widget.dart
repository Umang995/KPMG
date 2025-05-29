import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/menu/model/menu_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../routes/my_constant.dart';
import '../../theme/app_colors.dart';
import '../../view/menu/controller/menuController.dart';
import '../textview/customTextView.dart';

class HomeMenuWidget extends StatelessWidget {
  MenuData menuData;
  HomeMenuWidget({super.key, required this.menuData});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 1 / 1,
          child: MaterialButton(
            elevation: 1,
            color: colorPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            onPressed: () async {
              HubController hubController = Get.find();
              hubController.commonMenuRouting(menuData: menuData);
            },
            child: Center(
              child: SvgPicture.network(menuData.icon ?? "",
                  height: 40.h,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).highlightColor, BlendMode.srcIn)),
            ),
          ),
        ),
        SizedBox(
          height: 6.v,
        ),
        CustomTextView(
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          text: menuData.label ?? "",
          color: colorSecondary,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ],
    );
  }
}

class HomeMenuSkeleton extends StatelessWidget {
  HomeMenuSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 1 / 1,
          child: MaterialButton(
            elevation: 1,
            color: colorPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                width: 0,
                color: borderColor,
              ),
            ),
            padding: const EdgeInsets.all(10),
            onPressed: () {},
            child: Text(""),
          ),
        ),
        SizedBox(
          height: 6.v,
        ),
        Text(
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          "",
          style: TextStyle(
            color: colorSecondary,
            fontWeight: FontWeight.w500,
            fontSize: 13.fSize,
          ),
        ),
      ],
    );
  }
}
