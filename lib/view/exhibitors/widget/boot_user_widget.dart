import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../theme/app_colors.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/customImageWidget.dart';
import '../../../widgets/textview/customTextView.dart';

class BootUserWidget extends StatelessWidget {
  var representativesParam;
  BootUserWidget({super.key, required this.representativesParam});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: colorLightGray, borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.only(right: 10,left: 8),
        leading: CustomImageWidget(
          imageUrl: representativesParam.avatar ?? "",
          shortName: representativesParam.shortName ?? "",
          size: 70.adaptSize,
          color: Theme.of(context).scaffoldBackgroundColor,
          borderWidth: 1,
        ),
        title: CustomTextView(
          text: representativesParam.name ?? "",
          textAlign: TextAlign.start,
          fontSize: 16, fontWeight: FontWeight.w500,
          // color: black,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            representativesParam.position == null ||
                    representativesParam.position!.isEmpty
                ? const SizedBox()
                : CustomTextView(
                    text: representativesParam.position.toString(),
                    textAlign: TextAlign.start,
                    fontSize: 14,
                    color: colorGray,
                    fontWeight: FontWeight.normal,
                    maxLines: 2,
                  ),
            representativesParam.company == null ||
                    representativesParam.company!.isEmpty
                ? const SizedBox()
                : CustomTextView(
                    text: representativesParam.company.toString(),
                    textAlign: TextAlign.start,
                    fontSize: 14,
                    color: colorGray,
                    fontWeight: FontWeight.normal,
                    maxLines: 2,
                  ),
          ],
        ),
        trailing: SizedBox(
          width: 95,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      shape: BoxShape.rectangle,
                      borderRadius: const BorderRadius.all(Radius.circular(6))),
                  child: SvgPicture.asset(
                    ImageConstant.ic_one_to_one,
                    color: colorSecondary,
                  )),
              Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(left: 6),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(6))),
                child: Image.asset(
                  ImageConstant.chat_header,
                  color: colorSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget circularImage({url, shortName}) {
    return url.toString().isNotEmpty
        ? SizedBox(
            height: 80,
            width: 80,
            child: CircleAvatar(backgroundImage: NetworkImage(url)))
        : Container(
            height: 80,
            width: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
                child: CustomTextView(
              text: shortName ?? "",
              fontSize: 20.adaptSize,
              color: colorSecondary,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            )),
          );
  }
}
