import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/Notes/controller/featureNetworkingController.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/myFavourites/controller/favourite_controller.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../theme/app_colors.dart';
import '../theme/ui_helper.dart';
import '../utils/dialog_constant.dart';
import '../utils/image_constant.dart';
import '../view/myFavourites/controller/favourite_user_controller.dart';
import 'animatedBookmark/AnimatedBookmarkWidget.dart';
import 'recommended_widget.dart';
import 'customImageWidget.dart';
import 'loading.dart';
import '../view/representatives/controller/user_detail_controller.dart';

class UserListWidget extends StatelessWidget {
  dynamic representatives;
  bool isFromBookmark;
  bool? isApiLoading = false;
  final Function press;

  UserListWidget({
    super.key,
    required this.representatives,
    required this.press,
    required this.isFromBookmark,
    this.isApiLoading,
  });

  final UserDetailController controller = Get.find();
  final AuthenticationManager authenticationManager = Get.find();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Future.delayed(Duration.zero, () async {
          press();
        });
      },
      child: Container(
        width: context.width,
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.only(left: 14, right: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(right: 2.v),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CustomImageWidget(
                          imageUrl: representatives.avatar ?? "",
                          shortName: representatives.shortName ?? "",
                          size: 70.adaptSize,
                          borderWidth: 0,
                        ),
                        SizedBox(width: 18.v),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextView(
                                  text:
                                      representatives.name?.toString().trim() ??
                                          "",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.start,
                                  // color: colorPrimaryDark,
                                ),
                                SizedBox(height: 4.v),
                                representatives?.position?.isNotEmpty ?? false
                                    ? CustomTextView(
                                        text:
                                            "${representatives.position ?? ""}",
                                        fontSize: 14,
                                        maxLines: 1,
                                        color: colorGray,
                                        fontWeight: FontWeight.normal,
                                        textAlign: TextAlign.start,
                                      )
                                    : const SizedBox(),
                                representatives?.company?.isNotEmpty ?? false
                                    ? CustomTextView(
                                        text:
                                            "${representatives.company ?? ""}",
                                        fontSize: 14,
                                        maxLines: 1,
                                        color: colorGray,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.start,
                                      )
                                    : const SizedBox(),
                                Row(
                                  children: [
                                    Obx(() => controller.recommendedIdsList
                                            .contains(representatives.id)
                                        ? const Padding(
                                            padding: EdgeInsets.only(
                                                top: 8, right: 8),
                                            child: RecommendedWidget(),
                                          )
                                        : const SizedBox()),
                                    representatives.isNotes == "1"
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: SvgPicture.asset(
                                                ImageConstant.notesIcon),
                                          )
                                        : const SizedBox()
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20.h),
                        (isApiLoading == true ||
                                representatives.isBlocked == "1")
                            ? const SizedBox()
                            : Align(
                                alignment: Alignment.topRight,
                                child: Obx(() => Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        controller.isBookmarkLoaded.value ==
                                                false
                                            ? AnimatedBookmarkWidget(
                                                id: representatives.id ?? "",
                                                bookMarkIdsList:
                                                    controller.bookMarkIdsList,
                                                padding:
                                                    const EdgeInsets.all(6),
                                                onTap: () {
                                                  controller.bookmarkToUser(
                                                      representatives.id,
                                                      representatives.role,
                                                      context);
                                                },
                                              )
                                            : const FavLoading(),
                                      ],
                                    ))),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    child: Divider(
                      color: borderColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
