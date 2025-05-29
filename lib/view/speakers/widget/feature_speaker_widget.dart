import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/speakers/controller/speakerNetworkController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/dialog_constant.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/animatedBookmark/AnimatedBookmarkWidget.dart';
import '../../../widgets/customImageWidget.dart';
import '../../../widgets/textview/customTextView.dart';
import '../../../widgets/loading.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../controller/speakersController.dart';

class FeatureSpeakerWidget extends GetView<SpeakerNetworkController> {
  FeatureSpeakerWidget({super.key});
  final AuthenticationManager authenticationManager = Get.find();
  final SpeakersDetailController speakerDetailsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetX<SpeakerNetworkController>(
      builder: (controller) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 175.adaptSize),
          child: Skeletonizer(
            enabled: controller.isFirstFeatureLoading.value,
            child: controller.isFirstFeatureLoading.value
                ? ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 175.adaptSize,
                            decoration: BoxDecoration(
                                color: colorLightGray,
                                shape: BoxShape.rectangle,
                                border:
                                    Border.all(color: borderColor, width: 1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DetailImageWidget(
                                    imageUrl: "",
                                    shortName: "UN",
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  CustomTextView(
                                    text: "Name",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    textAlign: TextAlign.start,
                                    color: colorSecondary,
                                  ),
                                  SizedBox(height: 4.v),
                                  CustomTextView(
                                    text: "Position",
                                    fontSize: 14,
                                    maxLines: 1,
                                    color: colorGray,
                                    fontWeight: FontWeight.normal,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        width: 14,
                      );
                    },
                  )
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.featureSpeakerList.length,
                    itemBuilder: (context, index) {
                      var speakerData = controller.featureSpeakerList[index];
                      return InkWell(
                        onTap: () async {
                          controller.isLoading(true);
                          await controller.userDetailController
                              .getSpeakerDetail(
                                  speakerId: speakerData.id,
                                  isSessionSpeaker: true,
                                  role: speakerData.role);
                          controller.isLoading(false);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 175.adaptSize,
                              decoration: BoxDecoration(
                                  color: colorLightGray,
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                      color: borderColor, width: 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomImageWidget(
                                      imageUrl: speakerData.avatar ?? "",
                                      shortName: speakerData.shortName ?? "",
                                      color: white,
                                      size: 85.adaptSize,
                                    ),
                                    const SizedBox(
                                      height: 9,
                                    ),
                                    CustomTextView(
                                      text:
                                          speakerData.name?.toString().trim() ??
                                              "",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.center,
                                      color: colorSecondary,
                                    ),
                                    SizedBox(height: 4.v),
                                    speakerData.position.toString().isEmpty
                                        ? const SizedBox()
                                        : CustomTextView(
                                            text: speakerData.position ?? "",
                                            fontSize: 14,
                                            maxLines: 1,
                                            color: colorGray,
                                            fontWeight: FontWeight.normal,
                                            textAlign: TextAlign.start,
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              right: 12,
                              top: 6,
                              child: Obx(
                                () => Container(
                                  color: Colors.transparent,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      speakerDetailsController
                                                  .isBookmarkLoading.value ==
                                              false
                                          ? AnimatedBookmarkWidget(
                                              height: 22,
                                              id: speakerData.id ?? "",
                                              bookMarkIdsList:
                                                  speakerDetailsController
                                                      .bookMarkIdsList,
                                              padding: const EdgeInsets.all(6),
                                              onTap: () async {
                                                await speakerDetailsController
                                                    .bookmarkToUser(
                                                        speakerData.id,
                                                        speakerData.role);
                                              },
                                            )
                                          : const FavLoading(),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        width: 14,
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
