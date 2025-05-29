import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../widgets/custom_linkfy.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.text,
    required this.userName,
    required this.avtar,
    required this.shortName,
    required this.date,
    required this.isSender,
  }) : super(key: key);
  final String text;
  final String userName;
  final String avtar;
  final String shortName;
  final String date;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    Widget circularImage({url, shortName}) {
      return url.isNotEmpty
          ? CircleAvatar(backgroundImage: NetworkImage(url))
          : Container(
              height: 45,
              width: 45,
              decoration:  BoxDecoration(
                shape: BoxShape.circle,
                color: colorSecondary,
              ),
              child: Center(
                  child: CustomTextView(
                text: shortName,
                textAlign: TextAlign.center,
              )),
            );
    }

    Widget bodySender() {
      return Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration:  BoxDecoration(
                      color: colorSecondary,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        /* Text(
                          userName.capitalizeFirst!,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: isSender ? white : kSubTitleColor,
                              fontFamily: 'SourceSansPro',
                              fontSize: 12),
                        ),
                        const SizedBox(
                          height: 6,
                        ),*/
                        ReadMoreLinkify(
                          text: text
                                  .toString()
                                  /*.replaceAll("<br", "")
                                  .replaceAll("/>", "") ??
                              ""*/,
                          maxLines: 10,
                          style: TextStyle(
                              color: isSender ? white : colorSecondary,
                              fontWeight: FontWeight.normal,
                              fontSize: 16.adaptSize),
                          textAlign: TextAlign.start,
                          linkStyle: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.normal,
                              fontSize: 16.adaptSize),
                          onOpen: (link) async {
                            final Uri url = Uri.parse(link.url);
                            if (await canLaunchUrlString(link.url)) {
                              await launchUrlString(link.url,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
                /*const SizedBox(width: 12,),
                Flexible(
                  child: circularImage(shortName: shortName, url: avtar),
                )*/
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: CustomTextView(
                text: date,
                color: colorGray,
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    Widget bodyReceiver() {
      return Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                /*Flexible(
                    child: circularImage(shortName: shortName, url: avtar)),
                const SizedBox(
                  width: 12,
                ),*/
                Flexible(
                    child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration:  BoxDecoration(
                    color: colorLightGray,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ReadMoreLinkify(
                        text: text.toString(),
                        maxLines: 10,
                        style: TextStyle(
                            color: colorSecondary,
                            fontWeight: FontWeight.normal,
                            fontSize: 16.adaptSize),
                        textAlign: TextAlign.start,
                        linkStyle: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.normal,
                            fontSize: 16.adaptSize),
                        onOpen: (link) async {
                          final Uri url = Uri.parse(link.url);
                          if (await canLaunchUrlString(link.url)) {
                            await launchUrlString(link.url,
                                mode: LaunchMode.externalApplication);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      )
                    ],
                  ),
                )),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 12),
              child: CustomTextView(
                text: date,
                color: colorGray,
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return isSender ? bodySender() : bodyReceiver();
  }
}
