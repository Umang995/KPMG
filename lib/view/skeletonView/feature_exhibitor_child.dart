import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/exhibitors/controller/exhibitorsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../theme/app_colors.dart';
import '../../theme/ui_helper.dart';
import '../../utils/dialog_constant.dart';
import '../../widgets/animatedBookmark/AnimatedBookmarkWidget.dart';
import '../../widgets/customImageWidget.dart';
import '../../widgets/textview/customTextView.dart';
import '../../widgets/loading.dart';
import '../beforeLogin/globalController/authentication_manager.dart';

class FeatureExhibitorChild extends GetView<BoothController> {
  FeatureExhibitorChild({super.key});
  final AuthenticationManager authenticationManager = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetX<BoothController>(
      builder: (controller) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 122),
          child: Skeletonizer(
            enabled: controller.isFirstLoadRunning.value,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.isFirstLoadRunning.value
                  ? 2
                  : controller.exhibitorsFeatureList.length,
              itemBuilder: (context, index) {
                return controller.isFirstLoadRunning.value
                    ? _buildSkeletonItem(context)
                    : _buildExhibitorItem(
                        context, controller.exhibitorsFeatureList[index]);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonItem(BuildContext context) {
    return _buildContainer(
      context,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 100),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextPlaceholder(16),
                    SizedBox(height: 9.v),
                    _buildTextPlaceholder(14),
                    _buildTextPlaceholder(14),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExhibitorItem(BuildContext context, dynamic exhibitor) {
    return InkWell(
      onTap: () {
        controller.getExhibitorsDetail(exhibitor.id);
      },
      child: _buildContainer(
        context,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImage(exhibitor.avatar),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextView(
                            text: exhibitor.fasciaName ?? "",
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            maxLines: 1),
                        SizedBox(height: 9.v),
                        _buildDetailText(
                            "Booth No. ${exhibitor.boothNumber ?? ""}"),
                        _buildDetailText(
                            "Hall No. ${exhibitor.hallNumber ?? ""}"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
                right: 0,
                top: 0,
                child: controller.isBookmarkLoaded.value == false
                    ? AnimatedBookmarkWidget(
                        id: exhibitor.id,
                        bookMarkIdsList: controller.bookMarkIdsList,
                        padding: const EdgeInsets.all(6),
                        onTap: () async {
                          await controller.bookmarkToExhibitorItem(
                              id: exhibitor.id,
                              itemType: "exhibitor",
                              context: context);
                        },
                      )
                    : const FavLoading())
          ],
        ),
      ),
    );
  }

  Widget _buildContainer(BuildContext context, {required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      width: context.width * 0.8,
      decoration: BoxDecoration(
        color: colorLightGray,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(padding: EdgeInsets.all(8), child: child),
    );
  }

  Widget _buildTextPlaceholder(double fontSize) =>
      CustomTextView(text: "", fontSize: fontSize, color: colorGray);

  Widget _buildDetailText(String text) => Padding(
      padding: EdgeInsets.zero,
      child: CustomTextView(text: text, fontSize: 14, color: colorGray));

  Widget _buildImage(String? imageUrl) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: white, borderRadius: BorderRadius.all(Radius.circular(10))),
      height: 102.adaptSize,
      width: 102.adaptSize,
      child: UiHelper.getExhibitorImage(imageUrl: imageUrl ?? ""),
    );
  }
}
