import 'package:dreamcast/core/extension/content_extension.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'customImageWidget.dart';
import 'textview/customTextView.dart';

class InvestorListBody extends StatelessWidget {
  dynamic representatives;
  InvestorListBody({Key? key, required this.representatives}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CustomImageWidget(
                          imageUrl: representatives.avatar ?? "",
                          shortName: representatives.shortName ?? ""),
                      SizedBox(width: 20.h),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextView(
                                text: representatives.name ?? "",
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.start,
                                color: colorSecondary,
                              ),
                              SizedBox(height: 6.v),
                              representatives.position.toString().isEmpty
                                  ? const SizedBox()
                                  : CustomTextView(
                                text: representatives.position ?? "",
                                fontSize: 14,
                                maxLines: 1,
                                color: colorGray,
                                fontWeight: FontWeight.normal,
                                textAlign: TextAlign.start,
                              ),
                              representatives.company.toString().isEmpty
                                  ? const SizedBox()
                                  : CustomTextView(
                                text: "${representatives.company ?? ""}",
                                fontSize: 14,
                                maxLines: 1,
                                color: colorGray,
                                fontWeight: FontWeight.normal,
                                textAlign: TextAlign.start,
                              ),
                              // SizedBox(height: 10.v),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 20.h),
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
          // SizedBox(width: 12.h),
        ],
      ),
    );
  }
}

/*
class InvestorListBody extends StatelessWidget {
  dynamic representatives;
  InvestorListBody({Key? key, required this.representatives}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: menuBorderColor, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                circularImage(
                    url: representatives.avatar ?? "Hello",
                    shortName: representatives.shortName ?? "",
                    size: 75.0),
                const SizedBox(
                  height: 5,
                ),
                CustomTextView(
                  text: representatives.name ?? "Name of user",
                  fontSize: 16,
                  color: colorPrimary,
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomTextView(
                  text:
                      "${representatives.position ?? "Position"} ${representatives.company ?? "Company"}",
                  fontSize: 15,
                  maxLines: 2,
                  color: textGrayColor,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget circularImage({url, shortName, size}) {
    return url != null && url.isNotEmpty
        ? Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: white,
                border: Border.all(color: colorPrimary, width: 1),
                image: DecorationImage(image: NetworkImage(url))),
          )
        : Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorAccent,
                border: Border.all(color: colorPrimary, width: 1)),
            child: Center(
                child: CustomTextView(
              text: shortName,
              textAlign: TextAlign.center,
            )),
          );
  }
}
*/
