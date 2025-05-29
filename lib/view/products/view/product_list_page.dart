import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/view/exhibitors/model/product_list_model.dart';
import 'package:dreamcast/widgets/productListBody.dart';
import 'package:dreamcast/view/products/view/product_filter_dialog_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../widgets/custom_search_view.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/showLoadingPage.dart';
import '../controller/productController.dart';

class ProductListPage extends GetView<ProductController> {
  static const routeName = "/ProductListPage";
  bool showAppbar = true;
  ProductListPage({Key? key}) : super(key: key);

  final GlobalKey<RefreshIndicatorState> _refreshTab1Key =
      GlobalKey<RefreshIndicatorState>();

  final GlobalKey<RefreshIndicatorState> _refreshTab2Key =
      GlobalKey<RefreshIndicatorState>();

  final controller = Get.put(ProductController());
  var tabList = ["Anu Tech", "Anu Food"];
  var selectedParentIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        //toolbarHeight: showAppbar ? 40 : 40,
        title: ToolbarTitle(
          title: "products".tr,
          color: Colors.black,
        ),
        shape: Border(
            bottom:
                BorderSide(color: borderColor, width: showAppbar ? 0.3 : 0)),
        elevation: 0,
        backgroundColor: white,
        iconTheme:  IconThemeData(color: colorSecondary),
      ),
      body: false ? tabMenuBar(context) : buildTabFirst(context),
    );
  }

  tabMenuBar(BuildContext context) {
    return DefaultTabController(
      length: tabList.length,
      child: Scaffold(
      backgroundColor:Theme.of(context).scaffoldBackgroundColor,
        appBar: TabBar(
          labelColor: colorSecondary,
          indicatorColor: colorSecondary,
          onTap: (index) {
            controller.selectedIndex(index);
            callProductListAPi(search: "", isRefresh: false);
          },
          tabs: <Widget>[
            ...List.generate(
              tabList.length,
              (index) => Tab(
                text: tabList[index].toUpperCase(),
              ),
            ),
          ],
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            buildTabFirst(context),
            buildTabSecond(context),
          ],
        ),
      ),
    );
  }

  callProductListAPi({required String search, isRefresh}) {
    var body = {
      "page": "1",
      "exhibitor_id": controller.exhibitorId,
      "filters": {"sort": "ASC", "search": search},
    };
    controller.getProductList(body: body, isRefresh: isRefresh);
  }

  Widget buildTabFirst(BuildContext context) {
    return Container(
        color: white,
        width: context.width,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: GetX<ProductController>(builder: (controller) {
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomSearchView(
                    hintText: "products".tr,
                    controller: controller.textController.value,
                    press: () async {
                      var result =
                          await Get.to(() => ProductFilterDialogPage());
                      if (result != null) {
                        controller.getProductList(
                            body: result, isRefresh: false);
                      }
                    },
                    onSubmit: (result) async {
                      callProductListAPi(search: result, isRefresh: false);
                    },
                    onClear: (data) {},
                  ),
                  Expanded(
                      child: RefreshIndicator(
                    key: _refreshTab1Key,
                    color: Colors.white,
                    backgroundColor: colorSecondary,
                    strokeWidth: 4.0,
                    triggerMode: RefreshIndicatorTriggerMode.anywhere,
                    onRefresh: () async {
                      return Future.delayed(
                        const Duration(seconds: 1),
                        () {
                          callProductListAPi(search: "", isRefresh: true);
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
              _progressEmptyWidget()
            ],
          );
        }));
  }

  Widget buildTabSecond(BuildContext context) {
    return Container(
        color: white,
        width: context.width,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: GetX<ProductController>(builder: (controller) {
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomSearchView(
                    hintText: "products".tr,
                    controller: controller.textController.value,
                    press: () async {
                      var result =
                          await Get.to(() => ProductFilterDialogPage());
                      if (result != null) {
                        controller.getProductList(
                            body: result, isRefresh: false);
                      }
                    },
                    onSubmit: (result) async {
                      callProductListAPi(search: result, isRefresh: false);
                    },
                    onClear: (data) {},
                  ),
                  Expanded(
                      child: RefreshIndicator(
                    key: _refreshTab2Key,
                    color: Colors.white,
                    backgroundColor: colorSecondary,
                    strokeWidth: 4.0,
                    triggerMode: RefreshIndicatorTriggerMode.anywhere,
                    onRefresh: () async {
                      return Future.delayed(
                        const Duration(seconds: 1),
                        () {
                          callProductListAPi(search: "", isRefresh: true);
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
              _progressEmptyWidget()
            ],
          );
        }));
  }

  Widget buildListView(BuildContext context) {
    return Skeletonizer(
        enabled: controller.isFirstLoadRunning.value,
        //skeleton: const GridViewSkeleton(),
        child: GridView.builder(
          controller: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          // shrinkWrap: false,
          itemCount: controller.productList.length,
          itemBuilder: (context, index) =>
              buildChildMenuBody(controller.productList[index], context),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16),
        ));
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isLoading.value
          ? const Loading()
          : controller.productList.isEmpty &&
                  !controller.isFirstLoadRunning.value
              ? ShowLoadingPage(
                  refreshIndicatorKey: controller.selectedIndex.value == 0
                      ? _refreshTab1Key
                      : _refreshTab2Key)
              : const SizedBox(),
    );
  }

  Widget buildChildMenuBody(Products products, BuildContext context) {
    return InkWell(
      onTap: () {
        var body = {"id": products.id};
        controller.getProductDetail(
            body: body, productId: products.id, context: context);
      },
      child: ProductListBody(product: products, isBookmark: true),
    );
  }
}
