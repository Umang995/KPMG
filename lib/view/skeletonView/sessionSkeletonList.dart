import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/schedule/controller/session_controller.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/widgets/foundational_track_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SessionListSkeleton extends StatelessWidget {
  const SessionListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) => const ListBody(),
    );
  }
}

class ListBody extends GetView<SessionController> {
  const ListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      child: Container(
        padding: EdgeInsets.all(12.v),
        margin: EdgeInsets.only(bottom: 14.v),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: UiHelper.getColorByHexCode("")),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTracksListview(context),
                Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.circle, size: 10),
                        const SizedBox(
                          width: 6,
                        ),
                        CustomTextView(
                          text: "dummy",
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Icon(Icons.bookmark)
                  ],
                )
              ],
            ),
            SizedBox(
              height: 8.v,
            ),
            CustomTextView(
              text: "bkfbdgkdkfngjdfn",
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w500,
              fontSize: 16.h,
              color: colorGray,
            ),
            SizedBox(
              height: 5.v,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextView(
                      text: "bkfbdgkdkfngjdfn",
                      textAlign: TextAlign.start,
                      color: colorSecondary,
                      maxLines: 1,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                    CustomTextView(
                      text: "bkfbdgkdkfngjdfnddb",
                      textAlign: TextAlign.start,
                      color: colorSecondary,
                      maxLines: 1,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ],
                ),
                Icon(Icons.chevron_right)
              ],
            ),
            Divider(
              height: 10.v,
              thickness: 0.5,
              color: colorLightGray,
            ),
            Row(
              children: [
                const Icon(Icons.location_history),
                const SizedBox(width: 10),
                CustomTextView(
                  text: "bkfbdgkdkfngjdfn",
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.h,
                  color: colorGray,
                ),
              ],
            ),
            buildSpeakerListview(context),
          ],
        ),
      ),
    );
  }

  Widget buildSpeakerListview(BuildContext context) {
    var length = 3;

    return Container(
      margin: EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              color: Colors.transparent,
              height: 50.v,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    for (var i = 0; i < length; i++)
                      Positioned(
                        left: (i * (1 - .4) * 34).toDouble(),
                        child: Skeleton.unite(
                          child: Container(
                            width: 34.adaptSize,
                            height: 34.adaptSize,
                            margin: EdgeInsets.only(left: 0.h),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorLightGray,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Optionally, you can add more widgets here
          Expanded(child: arrowWidget()),
        ],
      ),
    );
  }

  Widget buildTracksListview(BuildContext context) {
    return Skeleton.shade(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(
              right: 10.0,
            ),
            child: FoundationalTrackWidget(
              title: "dummy",
              color: const Color(0xffCF138A),
            ),
          ),
        ],
      ),
    );
  }

  Widget arrowWidget() {
    return Skeleton.shade(
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 34.adaptSize,
              width: 34.adaptSize,
              padding: EdgeInsets.all(6.adaptSize),
              decoration: BoxDecoration(
                color: colorLightGray,
                borderRadius: BorderRadius.all(Radius.circular(5.adaptSize)),
              ),
              // child: SvgPicture.asset("assets/svg/ic_add_event.svg"),
              child: Center(
                child: SvgPicture.asset(
                  ImageConstant.ic_add_event,
                  height: 22.adaptSize,
                  width: 22.adaptSize,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Container(
              height: 34.adaptSize,
              width: 34.adaptSize,
              padding: EdgeInsets.all(6.adaptSize),
              decoration: BoxDecoration(
                color: colorLightGray,
                borderRadius: BorderRadius.all(Radius.circular(5.adaptSize)),
              ),
              // child: SvgPicture.asset("assets/svg/ic_arrow.svg"),
              child: Center(
                child: SvgPicture.asset(
                  ImageConstant.ic_arrow,
                  height: 16.adaptSize,
                  width: 16.adaptSize,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
