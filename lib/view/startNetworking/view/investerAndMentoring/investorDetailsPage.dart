import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/startNetworking/controller/invenstorController.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';
import '../../../../theme/ui_helper.dart';
import '../../../../utils/pref_utils.dart';
import '../../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../../widgets/app_bar/custom_app_bar.dart';
import '../../../../widgets/company_position_widget.dart';
import '../../../../widgets/customImageWidget.dart';
import '../../../../widgets/button/custom_icon_button.dart';
import '../../../../widgets/loading.dart';
import '../../../../widgets/toolbarTitle.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import '../../model/startNetworkingModel.dart';

class InvestorDetailPage extends GetView<InvestorController> {
  InvestorDetailPage({Key? key}) : super(key: key);
  static const routeName = "/InvestorDetailPage";
  var pageTitle = "".obs;
  final AuthenticationManager authManager = Get.find();
  var isInvestor = false;
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      pageTitle(Get.arguments != null
          ? Get.arguments!.toString().capitalizeFirst
          : "");

      if (Get.arguments != null) {
        isInvestor = Get.arguments;
      }
    }
    return Scaffold(
      backgroundColor: colorLightGray,
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
            controller.isLoading(false);
            Get.back();
          },
        ),
        title: ToolbarTitle(
            title: isInvestor ? "Investor Profile" : "Mentor Profile"),
        backgroundColor: colorLightGray,
        dividerHeight: 0,
      ),
      body: SizedBox(
        height: context.height,
        width: context.width,
        child: GetX<InvestorController>(
          builder: (controller) {
            UserAspireData? personalObject = controller.investorBody.value;
            return Stack(
              children: [
                RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: colorSecondary,
                  strokeWidth: 4.0,
                  onRefresh: () {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () {},
                    );
                  },
                  child: SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Stack(
                      fit: StackFit.loose,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 49.adaptSize),
                          width: context.width,
                          // height: context.height - 49.adaptSize - 73,
                          constraints: BoxConstraints(
                            minHeight: context.height - 49.adaptSize - 73,
                          ),
                          decoration:  BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: colorGray,
                                blurRadius: 10.0,
                              ),
                            ],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(19),
                              topRight: Radius.circular(19),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 55.h,
                              ),
                              buildBannerView(context, personalObject),
                              bodyList(context),
                              SizedBox(
                                height: 120.h,
                              ),
                            ],
                          ),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: DetailImageWidget(
                              imageUrl: personalObject.avatar ?? "",
                              shortName: personalObject.shortName ?? "",
                            )),
                      ],
                    ),
                  ),
                ),
                controller.isLoading.value ? const Loading() : const SizedBox(),
                if (PrefUtils.getExhibitorType()?.toLowerCase() == "startup")
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color:Colors.white,
                        child: buildBookSlotButton(context)),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  ///show top banner and type of media load
  buildBannerView(BuildContext context, UserAspireData personalObject) {
    return SizedBox(
      width: context.width * 0.70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextView(
              maxLines: 1,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              text: personalObject.name.toString().capitalize ?? ""),
          CompanyPositionWidget(
            company: personalObject.company ?? "",
            position: personalObject.position ?? "",
          ),
          const SizedBox(
            height: 18,
          ),
        ],
      ),
    );
  }

  ///header with gallery list view
  Widget bodyList(BuildContext context) {
    UserAspireData body = controller.investorBody.value;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (body.description != null && body.description!.isNotEmpty)
            ? aboutWidget("Bio", body.description ?? "")
            : const SizedBox(),
        const SizedBox(
          height: 0,
        ),
        if (controller.investorBody.value.linkedin != null &&
            controller.investorBody.value.linkedin!.isNotEmpty)
          buildSocialMedia(controller.investorBody.value.linkedin ?? ""),
        const SizedBox(
          height: 12,
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }

  /// build the book slot button
  Widget buildBookSlotButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      child: CustomIconButton(
        onTap: () {
          if (PrefUtils.getExhibitorType()?.toLowerCase() == "startup") {
            controller.showScheduleDialog(context);
          }
        },
        height: 50,
        width: context.width,
        decoration: BoxDecoration(
            color: colorPrimary, borderRadius: BorderRadius.circular(10)),
        child:  Center(
          child: AutoCustomTextView(
            text: "Book A Slot",
            fontSize: 18,
            maxLines: 1,
            color: white,
          ),
        ),
      ),
    );
  }

  Widget aboutWidget(String title, String description) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: CustomTextView(
          text: title,
          color: colorSecondary,
          fontWeight: FontWeight.w500,
          fontSize: 18,
          textAlign: TextAlign.start,
        ),
      ),
      subtitle: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration:  BoxDecoration(
          color: colorLightGray,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: CustomTextView(
          text: description,
          textAlign: TextAlign.start,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget buildSocialMedia(linkedInUrl) {
    return ListTile(
        contentPadding: EdgeInsets.zero,
        title:  Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CustomTextView(
            text: "Social Media",
            color: colorSecondary,
            fontWeight: FontWeight.w500,
            fontSize: 18,
            textAlign: TextAlign.start,
          ),
        ),
        subtitle: Padding(
            padding: EdgeInsets.zero,
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                height: 30,
                width: 30,
                child: InkWell(
                    onTap: () {
                      UiHelper.inAppWebView(Uri.parse(linkedInUrl));
                    },
                    child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: colorGray, width: 1)),
                        child: SvgPicture.asset(
                          UiHelper.getSocialIcon("linkedin"),
                        ))),
              ),
            )));
  }
}
