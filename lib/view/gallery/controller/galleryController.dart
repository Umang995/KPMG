import 'dart:convert';

import 'package:dreamcast/api_repository/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../api_repository/app_url.dart';
import '../model/galleryModel.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';

class GalleryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  ScrollController videoScrollController = ScrollController();
  late bool hasNextPage;
  late int _pageNumber;
  var videoList = <VideoGalleryDetail>[].obs;
  var isLoading = false.obs;
  var firstLoading = false.obs;
  var isLoadMoreRunning = false.obs;

  final selectedTabIndex = 0.obs;
  late TabController _tabController;
  TabController get tabController => _tabController;
  //******** Tab List Items ***********
  var tabList = ["Images", "Videos"];

  @override
  void onInit() {
    super.onInit();
    //******** Initialize tab ***********
    _tabController = TabController(vsync: this, length: 2);
    getGalleryList(); // Fetch images initially
  }

  Future<void> getGalleryList() async {
    isLoading(true);
    _pageNumber = 1;
    Map<String, dynamic> requestBody = {
      "type": selectedTabIndex.value == 0 ? "image" : "video",
      "page": _pageNumber,
    };
    final model = GalleryModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: requestBody,
        url: AppUrl.galleryGet,
      ),
    ));
    isLoading(false);
    if (model.status! && model.code == 200) {
      videoList.clear();
      videoList.addAll(model.body?.mediaData ?? []);
      videoList.refresh();
      hasNextPage = model.body?.hasNextPage ?? false;
      _pageNumber = _pageNumber + 1;
      if (hasNextPage) {
        _loadMoreVideos();
      }
      isLoading(false);
      update();
    } else {
      isLoading(false);
      update();
    }
  }

  //add pagination for video.json
  Future<void> _loadMoreVideos() async {
    videoScrollController.addListener(() async {
      if (hasNextPage == true &&
          isLoading.value == false &&
          isLoadMoreRunning.value == false &&
          videoScrollController.position.maxScrollExtent ==
              videoScrollController.position.pixels) {
        isLoadMoreRunning(true);
        try {
          Map<String, dynamic> requestBody = {
            "type": selectedTabIndex.value == 0 ? "image" : "video",
            "page": _pageNumber,
          };
          final model = GalleryModel.fromJson(json.decode(
            await apiService.dynamicPostRequest(
              body: requestBody,
              url: AppUrl.galleryGet,
            ),
          ));
          if (model.status! && model.code == 200) {
            hasNextPage = model.body!.hasNextPage!;
            _pageNumber = _pageNumber + 1;
            videoList.addAll(model.body?.mediaData ?? []);
            update();
          }
        } catch (e) {
          print(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }

  void openVideo(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
