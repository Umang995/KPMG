import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:dreamcast/view/eventFeed/controller/eventFeedController.dart';
import 'package:dreamcast/view/eventFeed/model/feedLikeModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/customImageWidget.dart';
import '../../../widgets/textview/customTextView.dart';
import '../../../widgets/loading.dart';
import '../../dashboard/showLoadingPage.dart';

class FeedLikeListPage extends GetView<EventFeedController> {
  FeedLikeListPage({Key? key}) : super(key: key);
  static const routeName = "/FeedLikeListPage";
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  var allLikeList = <Emoticons>[].obs;
  var tabIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    final tabBarTheme = Theme.of(context).tabBarTheme;
    return Scaffold(
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
        title: ToolbarTitle(title: "people_who_reached".tr),
      ),
      body: DefaultTabController(
          length: 6,
          child: Scaffold(
            backgroundColor: white,
            resizeToAvoidBottomInset: true,
            appBar: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                tabAlignment: TabAlignment.start,
                labelStyle: tabBarTheme.labelStyle?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: colorPrimary,
                ),
                unselectedLabelStyle:
                tabBarTheme.unselectedLabelStyle?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: colorGray,
                ),
                isScrollable: true,
                onTap: (index) {
                  tabIndex(index);
                },
                tabs: [
                  Tab(
                    height: 52,
                    child: Obx(() => Row(
                          children: [
                            CustomTextView(
                                text: "All ",
                                color: tabIndex.value == 0
                                    ? colorPrimary
                                    : colorGray,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                            CustomTextView(
                                text: "(${allLikeList.length.toString()})",
                                color: tabIndex.value == 0
                                    ? colorPrimary
                                    : colorGray,
                                fontWeight: FontWeight.w500,
                                fontSize: 18)
                          ],
                        )),
                  ),
                  Tab(
                    height: 52,
                    child: buildTab(controller.feedLikeBody.value.like?.count,
                        ImageConstant.thumbs_up, 1),
                  ),
                  Tab(
                    height: 52,
                    child: buildTab(controller.feedLikeBody.value.love?.count,
                        ImageConstant.heart_icon, 2),
                  ),
                  Tab(
                    height: 52,
                    child: buildTab(controller.feedLikeBody.value.care?.count,
                        ImageConstant.emoji_like_2, 3),
                  ),
                  Tab(
                    height: 52,
                    child: buildTab(controller.feedLikeBody.value.haha?.count,
                        ImageConstant.emoji_like_1, 4),
                  ),
                  Tab(
                    height: 52,
                    child: buildTab(controller.feedLikeBody.value.wow?.count,
                        ImageConstant.emoji_like_3, 5),
                  ),
                ]),
            body: TabBarView(
              children: [
                buildMessageViewAll(),
                buildMessageView(
                    controller.feedLikeBody.value.like?.emoticons ?? []),
                buildMessageView(
                    controller.feedLikeBody.value.love?.emoticons ?? []),
                buildMessageView(
                    controller.feedLikeBody.value.care?.emoticons ?? []),
                buildMessageView(
                    controller.feedLikeBody.value.haha?.emoticons ?? []),
                buildMessageView(
                    controller.feedLikeBody.value.wow?.emoticons ?? []),
              ],
            ),
          )),
    );
  }

  buildTab(int? title, icons, int index) {
    return Row(children: [
      Image.asset(icons, height: 30),
      CustomTextView(
        text: title != null && title > 0 ? title.toString() : "0",
        fontWeight: FontWeight.w500,
        color: tabIndex.value == index ? colorPrimary : colorGray,
      )
    ]);
  }

  buildMessageView(List<Emoticons> likeList) {
    return likeList.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: ListView.separated(
              itemCount: likeList.length,
              itemBuilder: (BuildContext context, int index) {
                Emoticons comments = likeList[index];
                return childWidget(comments, context);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  color: borderColor,
                  height: 24,
                );
              },
            ),
          )
        : _progressEmptyWidget(likeList);
  }

  buildMessageViewAll() {
    allLikeList.clear();
    allLikeList.addAll(controller.feedLikeBody.value.like?.emoticons ?? []);
    allLikeList.addAll(controller.feedLikeBody.value.love?.emoticons ?? []);
    allLikeList.addAll(controller.feedLikeBody.value.haha?.emoticons ?? []);
    allLikeList.addAll(controller.feedLikeBody.value.care?.emoticons ?? []);
    allLikeList.addAll(controller.feedLikeBody.value.wow?.emoticons ?? []);
    //allLikeList.addAll(controller.feedLikeBody.value.sad?.emoticons ?? []);
    //allLikeList.addAll(controller.feedLikeBody.value.angry?.emoticons ?? []);
    return allLikeList.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: ListView.separated(
              itemCount: allLikeList.length,
              itemBuilder: (BuildContext context, int index) {
                var comments = allLikeList[index];
                return childWidget(comments, context);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 24,
                  color: borderColor,
                );
              },
            ),
          )
        : _progressEmptyWidget(allLikeList);
  }

  childWidget(Emoticons comments, BuildContext context) {

    return Container(
      width: context.width,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.transparent,
                  width: double.maxFinite,
                  margin: EdgeInsets.only(right: 2.v),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      circularImage(
                          shortName: comments.user?.shortName ?? "",
                          url: comments.user?.avatar ?? "",
                          likeType: comments.type ?? ""),
                      SizedBox(width: 18.v),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextView(
                                text: comments.user?.name?.toString().trim() ??
                                    "",
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.start,
                                // color: colorPrimaryDark,
                              ),
                              SizedBox(height: 4.v),
                              comments.user?.position?.isNotEmpty ?? false
                                  ? CustomTextView(
                                      text: comments.user?.position ?? "",
                                      fontSize: 14,
                                      maxLines: 1,
                                      color: colorGray,
                                      fontWeight: FontWeight.normal,
                                      textAlign: TextAlign.start,
                                    )
                                  : const SizedBox(),
                              comments.user?.company?.isNotEmpty ?? false
                                  ? CustomTextView(
                                      text: comments.user?.company ?? "",
                                      fontSize: 14,
                                      maxLines: 1,
                                      color: colorGray,
                                      fontWeight: FontWeight.w600,
                                      textAlign: TextAlign.start,
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 20.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressEmptyWidget(List<Emoticons> likeList) {
    return Center(
      child: controller.isFirstLoadRunning.value
          ? const Loading()
          : likeList.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  Widget circularImage({url, shortName, required String likeType}) {
    return SizedBox(
      height: 70.adaptSize,
      width: 70.adaptSize,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(6),
            child: CachedNetworkImage(
              imageUrl: url,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  border: Border.all(color: colorLightGray, width: 1),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: imageProvider, fit: BoxFit.contain),
                ),
              ),
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Container(
                decoration: BoxDecoration(
                  border: Border.all(color: colorSecondary, width: 1),
                  shape: BoxShape.circle,
                  color: colorSecondary,
                ),
                child: Center(
                    child: CustomTextView(
                  text: shortName,
                  fontSize: 18,
                  color: white,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w600,
                )),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: buildMyLikeWidget(likeType),
          )
        ],
      ),
    );
  }

  Widget buildMyLikeWidget(String reactions) {
    final Map<bool, String> reactionPaths = {
      reactions == "like": ImageConstant.thumbs_up,
      reactions == "love": ImageConstant.heart_icon,
      reactions == "care": ImageConstant.emoji_like_2,
      reactions == "haha": ImageConstant.emoji_like_1,
      reactions == "wow": ImageConstant.emoji_like_3,
    };
    // Find the first matching reaction path or provide a default empty path
    String path = reactionPaths.entries
        .firstWhere(
          (entry) => entry.key,
          orElse: () => MapEntry(false, ImageConstant.thumbs_up),
        )
        .value;

    return Image.asset(
      path,
      height: 24,
      width: 24,
    );
  }
}
