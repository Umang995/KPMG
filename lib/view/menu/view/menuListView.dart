import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:dreamcast/view/menu/model/menu_data_model.dart';
import 'package:dreamcast/view/skeletonView/hub_skeleton_widget.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/button/custom_menu_button.dart';
import '../controller/menuController.dart';
import '../../../widgets/textview/customTextView.dart';

class HubMenuPage extends GetView<HubController> {
  static const routeName = "/MenuListView";

  HubMenuPage({Key? key}) : super(key: key);

  final DashboardController dashboardController = Get.find();
  final AuthenticationManager authenticationManager = Get.find();

  ///refresh the page.
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  var selectedParentIndex = -1;
  bool _isButtonDisabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 4),
      width: context.width,
      height: context.height,
      child: GetX<HubController>(
        builder: (controller) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: RefreshIndicator(
                  color: colorLightGray,
                  backgroundColor: colorPrimary,
                  strokeWidth: 1.0,
                  key: _refreshIndicatorKey,
                  onRefresh: () {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        controller.getHubMenuAPi(isRefresh: true);
                      },
                    );
                  },
                  child: SingleChildScrollView(
                    child: Skeletonizer(
                      enabled: controller.loading.value,
                      child: controller.loading.value
                          ? HubSkeletonWidget()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                controller.hubTopMenu.isEmpty
                                    ? const SizedBox()
                                    : buildParentMenuList(context),
                                SizedBox(
                                  height:
                                      controller.hubTopMenu.isEmpty ? 0 : 20,
                                ),
                                buildMenuList(context)
                              ],
                            ),
                    ),
                  ),
                ),
              ),
              controller.contentLoading.value
                  ? const Loading()
                  : const SizedBox()
            ],
          );
        },
      ),
    );
  }

  buildMenuList(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.hubMenuMain.length,
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
      child: Skeletonizer(
        enabled: controller.loading.value,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: controller.hubTopMenu.length,
          itemBuilder: (context, index) => buildParentMenuBody(index, context),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1 / 1,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15),
        ),
      ),
    );
  }

  buildParentMenuBody(int index, BuildContext context) {
    MenuData menuData = controller.hubTopMenu[index];
    return CommonMenuButton(
      color: Theme.of(Get.context!).scaffoldBackgroundColor,
      borderColor: borderColor,
      borderWidth: 1,
      borderRadius: 15,
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.network(
            colorFilter: ColorFilter.mode(colorSecondary,
                BlendMode.srcIn), // This applies the color to the entire SVG
            menuData.icon ?? "",
            height: 32.h,
            placeholderBuilder: (context) {
              return const SizedBox(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                ),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          AutoCustomTextView(
            text: menuData.label ?? "",
            color: colorSecondary,
            fontWeight: FontWeight.w500,
            fontSize: 12,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      onTap: () async {
        if (_isButtonDisabled) return; // Prevent further clicks
        _isButtonDisabled = true;
        Future.delayed(const Duration(seconds: 1), () {
          _isButtonDisabled =
              false; // Re-enable the button after the screen is closed
        });
        controller.commonMenuRouting(menuData: menuData);
      },
    );
  }

  buildChildMenuBody(int index, BuildContext context) {
    MenuData menuData = controller.hubMenuMain[index];
    print('secondary :${colorSecondary}');

    return GestureDetector(
      child: CommonMenuButton(
        color: colorLightGray,
        widget: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.network(
                colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.secondary,
                    BlendMode.srcIn),
                menuData.icon ?? "",
                height: 45.adaptSize,
                //color: colorSecondary,
                placeholderBuilder: (context) {
                  return const SizedBox(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                  );
                },
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
              ),
            ],
          ),
        ),
        onTap: () async {
          if (_isButtonDisabled) return; // Prevent further clicks
          _isButtonDisabled = true;
          Future.delayed(const Duration(seconds: 1), () {
            _isButtonDisabled =
                false; // Re-enable the button after the screen is closed
          });
          controller.commonMenuRouting(menuData: menuData);
        },
      ),
    );
  }
}
