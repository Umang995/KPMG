import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/account/controller/account_controller.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/widgets/custom_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileSkeleton extends StatelessWidget {
  ProfileSkeleton({Key? key}) : super(key: key);

  final AccountController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 60.v),
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: colorGray,
                  blurRadius: 10.0,
                ),
              ],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(19), topRight: Radius.circular(19))),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 60.v,
              ),
              profileNameWidget(),
              SizedBox(
                height: 24.v,
              ),
              exploreMenuWidget(context),
              SizedBox(
                height: 24.v,
              ),
              infoWidget(),
              SizedBox(
                height: 24.v,
              ),
              infoWidget(),
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Skeleton.shade(
            child: CustomProfileImage(
              profileUrl: "",
              shortName: "",
              borderColor: colorGray,
              isAccountPage: true,
            ),
          ),
        )
      ],
    );
  }

  exploreMenuWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: 120.v,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 1 / 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: colorLightGray,
                      shape: BoxShape.rectangle,
                      //border: Border.all(color: menuBorderColor, width: 1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                ),
              ),
              SizedBox(
                height: 12.v,
              ),
              AutoCustomTextView(
                  text: "",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  color: colorSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 12)
            ],
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 5 / 7,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12),
      ),
    );
  }

  infoWidget() {
    return Container(
      decoration: BoxDecoration(
          color: colorLightGray,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.only(bottom: 0.h, right: 16.h, left: 16.h, top: 8.v),
            child: CustomTextView(
              text: "",
              maxLines: 2,
              color: colorSecondary,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: 4,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                //color: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 14.v, horizontal: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomTextView(
                          text: "email",
                          maxLines: 2,
                          color: colorGray,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        SizedBox(
                          width: 12.h,
                        ),
                        CustomTextView(
                          text: "email@mailnator.com",
                          maxLines: 2,
                          color: colorSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ],
                    ),
                    SvgPicture.asset("assets/svg/temp_arrow_details.svg")
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                height: 1,
                color: borderColor,
              );
            },
          ),
        ],
      ),
    );
  }

  profileNameWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextView(
            maxLines: 1,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            text: "user name"),
        CustomTextView(
            maxLines: 2,
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: colorGray,
            text: "Business manager"),
        const SizedBox(
          height: 18,
        ),
      ],
    );
  }

  buildSocialMediaWidget(List<dynamic> params, String title) {
    return params.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
                CustomTextView(
                  text: title.capitalize ?? "",
                  color: colorSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 8,
                ),
                Wrap(
                  spacing: 10,
                  children: <Widget>[
                    for (var item in params ?? [])
                      Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: SizedBox(
                            height: 25,
                            width: 25,
                            child: InkWell(
                                onTap: () {
                                  UiHelper.inAppWebView(
                                      Uri.parse(item.value.toString()));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: colorGray, width: 1)),
                                    padding: const EdgeInsets.all(1),
                                    child: SvgPicture.asset(
                                      UiHelper.getSocialIcon(
                                          item.label.toString().toLowerCase()),
                                    ))),
                          )),
                  ],
                )
              ])
        : const SizedBox();
  }
}
