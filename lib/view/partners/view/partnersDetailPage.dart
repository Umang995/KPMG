import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/partners/model/AllSponsorsPartnersListModel.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/toolbarTitle.dart';
import '../controller/partnersController.dart';

class PartnerDetailPage extends GetView<SponsorPartnersController> {
  final partnerController = Get.put(SponsorPartnersController());
  Items partner;
  PartnerDetailPage({Key? key, required this.partner}) : super(key: key);
  static const routeName = "/partnerDetail";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Theme.of(context).scaffoldBackgroundColor,
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
          title: ToolbarTitle(title: "partner_details".tr),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.topCenter,
                        child: buildCardWidget(partner)),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomTextView(
                      text: partner.name ?? "",
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 3),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: colorSecondary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12))),
                      child: CustomTextView(
                        text: partner.label ?? "",
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: white,
                      ),
                    ),

                    ///*********** Social Media ***********///
                    partner.socialMedia?.params != null &&
                            partner.socialMedia!.params!.isNotEmpty
                        ? buildSocialWidget(context)
                        : const SizedBox(),

                    ///*********** Description ***********///
                    partner.description != null &&
                            partner.description!.isNotEmpty
                        ? buildDescription(context, "description".tr,
                            partner.description ?? "", true)
                        : const SizedBox(),
                    /*buildDescription(
                        context, "Website", partner.website ?? "", false),*/
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  buildCardWidget(dynamic data) {
    return SizedBox(
      height: 116.adaptSize,
      width: 122.adaptSize,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: borderColor, width: 1),
            color: white),
        child: CachedNetworkImage(
          imageUrl: data.avatar ?? "",
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
            ),
          ),
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Image.asset(
            ImageConstant.imagePlaceholder,
            color: colorLightGray,
          ),
        ),
      ),
    );
  }

  buildDescription(BuildContext context, title, subtitle, isDesc) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 13, top: 12),
        child: CustomTextView(
          text: title,
          fontSize: 19,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.start,
          color: colorSecondary,
        ),
      ),
      subtitle: Container(
        width: context.width,
        padding: isDesc
            ? const EdgeInsets.all(14)
            : EdgeInsets.symmetric(vertical: 0, horizontal: isDesc ? 0 : 0),
        decoration: BoxDecoration(
            color: isDesc ? colorLightGray : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(6))),
        child: subtitle.toString().contains("http")
            ? buildLink(link: subtitle)
            : CustomReadMoreText(
                text: subtitle,
                maxLines: 1000,
                textAlign: TextAlign.start,
                color: colorSecondary,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
      ),
    );
  }

  buildLink({required link}) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(link)),
      child: Text(
        link,
        style: TextStyle(
            decoration: TextDecoration.underline, color: colorSecondary),
      ),
    );
  }

  buildSocialWidget(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 13, top: 12),
        child: CustomTextView(
          text: partner.socialMedia?.text?.capitalize ?? "",
          color: colorSecondary,
          fontSize: 19,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.start,
        ),
      ),
      subtitle: Wrap(
        spacing: 0,
        children: <Widget>[
          for (var item in partner.socialMedia?.params ?? [])
            item.value != null && item.value.toString().isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: SizedBox(
                      height: 32,
                      width: 32,
                      child: InkWell(
                          onTap: () {
                            UiHelper.inAppBrowserView(
                                Uri.parse(item.value.toString()));
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: colorGray, width: 0.5)),
                              padding: const EdgeInsets.all(1),
                              child: SvgPicture.asset(
                                UiHelper.getSocialIcon(
                                    item.text.toString().toLowerCase()),
                              ))),
                    ))
                : const SizedBox(),
        ],
      ),
    );
  }
}
