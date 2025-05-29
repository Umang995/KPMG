import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/button/custom_menu_button.dart';

class HubSkeletonWidget extends StatelessWidget {
  static const routeName = "/MenuListView";
  HubSkeletonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildParentMenuList(context),
          const SizedBox(
            height: 20,
          ),
          buildMenuList(context)
        ],
      ),
    );
  }

  buildMenuList(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) => buildChildMenuBody(index, context),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 5 / 4,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
      ),
    );
  }

  // create the menu item
  buildParentMenuList(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 100.h),
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index) => buildParentMenuBody(index, context),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 1 / 1,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15),
      ),
    );
  }

  buildParentMenuBody(int index, BuildContext context) {
    return CommonMenuButton(
      color: white,
      borderColor: borderColor,
      borderWidth: 1,
      borderRadius: 15,
      widget: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [],
      ),
      onTap: () async {},
    );
  }

  buildChildMenuBody(int index, BuildContext context) {
    return GestureDetector(
      child: CommonMenuButton(
        color: colorLightGray,
        widget: const Padding(
          padding: EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /*SvgPicture.network(
                menuData.icon ?? "",
                height: 54.h,
              ),
              SizedBox(
                height: 16.h,
              ),
              AutoCustomTextView(
                text: menuData.label ?? "",
                color: colorSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),*/
            ],
          ),
        ),
        onTap: () {},
      ),
    );
  }
}
