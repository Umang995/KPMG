import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/guide/controller/info_guide_controller.dart';
import 'package:dreamcast/view/home/controller/home_controller.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/ui_helper.dart';
import '../../../widgets/textview/customTextView.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../skeletonView/about_skleton_widget.dart';
import '../../skeletonView/skeleton_event_feed.dart';

class InfoAboutPage extends GetView<InfoFaqController> {
  InfoAboutPage({super.key});

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return GetX<InfoFaqController>(
      builder: (controller) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Skeletonizer(
                          enabled: controller.isFirstLoading.value,
                          child: controller.isFirstLoading.value
                              ? const AboutSkeletonWidget()
                              : (controller.configDetailBody.value
                                                  .description ==
                                              null &&
                                          !controller.isFirstLoading.value) ||
                                      (controller.configDetailBody.value
                                              .description!.isEmpty &&
                                          !controller.isFirstLoading.value)
                                  ? const SizedBox()
                                  : Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      padding: const EdgeInsets.all(16),
                                      decoration:  BoxDecoration(
                                        color: colorLightGray,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                      child: CustomTextView(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        textAlign: TextAlign.start,
                                        color: colorSecondary,
                                        text: controller.configDetailBody.value
                                                .description ??
                                            "",
                                      ),
                                    ),
                        ),
                        SizedBox(
                          height: 12.v,
                        ),
                        controller.configDetailBody.value.socialLinks != null &&
                                controller.configDetailBody.value.socialLinks!
                                    .isNotEmpty
                            ? buildSocialLink(context)
                            : const SizedBox(),
                        SizedBox(
                          height: 30.v,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Align(alignment: Alignment.center, child: _progressEmptyWidget())
          ],
        );
      },
    );
  }

  Widget _progressEmptyWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      child: controller.isFirstLoading.value
          ? const SizedBox()
          : (controller.configDetailBody.value.description == null &&
                      !controller.isFirstLoading.value) ||
                  (controller.configDetailBody.value.description!.isEmpty &&
                      !controller.isFirstLoading.value)
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  Widget buildSocialLink(BuildContext context) {
    var socialItem = controller.configDetailBody.value.socialLinks ?? [];
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
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: 10,
              children: <Widget>[
                for (var item in socialItem)
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: SizedBox(
                      height: 32,
                      width: 40,
                      child: InkWell(
                        onTap: () {
                          UiHelper.inAppBrowserView(
                            Uri.parse(item.url.toString()),
                          );
                        },
                        child: SvgPicture.asset(
                          UiHelper.getSocialIcon(
                              item.type.toString().toLowerCase()),
                        ),
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
