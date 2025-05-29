import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/animatedBookmark/AnimatedBookmarkWidget.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/fullscreen_image.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../home/screen/inAppWebview.dart';
import '../../home/screen/pdfViewer.dart';
import '../controller/exhibitorsController.dart';

class VideoListPage extends GetView<BoothController> {
  bool showAppbar = false;
  VideoListPage({Key? key, required this.showAppbar}) : super(key: key);
  static const routeName = "/VideoListPage";

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

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
        title: ToolbarTitle(title: "video".tr),
      ),
      body: Container(
          padding: const EdgeInsets.all(14),
          margin: EdgeInsets.zero,
          child: GetX<BoothController>(builder: (controller) {
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                        child: RefreshIndicator(
                      key: _refreshIndicatorKey,
                      color: colorLightGray,
                      backgroundColor: colorPrimary,
                      strokeWidth: 1.0,
                      triggerMode: RefreshIndicatorTriggerMode.anywhere,
                      onRefresh: () async {
                        return Future.delayed(
                          const Duration(seconds: 1),
                          () {
                            controller.getExhibitorsDocument(
                                type: "videos",
                                isRefresh: true,
                                context: context);
                          },
                        );
                      },
                      child: buildListView(context),
                    )),
                    controller.isLoadMoreRunning.value
                        ? const Loading()
                        : const SizedBox()
                  ],
                ),
                // when the first load function is running
                _progressEmptyWidget()
              ],
            );
          })),
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isLoading.value
          ? const Loading()
          : controller.documentList.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  Widget buildListView(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 15,
        );
      },
      itemCount: controller.documentList.length,
      itemBuilder: (context, index) {
        var data = controller.documentList[index];
        return Card(
          color: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Colors.transparent,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9, // This sets the aspect ratio to 16:9
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(data.media?.thumbnail ?? ""),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        final media = data.media;
                        if (media == null) return;

                        final type = media.type;
                        final url = media.url ?? "";
                        final name = data.name ?? "";

                        switch (type) {
                          case "pdf":
                            Get.to(PdfViewPage(htmlPath: url, title: name));
                            break;
                          case "in_app_link":
                            Get.toNamed(CustomWebViewPage.routeName,
                                arguments: {
                                  "page_url": url,
                                  "title": name,
                                });
                            break;
                          default:
                            if (type?.contains("image") == true) {
                              Get.to(FullImageView(imgUrl: url));
                            } else if (type?.contains("youtube") == true ||
                                type?.contains("vimeo") == true ||
                                type?.contains("html5") == true) {
                              UiHelper.inAppWebView(Uri.parse(url));
                            } else {
                              UiHelper.inAppBrowserView(Uri.parse(url));
                            }
                        }
                      },
                      child: SvgPicture.asset(ImageConstant.video_play),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 8, top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomTextView(
                          text: data.name ?? "",
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          maxLines: 2,
                        ),
                      ),
                      AnimatedBookmarkWidget(
                          isDocumentBookmark: true,
                          bookMarkIdsList: controller.bookmarkDocumentIdsList,
                          onTap: () async {
                            await controller.bookmarkToExhibitorItem(
                                id: data.id, itemType: "document");
                          },
                          padding: const EdgeInsets.all(0),
                          id: data.id.toString(),
                          height: 18.h),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 8,
                  ),
                  child: CustomTextView(
                    text: data.description ?? "",
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
