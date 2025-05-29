import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../theme/ui_helper.dart';
import '../model/videoModel.dart';

class PhotoController extends GetxController {
  var loading = false.obs;
  var guideList = <Guides>[].obs;
  late bool hasNextPage;
  late int _pageNumber;
  var isFirstLoadRunning = false.obs;
  var isLoadMoreRunning = false.obs;
  var downloadPosition = 0.obs;
  var progressLoading = false.obs;


  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getPhotoList(requestBody: {"page":"1"});
  }

  void saveNetworkImage(String url) async {
    progressLoading(true);
    //await GallerySaver.saveImage(url, albumName: "EXL-2024");
    progressLoading(false);
    UiHelper.showSuccessMsg(null, 'file_uploaded_success'.tr);
  }

  Future<void> getPhotoList({required Map requestBody}) async {
    _pageNumber=1;
    isFirstLoadRunning(true);
    final model = VideoModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: requestBody,
        url: AppUrl.eventVideoList,
      ),
    ));
    if (model.head!.status! && model.head!.code == 200) {
      guideList.clear();
      guideList.addAll(model.body?.guides??[]);
       hasNextPage = model.body?.hasNextPage ?? false;
      _pageNumber = model.body?.request?.page ?? 0;
      _loadMore();
      isFirstLoadRunning(false);
    } else {
      isFirstLoadRunning(false);
      print(model.head?.code.toString());
    }
  }

  Future<void> _loadMore() async {
    scrollController.addListener(() async {
      if (hasNextPage == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunning.value == false &&
          scrollController.position.maxScrollExtent ==
              scrollController.position.pixels) {
        isLoadMoreRunning(true);
        try {

          final model = VideoModel.fromJson(json.decode(
            await apiService.dynamicPostRequest(
              body: {
                "page":_pageNumber.toString()
              },
              url: AppUrl.eventVideoList,
            ),
          ));
          if (model.head!.status! && model.head!.code == 200) {
            hasNextPage = model.body!.hasNextPage!;
            print("load more---${model.body?.request?.page}");
            _pageNumber = model.body?.request?.page ?? 0;
            guideList.addAll(model.body?.guides??[]);
            update();
          }
        } catch (e) {
          print(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    loading(false);
  }
}
