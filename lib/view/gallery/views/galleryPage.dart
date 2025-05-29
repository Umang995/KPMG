import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/app_bar/appbar_leading_image.dart';
import 'package:dreamcast/widgets/app_bar/custom_app_bar.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../widgets/loadMoreItem.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../skeletonView/photobooth_list_skeleton.dart';
import '../controller/galleryController.dart';

class GalleryPage extends StatelessWidget {
  static const routeName = "/GalleryPage";
  final GalleryController controller = Get.put(GalleryController());
  final GlobalKey<RefreshIndicatorState> _refreshTab1Key =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Obx(() {
          return controller.isLoading.value
              ? const Center(child: Padding(
                padding: EdgeInsets.all(14.0),
                child: PhotoListSkeleton(),
              ))
              : controller.videoList.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.all(14.adaptSize),
                      child: buildPhotoVideoGalleryList(),
                    )
                  : ShowLoadingPage(
                      refreshIndicatorKey: _refreshTab1Key,
                    );
        }),
      ),
    );
  }

  Widget buildPhotoVideoGalleryList() {
    return GetX<GalleryController>(builder: (controller) {
      return Stack(
        children: [
          RefreshIndicator(
              key: _refreshTab1Key,
              onRefresh: () async {
                // Call the method to refresh the image list
                await controller.getGalleryList();
              },
              child: Column(
                children: [
                  Expanded(
                      child: GridView.builder(
                    controller: controller.videoScrollController,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: controller.videoList.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    // Enable bouncing
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 17.h,
                      mainAxisSpacing: 17.v,
                    ),
                    itemBuilder: (context, index) {
                      var data = controller.videoList[index];
                      return GestureDetector(
                        onTap: () {
                          UiHelper.inAppBrowserView(
                              Uri.parse(data.mediaFile?.url ?? ""));
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(
                                      controller.selectedTabIndex.value == 0
                                          ? 0.0
                                          : 0.3),
                                  BlendMode.darken,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      controller.selectedTabIndex.value == 0
                                          ? data.mediaFile?.url ?? ""
                                          : data.mediaFile?.thumbnail ?? "",
                                  height: context.height,
                                  width: context.width,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[300],
                                    height: context.height,
                                    width: context.width,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: Colors.grey[300],
                                    height: context.height,
                                    width: context.width,
                                  ),
                                ),
                              ),
                            ),
                            controller.selectedTabIndex.value == 1
                                ? SvgPicture.asset(
                                    ImageConstant.play,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      );
                    },
                  )),
                  // when the _loadMore function is running
                  controller.isLoadMoreRunning.value
                      ? const LoadMoreLoading()
                      : const SizedBox(),
                ],
              )),
          _progressEmptyVideoWidget()
        ],
      );
    });
  }

  Widget _progressEmptyVideoWidget() {
    return Center(
      child: controller.isLoading.value
          ? const Loading()
          : !controller.isLoading.value && controller.videoList.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshTab1Key)
              : const SizedBox(),
    );
  }
}
