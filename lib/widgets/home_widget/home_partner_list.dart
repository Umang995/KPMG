import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/home/controller/home_controller.dart';
import 'package:dreamcast/view/partners/controller/partnersController.dart';
import 'package:dreamcast/view/partners/view/partnersDetailPage.dart';
import 'package:dreamcast/widgets/lunchpad_menu_label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../view/partners/model/AllSponsorsPartnersListModel.dart';

class HomePartnerList extends GetView<SponsorPartnersController> {
  const HomePartnerList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<SponsorPartnersController>(
      builder: (controller) {
        return buildSponsorWidget(context, controller.homeSponsorsList ?? [],
            controller.isMoreData.value);
      },
    );
  }

  Widget buildSponsorWidget(
      BuildContext context, List<Items> items, bool isMoreData) {
    Size size = MediaQuery.of(context).size;
    return items.isNotEmpty
        ? Column(
            children: [
              const SizedBox(height: 35),
              LaunchpadMenuLabel(
                title: "partners".tr,
                trailing: isMoreData == true ? "view_all".tr : "",
                index: 2,
                trailingIcon: "",
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: 105.v, // Minimum height
                ),
                width: size.width,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length, // > 40?40:items.length,
                  itemBuilder: (context, index) {
                    var data = items[index];
                    return InkWell(
                      onTap: () async {
                        controller.userLogActivity(jsonRequest: {
                          "item_type": "sponsor",
                          "item_id": data.id,
                        });
                        Get.to(PartnerDetailPage(partner: data));
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 100.adaptSize,
                            width: 142.adaptSize,
                            padding: const EdgeInsets.only(bottom: 20, top: 5),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.rectangle,
                                border:
                                    Border.all(color: borderColor, width: 1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12))),
                            child: Center(
                                child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: data.avatar ?? "",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.contain),
                                  ),
                                ),
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  ImageConstant.imagePlaceholder,
                                  color: colorLightGray,
                                ),
                              ) /*Image.network(data?.logo ?? "")*/,
                            )),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 20.v,
                            right: 20.v,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12))),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  data.label ?? "",
                                  style: TextStyle(
                                      color: Theme.of(context).highlightColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          )
                        ],
                        // data?.category ?? ""
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 10.v);
                  },
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}
