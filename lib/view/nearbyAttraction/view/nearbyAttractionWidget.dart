import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/core/extension/content_extension.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/view/nearbyAttraction/model/near_by_attrection_model.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../theme/ui_helper.dart';

class NearbyAttractionWidget extends StatelessWidget {
  NearByData itemList;
  NearbyAttractionWidget({super.key, required this.itemList});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorLightGray,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              height: context.width * 9 / 16, // 16:9 aspect ratio,
              maxHeightDiskCache: 500,
              fit: BoxFit.contain,
              imageUrl: itemList.media ?? "",
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  image: DecorationImage(
                      image: imageProvider, fit: BoxFit.contain),
                ),
              ),
              placeholder: (context, url) => Center(
                child: Image.asset(
                  ImageConstant.imagePlaceholder,
                ),
              ),
              errorWidget: (context, url, error) => Image.asset(
                ImageConstant.imagePlaceholder,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomTextView(
                  text: itemList.title ?? "",
                  fontSize: 18,
                  maxLines: 10,
                  color: colorSecondary,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w500,
                ),
              ),
              InkWell(
                onTap: () {
                  UiHelper.inAppBrowserView(
                      Uri.parse(itemList.locationUrl ?? ""));
                },
                child: SvgPicture.asset(ImageConstant.ic_location_pointer),
              ),
            ],
          ),
          if (itemList.description?.isNotEmpty ?? false)
            const SizedBox(height: 10),
          if (itemList.description?.isNotEmpty ?? false)
            CustomReadMoreText(
              maxLines: 5,
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: colorSecondary,
              text: itemList.description ?? "",
              textAlign: TextAlign.start,
            )
        ],
      ),
    );
  }
}
