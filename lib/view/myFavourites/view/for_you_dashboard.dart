import 'package:dreamcast/theme/app_decoration.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/home/controller/for_you_controller.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/lunchpad_ai_widget.dart';
import '../../../widgets/textview/customTextView.dart';
import '../../../widgets/lunchpad_menu_label.dart';
import '../../../widgets/toolbarTitle.dart';
import 'favourite_dashboard.dart';

class ForYouDashboard extends GetView<ForYouController> {
  const ForYouDashboard({super.key});
  static const routeName = "/ForYouDashboard";

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
            title: Get.arguments?[MyConstant.titleKey] ?? "favourites".tr),
        //dividerHeight: 0,
      ),
      body: GetX<ForYouController>(
        builder: (controller) {
          return NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Container(
                    color: white,
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    child: buildHeaderWidget(),
                  ),
                ),
              ];
            },
            body: buildBodyWidget(),
          );
        },
      ),
    );
  }

  buildHeaderWidget() {
    return controller.recommendedList.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 20.adaptSize, left: 12.adaptSize, right: 12.adaptSize),
                child: LaunchpadMenuLabel(
                  title: "recommended_for_you".tr,
                  trailing: "view_all".tr,
                  index: 15,
                  trailingIcon: "",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: LaunchpadAIWidget(),
              ),
            ],
          )
        : const SizedBox();
  }

  buildBodyWidget() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            controller.recommendedList.isNotEmpty
                ? const SizedBox(
                    height: 20,
                  )
                : const SizedBox(),
            Expanded(child: BookmarkDashboard())
          ],
        ),
        controller.isLoading.value ? const Loading() : const SizedBox()
      ],
    );
  }
}
