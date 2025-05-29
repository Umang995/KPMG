
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/view/products/controller/productController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import '../../../widgets/flow_widget.dart';
import '../../../widgets/toolbarTitle.dart';

class ProductDetailPage extends GetView<ProductController> {
  ProductDetailPage({Key? key}) : super(key: key);
  static const routeName = "/ProductDetailPage";
  final AuthenticationManager _authenticationManager = Get.find();

  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  var isKnowMore = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title:  ToolbarTitle(
          title: "products_detail".tr,
          color: Colors.black,
        ),
        shape:
            const Border(bottom: BorderSide(color: borderColor, width: 1)),
        elevation: 0,
        backgroundColor: white,
        iconTheme:  IconThemeData(color: colorSecondary),
      ),
      body: Container(
          color: white,
          height: context.height,
          width: context.width,
          //padding: const EdgeInsets.all(0),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          child: GetX<ProductController>(
            builder: (controller) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextView(
                          text: controller.productBody.value.name
                                  .toString()
                                  .capitalize ??
                              "",
                          fontSize: 18,
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildBannerView(),
                        _buildCircleIndicator(),
                        const SizedBox(
                          height: 6,
                        ),
                        ListTile(
                          title:  CustomTextView(
                            text: 'INFORMATION',
                            color: colorSecondary,
                            fontSize: 16,textAlign: TextAlign.start,
                          ),
                          contentPadding: EdgeInsets.zero,
                          trailing: GestureDetector(
                            onTap: () {
                              controller.bookmarkToProduct(
                                  context: context,
                                  productId: controller.productBody.value.id);
                            },
                            child: Image.asset(
                              height: 30,
                              width: 30,
                              controller.bookmarkProductId.isNotEmpty
                                  ? "assets/icons/star.png"
                                  : "assets/icons/empty_star.png",

                            ),
                          ),
                          subtitle: Text(
                              controller.productBody.value.description ?? ""),
                        ),
                        const Divider(),
                        commonListWidget(
                            controller.productBody.value.categories,
                            "Category"),
                        const Divider(),
                        exhibitorWidget(),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                  controller.isLoading.value
                      ? const Loading()
                      : const SizedBox()
                ],
              );
            },
          )),
    );
  }

  commonListWidget(dynamic params, String title) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: CustomTextView(
          text: title.toUpperCase() ?? "",
          color: colorSecondary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          textAlign: TextAlign.start,
        ),
      ),
      subtitle: ListView.separated(
        padding: const EdgeInsets.all(0),
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 0,
            child: Divider(
              color: Colors.transparent,
            ),
          );
        },
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: params?.length ?? 0,
        itemBuilder: (context, index) {
          var data = params?[index];
          if (data.params is List) {
            return _dynamicFilterWidget(data.params ?? [], false, data?.label);
          } else {
            return _textWidget(data?.text ?? "", data?.value ?? "");
          }
        },
      ),
    );
  }

  _textWidget(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: CustomTextView(
                  text: "$label :",
                  textAlign: TextAlign.start,
                  color: colorSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: colorLightGray,
                            borderRadius: BorderRadius.circular(6)),
                        child: CustomTextView(
                          text: value,
                          textAlign: TextAlign.end,
                          color: colorSecondary,
                          fontSize: 14,
                          maxLines: 10,
                        ),
                      )
                    ],
                  ))
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  _dynamicFilterWidget(List<dynamic>? value, isBg, label) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: CustomTextView(
        text: "$label :",
        textAlign: TextAlign.start,
        color: colorSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      subtitle: Wrap(
        spacing: 10,
        children: <Widget>[
          for (var item in value!) MyFlowWidget(item ?? "", isBgColor: true),
        ],
      ),
    );
  }

  exhibitorWidget() {
    return controller.productBody.value.exhibitor != null
        ? Container(
            padding: const EdgeInsets.all(6),
            decoration:  BoxDecoration(
                color: colorLightGray,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Center(
              child: ListTile(
                leading: SizedBox(
                  width: 60,
                  child: UiHelper.getProductImage(
                      imageUrl:
                          controller.productBody.value.exhibitor?.avatar ?? ""),
                ),
                title: CustomTextView(
                  text: controller.productBody.value.exhibitor?.company ?? "",
                  textAlign: TextAlign.start,
                  fontSize: 16,
                  color: colorSecondary,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextView(
                        textAlign: TextAlign.start,
                        text:
                            "Floor:${controller.productBody.value.exhibitor?.hallNumber ?? ""}"),
                    CustomTextView(
                        textAlign: TextAlign.start,
                        text:
                            "Booth Number:${controller.productBody.value.exhibitor?.boothNumber ?? ""}"),
                    /* RegularTextView(
                        textAlign: TextAlign.start,
                        text:
                            "Booth Type:${controller.productBody.value.exhibitor?.boothType ?? ""}")*/
                  ],
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  _buildBannerView() {
    return SizedBox(
      height: 200,
      child: PageView.builder(
          itemCount: controller.productBody.value.gallery?.length,
          controller: _pageController,
          itemBuilder: (BuildContext context, int index) {
            var url = controller.productBody.value.gallery![index];
            return SizedBox(
              height: 400,
              child: CachedNetworkImage(
                imageUrl: url,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  ImageConstant.products,
                  color: colorLightGray,
                ),
              ),
            );
          },
          onPageChanged: (int index) {
            _currentPageNotifier.value = index;
          }),
    );
  }

  _buildCircleIndicator() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CirclePageIndicator(
          selectedBorderColor: colorSecondary,
          selectedDotColor: colorSecondary,
          dotColor: Colors.white,
          borderColor: Colors.black,
          borderWidth: 1,
          itemCount: controller.productBody.value.gallery!.length,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
    );
  }
}
