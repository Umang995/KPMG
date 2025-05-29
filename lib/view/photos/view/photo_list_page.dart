import 'package:dreamcast/myDownloadFile.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';
import '../../../theme/ui_helper.dart';
import '../../../widgets/fullscreen_image.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/showLoadingPage.dart';
import '../controller/photoController.dart';

class PhotoListPage extends GetView<PhotoController> {
  PhotoListPage({Key? key}) : super(key: key);

  static const routeName = "/PhotoListPage";

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  final guideController = Get.put(PhotoController());
  final MyDownloadFile downloadFile = MyDownloadFile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          title:  ToolbarTitle(
            title: "photo_booth".tr,
            color: Colors.black,
          ),
          backgroundColor: white,
          shape: const Border(
              bottom: BorderSide(color: borderColor, width: 1)),
          iconTheme:  IconThemeData(color: colorSecondary),
        ),
        body: GetX<PhotoController>(builder: (controller) {
          return Container(
              height: context.height,
              padding: const EdgeInsets.all(12),
              child: Stack(
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
                                  controller.getPhotoList(
                                      requestBody: {"page": "1"});
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
              ));
        }));
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isFirstLoadRunning.value
          ? const Loading()
          : controller.guideList.isEmpty
          ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
          : const SizedBox(),
    );
  }

  buildListView(BuildContext context) {
    return GetX<PhotoController>(builder: (controller) {
      return GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: controller.scrollController,
        itemCount: controller.guideList.length,
        itemBuilder: (context, index) => buildPhotoWidget(index, context),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1 / 1,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12),
      );
    });
  }

  buildPhotoWidget(int index, BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 156,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: UiHelper.getPhotoBoothImage(
              imageUrl: controller.guideList[index].media ?? ""),
        ),
        GestureDetector(
          onTap: () {
            Get.to(FullImageView(
              showDownload: true,showNotification: true,
              imgUrl: controller.guideList[index].media ?? "",));
          },
          child: Container(
            height: 156,
            decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
            child: Obx(() =>
                InkWell(
                    onTap: () {
                      controller.downloadPosition(index);
                      controller.saveNetworkImage(controller.guideList[index].media ?? "");
                    },
                    child: (controller.progressLoading.value &&
                        controller.downloadPosition == index) ?  SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(
                          color: colorSecondary,
                          strokeWidth: 2,
                          backgroundColor: Colors.white,
                        )) : const Icon(
                      Icons.download_for_offline_rounded, color: Colors.white,
                      size: 30,)))),
      ],
    );
  }
}


