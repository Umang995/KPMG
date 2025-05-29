import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/view/eventFeed/controller/eventFeedController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';

import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../routes/my_constant.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/custom_linkfy.dart';
import '../model/commentModel.dart';
import 'feed_report_page.dart';

enum PostAction { deletePost, reportPost }

class CommentBubble extends GetView<EventFeedController> {


  final AuthenticationManager authenticationManager = Get.find();


  Comments comments;
  String feedId;
  bool isMe;
  int feedIndex;

  CommentBubble(
      {super.key,
      required this.comments,
      required this.feedId,
      required this.isMe,
      required this.feedIndex});
  @override
  Widget build(BuildContext context) {
    Widget bodyReceiver() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorLightGray,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    topLeft: Radius.circular(15)),
              ),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextView(
                              text: comments.user?.name ?? "",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: colorGray),
                          const SizedBox(
                            width: 12,
                          ),
                          buildPostAction(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    ReadMoreLinkify(
                      text: comments.content
                              ?.replaceAll("<br", "")
                              .replaceAll("/>", "") ??
                          "",
                      maxLines: 5,
                      style: TextStyle(
                          color: colorSecondary,
                          fontWeight: FontWeight.w400,
                          fontFamily: MyConstant.currentFont,
                          fontSize: 16),
                      textAlign: TextAlign.start,
                      linkStyle: const TextStyle(
                          color: Colors.blue,
                          fontFamily: MyConstant.currentFont,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
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
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                CustomTextView(
                    text: "  ${UiHelper.displayCommonDateTime(
                          date: comments.created ?? "",
                          dateFormat: "dd MMM, hh:mm aa",
                          timezone: PrefUtils.getTimezone(),
                        ) ?? ""}",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: colorDisabled),
              ],
            ),
          ],
        ),
      );
    }

    return bodyReceiver();
  }

  buildPostAction() {
    return Container(
      height: 25,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: PopupMenuButton<PostAction>(
        clipBehavior: Clip.hardEdge,
        // Callback that sets the selected popup menu item.
        onSelected: (PostAction item) async {
          if (item == PostAction.deletePost) {
            await controller.deleteCommentApi(
                requestBody: {"id": comments.id, "feed_id": feedId});
            controller.feedCmtList.remove(comments);

            if (controller.feedCmtList.isNotEmpty &&
                controller.feedDataList.isNotEmpty) {
              controller.feedDataList[feedIndex].comment?.total =
                  controller.feedCmtList.length - 1 ?? 0;
              controller.feedDataList.refresh();
            }
            controller.feedCmtList.refresh();
          } else {
            controller.selectedReportOption.value = 0;
            controller.commentResign = authenticationManager.configModel.body?.reportOptions?.eventFeed  ?? [];
            Get.to(() => FeedReportPage(
                  eventFeedId: feedId,
                  feedCommentId: comments.id ?? "",
                  isReportPost: false,
                ));
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<PostAction>>[
          if (!isMe)
            const PopupMenuItem<PostAction>(
              value: PostAction.reportPost,
              child: Text('Report'),
            ),
          if (isMe)
            const PopupMenuItem<PostAction>(
              value: PostAction.deletePost,
              child: Text('Delete'),
            ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Image.asset(ImageConstant.more_icon),
        ),
      ),
    );
  }
}
