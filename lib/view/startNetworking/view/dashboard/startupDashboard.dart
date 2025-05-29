import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/my_constant.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/image_constant.dart';
import '../../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../../widgets/app_bar/custom_app_bar.dart';
import '../../../../widgets/button/custom_icon_button.dart';
import '../../../../widgets/toolbarTitle.dart';
import '../../../dashboard/dashboard_controller.dart';
import '../../../exhibitors/view/bootListPage.dart';
import '../../../home/controller/home_controller.dart';
import '../pitchStage/pitchStageList.dart';
import 'networkingDashboard.dart';

class StartupDashboard extends GetView<HomeController> {
  StartupDashboard({Key? key}) : super(key: key);
  final DashboardController _dashboardController = Get.find();
  static const routeName = "/StartupDashboard";
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
        title: const ToolbarTitle(title: "Startup Networking"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            parentItemName(
                iconPath: "ic_pitchstage.png",
                title: "Pitch Stage",
                index: 0,
                context: context),
            parentItemName(
                iconPath: "ic_startup.png",
                title: "Startups",
                index: 1,
                context: context),
            parentItemName(
                iconPath: "ic_aspire.png",
                title: "Aspire",
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
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
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
              Get.toNamed(PitchStageList.routeName);
              break;
            case 1:
              Get.toNamed(
                BoothListPage.routeName,
                arguments: {
                  MyConstant.isStartup: true,
                  MyConstant.isNotes: false
                },
              );
              break;
            case 2:
              Get.toNamed(NetworkingDashboard.routeName);
              break;
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/icons/$iconPath",
                    height: 37,
                    width: 60,
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
