import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/partners/view/partnersListSkeleton.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/view/partners/controller/partnersController.dart';
import 'package:dreamcast/view/partners/view/partnersDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_decoration.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_search_view.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/showLoadingPage.dart';
import 'package:dreamcast/view/partners/model/AllSponsorsPartnersListModel.dart';

class SponsorsList extends GetView<SponsorPartnersController> {
  SponsorsList({Key? key}) : super(key: key);
  static const routeName = "/SponsorsList";
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final textController = TextEditingController().obs;

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
            title: Get.arguments?[MyConstant.titleKey] ?? "partners".tr),
      ),
      body: GetX<SponsorPartnersController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              children: [
                CustomSearchView(
                  isShowFilter: false,
                  hintText: "search_here".tr,
                  controller: textController.value,
                  press: () async {},
                  onSubmit: (result) async {
                    if (result.isNotEmpty) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      controller.allSponsorsPartnersListApi(requestBody: {
                        "limited_mode": false,
                        "text": textController.value.text
                      }, isRefresh: true);
                    }
                  },
                  onClear: (data) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    _refreshIndicatorKey.currentState?.show();
                  },
                ),
                Expanded(
                  child: buildParentList(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  buildParentList(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: colorSecondary,
      key: _refreshIndicatorKey,
      onRefresh: () {
        return Future.delayed(
          const Duration(seconds: 1),
          () async {
            FocusManager.instance.primaryFocus?.unfocus();
            controller.allSponsorsPartnersListApi(
                requestBody: {"limited_mode": false}, isRefresh: true);
          },
        );
      },
      child: controller.sponsorsLoader.value
          ? const Skeletonizer(child: Partnerslistskeleton())
          : controller.allSponsorsList.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: controller.allSponsorsList.length,
                  itemBuilder: (context, index) {
                    PartnerData partnerBody = controller.allSponsorsList[index];
                    return partnerBody.items != null &&
                            partnerBody.items!.isNotEmpty
                        ? ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 10.0, top: 15),
                              child: CustomTextView(
                                text: partnerBody.label ?? "",
                                color: colorGray,
                                fontSize: 22,
                                maxLines: 3,
                                textAlign: TextAlign.start,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: buildChidList(context, partnerBody.items),
                          )
                        : const SizedBox();
                  },
                ),
    );
  }

  buildChidList(BuildContext context, List<Items>? items) {
    return items!.isNotEmpty
        ? GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) => buildCardWidget(items[index]),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1 / 1,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16),
          )
        : const SizedBox();
  }

  buildCardWidget(Items data) {
    return GestureDetector(
      onTap: () {
        controller.userLogActivity(jsonRequest: {
          "item_type": "sponsor",
          "item_id": data.id,
        });
        Get.to(PartnerDetailPage(partner: data));
      },
      child: Card(
          elevation: 1,
          color: white,
          shape: RoundedRectangleBorder(
            side:  BorderSide(color: colorLightGray, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CachedNetworkImage(
                  imageUrl: data.avatar ?? "",
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.contain),
                    ),
                  ),
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    fit: BoxFit.contain,
                    height: 55.adaptSize,
                    ImageConstant.imagePlaceholder,
                    color: colorLightGray,
                  ),
                )),
          )),
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.sponsorsLoader.value
          ? const Loading()
          : controller.allSponsorsList.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }
}
