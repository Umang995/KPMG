
import 'package:dreamcast/view/products/controller/productController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
import '../theme/ui_helper.dart';
import 'textview/customTextView.dart';
class ProductListBody extends StatelessWidget {
  dynamic product;
  bool isBookmark;
  ProductListBody({Key? key,required this.product,required this.isBookmark}) : super(key: key);
  ProductController controller=Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: white,
          shape: BoxShape.rectangle,
          border: Border.all(width: 1, color: borderColor),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.loose,
          children: [
            Align(
              alignment: Alignment.center,
              child:
              Padding(
                padding: const EdgeInsets.only(bottom: 40,top: 30),
                child: UiHelper.getProductImage(imageUrl: product.avatar ?? ""),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Positioned(
              bottom: 3,
              left: 3,
              right: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: Colors.transparent),
                child: CustomTextView(
                  text: product.name?.toString().capitalize ?? "",
                  fontSize: 12,
                  color: colorSecondary,
                ),
              ),
            ),
            /*Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () async {
                  var response=await controller.bookmarkToProduct(
                      productId: product.id, context: context);
                  if(response["status"]){
                    product.favourite=response["id"];
                    controller.productList.refresh();
                  }else{
                    product.favourite="";
                    controller.productList.refresh();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    height: 20,
                    width: 20,
                    product.favourite!=null && product.favourite.toString().isNotEmpty
                        ? "assets/icons/star.png"
                        : "assets/icons/empty_star.png",
                    color: starColor,
                  ),
                ),
              ),
            )*/
          ],
        ),
      ),
    );
  }
}

class FavProductListBody extends StatelessWidget {
  dynamic product;
  FavProductListBody({Key? key,required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: white,
          shape: BoxShape.rectangle,
          border: Border.all(width: 1, color: borderColor),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.loose,
          children: [
            Align(
              alignment: Alignment.center,
              child:
              Padding(
                padding: const EdgeInsets.only(bottom: 40,top: 30),
                child: UiHelper.getProductImage(imageUrl: product.avatar ?? ""),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Positioned(
              bottom: 3,
              left: 3,
              right: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: Colors.transparent),
                child: CustomTextView(
                  text: product.name?.toString().capitalize ?? "",
                  fontSize: 12,
                  color: colorSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

