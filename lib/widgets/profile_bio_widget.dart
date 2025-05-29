import 'package:dreamcast/core/extension/content_extension.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../routes/my_constant.dart';
import 'custom_linkfy.dart';

class ProfileBioWidget extends StatelessWidget {
  String title;
  String content;
  ProfileBioWidget({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return content.trim().isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 12.v,
              ),
              CustomTextView(
                text: title,
                maxLines: 50,
                fontSize: 19,
                fontWeight: FontWeight.w500,
                color: colorSecondary,
              ),
              SizedBox(
                height: 10.v,
              ),
              Container(
                width: context.width,
                padding: EdgeInsets.all(20.h),
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: ReadMoreLinkify(
                  text:
                      content.replaceAll("<br", "").replaceAll("/>", "") ?? "",
                  maxLines:
                      5, // Set the maximum number of lines before truncation
                  style: TextStyle(
                      fontSize: 16.fSize,
                      color: colorSecondary,
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.start,
                  linkStyle: TextStyle(
                      fontSize: 15.fSize,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500),
                  onOpen: (link) async {
                    final Uri url = Uri.parse(link.url);
                    if (await canLaunchUrlString(link.url)) {
                      await launchUrlString(link.url,
                          mode: LaunchMode.externalApplication);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              )
            ],
          )
        : const SizedBox();
  }
}
