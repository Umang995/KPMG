
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/startNetworking/view/investerAndMentoring/InvestorListPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/image_constant.dart';
import '../../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../../widgets/app_bar/custom_app_bar.dart';
import '../../../../widgets/textview/customTextView.dart';
import '../../../../widgets/button/custom_icon_button.dart';
import '../../../../widgets/toolbarTitle.dart';
import '../angelAlly/angelHallListpage.dart';

class NetworkingDashboard extends StatelessWidget {
  static const routeName = "/NetworkingDashboard";
  const NetworkingDashboard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        height: 72.v,
        leadingWidth: 45.h,
        leading: AppbarLeadingImage(
          imagePath: ImageConstant.imgArrowLeft,
          margin: EdgeInsets.only(
            left: 7.h,
            top: 3,
            // bottom: 12.v,
          ),
          onTap: () {
            Get.back();
          },
        ),
        title: const ToolbarTitle(title: "Aspire"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            parentItemName(
                iconPath: "angel_ally.svg",
                title: "Angel Ally",
                index: 0,
                context: context),
            parentItemName(
                iconPath: "mentoring_zone.svg",
                title: "Mentoring Zone",
                index: 1,
                context: context),
            parentItemName(
                iconPath: "investor_zone.svg",
                title: "Investor Zone",
                index: 2,
                context: context),
          ],
        ),
      ),
    );
  }

  Widget parentItemName(
      {iconPath, title, index, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: CustomIconButton(
        height: 99.adaptSize,
        width: context.width,
        decoration: BoxDecoration(
          color: colorLightGray,
          border: Border.all(color: Colors.transparent, width: 0),
          borderRadius: BorderRadius.circular(10),
        ),
        onTap: () async {
          switch (index) {
            case 0:
              //UiHelper.showSuccessMsg(context, "Coming soon");
              Get.toNamed(AngelHallListPage.routeName);
              break;
            case 1:
              Get.toNamed(InvestorListPage.routeName,
                  arguments: {"title": title, "isInvestor": false});
              break;
            case 2:
              Get.toNamed(InvestorListPage.routeName,
                  arguments: {"title": title, "isInvestor": true});
              break;
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/$iconPath",
                    height: 37,
                    width: 60,
                    color: colorSecondary,
                  ),
                  SizedBox(
                    width: 25.adaptSize,
                  ),
                  CustomTextView(
                    text: title,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )
                ],
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
