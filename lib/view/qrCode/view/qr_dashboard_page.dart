import 'package:dreamcast/theme/app_decoration.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/qrCode/view/QRScanner.dart';
import 'package:dreamcast/view/contact/view/contact_list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/my_constant.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/toolbarTitle.dart';
import 'myBadge.dart';
import '../controller/qr_page_controller.dart';

class QRDashboardPage extends StatefulWidget {
  const QRDashboardPage({Key? key}) : super(key: key);
  static const routeName = "/QrScanPage";

  @override
  State<QRDashboardPage> createState() => _QRDashboardPageState();
}

class _QRDashboardPageState extends State<QRDashboardPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final AuthenticationManager controller = Get.find();
  final QrPageController qrPageController = Get.find();
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
  }

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
        title: ToolbarTitle(
            title: Get.arguments?[MyConstant.titleKey] ?? "my_badge".tr),
      ),
      body: Padding(
        padding: AppDecoration.commonTabPadding(),
        child: Scaffold(
          appBar: TabBar(
            isScrollable: true,
            dividerColor: Colors.transparent,
            indicatorColor: Colors.transparent,
            tabAlignment: TabAlignment.start,
            controller: qrPageController.tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            onTap: (int index) {
              if (index == 0) {
                qrPageController.clearQr();
                qrPageController.getUniqueCode();
              }
              qrPageController.tabController.index = index;
            },
            tabs: [
              Tab(text: "my_code".tr),
              Tab(text: "scan".tr),
              Tab(text: "myContact".tr),
            ],
          ),
          body: TabBarView(
            controller: qrPageController.tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              MyBadgePage(),
              const QRScannerPage(),
              MyContactListPage()
            ],
          ),
        ),
      ),
    );
  }
}
