import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/loadMoreItem.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/view/eventFeed/controller/eventFeedController.dart';
import 'package:dreamcast/view/eventFeed/view/upload_post_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/image_constant.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/event_feed_widget.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../../widgets/textview/customTextView.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/showLoadingPage.dart';

class SocialFeedListPage extends GetView<EventFeedController> {
  static const routeName = "/SocialFeedListPage";

  SocialFeedListPage({Key? key, required this.isFromLaunchpad})
      : super(key: key);
  final AuthenticationManager authenticationManager = Get.find();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  int currentSec = 5;
  var isFromLaunchpad = false;

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
            title: Get.arguments?[MyConstant.titleKey] ?? "event_feed".tr),
        backgroundColor: white,
        // dividerHeight: 0,
      ),
      body: SizedBox(
        height: context.height,
        width: context.width,
        child: GetX<EventFeedController>(
          builder: (controller) {
            return Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    buildHeader(),
                    Expanded(
                      child: RefreshIndicator(
                        triggerMode: RefreshIndicatorTriggerMode.anywhere,
                        backgroundColor: colorSecondary,
                        key: _refreshIndicatorKey,
                        onRefresh: () {
                          return Future.delayed(
                            const Duration(seconds: 1),
                            () async {
                              controller.getEventFeed(isLimited: false);
                            },
                          );
                        },
                        child: EventFeedWidgetDynamic(
                          isFromLaunchpad: isFromLaunchpad,
                        ),
                      ),
                    ),
                    // when the _loadMore function is running
                    controller.isLoadMoreRunning.value
                        ? const LoadMoreLoading()
                        : const SizedBox()
                  ],
                ),
                _progressEmptyWidget()
              ],
            );
          },
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.loading.value
          ? const Loading()
          : !controller.isFirstLoadRunning.value &&
                  controller.feedDataList.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrefUtils.getUserId() !=
              PrefUtils.getFeedEmail()
              ? InkWell(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 38,
                        child: circularImage(
                            shortName: PrefUtils.getUsername(),
                            url: PrefUtils.getImage()),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                          width: 1, height: 30, color: const Color(0xffDCDCDD)),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                          child: CustomTextView(
                        text: "want_to_talk_about".tr,
                        fontSize: 16,
                        maxLines: 2,
                        fontWeight: FontWeight.normal,
                        color: colorGray,
                        textAlign: TextAlign.start,
                      ))
                    ],
                  ),
                  onTap: () async {
                    controller.isFilePicked(false);
                    controller.mediaPath("");
                    controller.mediaType("");
                    controller.recordAudio(false);

                    if (controller.feedDataList.isNotEmpty) {
                      controller.feedDataList[controller.lastIndexPlay]
                          .isPlayVideo = false;
                      controller.feedDataList.refresh();
                    }
                    var result = await Get.bottomSheet(
                      UploadPostPage(),
                      enableDrag: true,
                      barrierColor: Colors.black.withOpacity(0.80),
                      isDismissible: false,
                      isScrollControlled: true,
                    );
                    if (result == true) {
                      controller.getEventFeed(isLimited: false);
                    }
                  },
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  circularImage({url, shortName, color}) {
    return url.toString().isNotEmpty && url != null
        ? SizedBox(
            height: 45,
            width: 45,
            child: CircleAvatar(backgroundImage: NetworkImage(url)))
        : Container(
            height: 45,
            width: 45,
            decoration:  BoxDecoration(
              shape: BoxShape.circle,
              color: colorSecondary,
            ),
            child: Center(
                child: CustomTextView(
              text: shortName ?? "",
              color: Colors.white,
              textAlign: TextAlign.center,
            )),
          );
  }
}
