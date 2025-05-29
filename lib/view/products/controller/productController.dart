import 'dart:convert';

import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/view/exhibitors/model/product_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../exhibitors/model/bookmark_common_model.dart';
import '../../exhibitors/model/product_detail_model.dart';
import '../../exhibitors/model/product_filter_model.dart';
import '../model/productExhibitorModel.dart';
import '../view/product_details_page.dart';

class ProductController extends GetxController {
  late final AuthenticationManager _authManager;

  late bool hasNextPage = true;
  late dynamic _pageNumber;

  var isLoading = false.obs;
  var isFirstLoadRunning = false.obs;
  var isLoadMoreRunning = false.obs;

  final textController = TextEditingController().obs;
  var selectedIndex = 0.obs;

  ScrollController scrollController = ScrollController();

  var productList = <Products>[].obs;
  var productFilter = ProductFilter().obs;
  var productBody = Product().obs;
  var bookmarkProductId = "".obs;
  var exhibitorId = "";
  var selectedSort = "".obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      exhibitorId = Get.arguments;
    }
    getProductList(body: {
      "page": "1",
      "exhibitor_id": exhibitorId ?? "",
      "filters": {"sort": "ASC", "text": ""},
    }, isRefresh: false);

    getFilter();
    super.onInit();
  }

  //load product list filter
  Future<void> getFilter() async {
    isFirstLoadRunning(true);

    final model = ProductFilterModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: {},
        url: AppUrl.getProductFilter,
      ),
    ));

    if (model.status! && model.code == 200) {
      productFilter.value = model.body ?? ProductFilter();
      update();
    } else {
      update();
    }
    isFirstLoadRunning(false);
  }

  Future<void> getProductList({dynamic body, dynamic isRefresh}) async {
    if (!isRefresh) {
      isFirstLoadRunning(true);
    }

    final model = ProductListModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: body,
        url: "${AppUrl.getProductList}/search",
      ),
    ));
    if (model.status! && model.code == 200) {
      productList.clear();
      productList.value = model.body!.products!;
      hasNextPage = model.body?.hasNextPage ?? false;
      _pageNumber = model.body?.request?.page ?? 0;
      _loadMoreProduct();
    } else {
      productList.clear();
    }
    isFirstLoadRunning(false);
  }

  /*load more product*/
  Future<void> _loadMoreProduct() async {
    scrollController.addListener(() async {
      if (hasNextPage == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunning.value == false &&
          scrollController.position.maxScrollExtent ==
              scrollController.position.pixels) {
        isLoadMoreRunning(true);
        var requestBody = {
          "text": "",
          "exhibitor_id": exhibitorId,
          "filters": {"sort": "ASC", "text": ""},
          "page": _pageNumber.toString(),
        };
        try {
          final model = ProductListModel.fromJson(json.decode(
            await apiService.dynamicPostRequest(
              body: requestBody,
              url: "${AppUrl.getProductList}/search",
            ),
          ));

          if (model!.status! && model!.code == 200) {
            hasNextPage = model.body!.hasNextPage!;
            _pageNumber = model.body?.request?.page ?? 0;
            productList.addAll(model.body!.products!);
            update();
          }
        } catch (e) {
          print(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }

  Future<void> getProductDetail(
      {dynamic body, dynamic productId, required BuildContext context}) async {
    isLoading(true);

    final model = ProductDetailModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: body,
        url: AppUrl.getProductDetail,
      ),
    ));
    isLoading(false);
    if (model!.status! && model!.code == 200) {
      productBody.value = model!.body!;
      bookmarkProductId.value = model!.body!.favourite.toString();
      Get.toNamed(ProductDetailPage.routeName);
      getProductExhibitor(exhibitorId: productBody.value.exhibitorId);
    } else {
      productList.clear();
      UiHelper.showFailureMsg(context, model!.code.toString());
    }
  }

  Future<void> getProductExhibitor({dynamic exhibitorId}) async {
    final model = ProductExhibitorModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: {"exhibitor_id": exhibitorId},
        url: AppUrl.getProductExhibitor,
      ),
    ));

    if (model!.status! && model!.code == 200) {
      productBody.value.exhibitor = model.body;
      productBody.refresh();
      update();
    }
  }

  Future<Map> bookmarkToProduct(
      {required BuildContext context, required productId}) async {
    var jsonRequest = {"favourite_id": productId, "favourite_type": "product"};
    var jsonData = {};
    isLoading(true);
    final model = BookmarkCommonModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: jsonRequest, url: AppUrl.commonBookmarkApi),
    ));

    isLoading(false);
    if (model!.status! && model!.code == 200) {
      bookmarkProductId.value = model!.body!.id ?? "";
      jsonData = {"id": model!.body!.id ?? "", "status": true};
      UiHelper.showSuccessMsg(context, model!.body!.message ?? "");
    } else {
      jsonData = {"id": "", "status": false};
      UiHelper.showSuccessMsg(context, model!.body!.message ?? "");
    }
    return jsonData;
  }
}
