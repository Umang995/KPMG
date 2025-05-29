import 'dart:convert';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:dreamcast/view/exhibitors/model/product_filter_model.dart';
import 'package:dreamcast/view/products/controller/productController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/textview/customTextView.dart';
import 'package:get/get.dart';
import '../../../widgets/button/custom_outlined_button.dart';

class ProductFilterDialogPage extends GetView<ProductController> {
  ProductFilterDialogPage({Key? key}) : super(key: key);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  var selectedList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: white,
        iconTheme:  IconThemeData(color: colorSecondary),
        shape:  RoundedRectangleBorder(
            side: BorderSide(color: colorGray, width: 1)),
        title: ToolbarTitle(title: "choose_filter".tr),
        actions: [
          GestureDetector(
            onTap: () {
              controller.selectedSort = "ASC".obs;
              controller.getFilter();
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.refresh),
            ),
          )
        ],
      ),
      body: Container(
          decoration:  BoxDecoration(
              color: white, borderRadius: const BorderRadius.all(Radius.circular(0))),
          height: context.height,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: GetX<ProductController>(builder: (controller) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSortFilterData(),
                      const SizedBox(
                        height: 12,
                      ),
                      buildFilterData(),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomOutlinedButton(
                    height: 55.v,
                    margin: EdgeInsets.only(bottom: 10.adaptSize),
                    buttonStyle: OutlinedButton.styleFrom(
                      backgroundColor: colorSecondary,
                      side:  BorderSide(color: colorSecondary, width: 1),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    buttonTextStyle: TextStyle(
                        color: white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.fSize),
                    onPressed: () async {
                      var formData = <String, dynamic>{};
                      formData["page"] = "1";
                      _sendDataToServer(formData);
                    },
                    text: "submit".tr,
                  ),
                ),
              ],
            );
          })),
    );
  }

  _sendDataToServer(Map<String, dynamic> formData) async {
    var parentMap = <String, dynamic>{};
    for (var data in controller.productFilter.value.filters ?? []) {
      var mapList = [];
      if (data.value != null && data.value!.isNotEmpty) {
        for (int index = 0; index < data.value!.length; index++) {
          mapList.add(data.value[index]);
        }
        parentMap["${data.name}"] = mapList;
      }
    }
    formData["filters"] = {
      "sort": controller.selectedSort.value,
      "text": "",
      "params": parentMap
    };
    print(jsonEncode(formData));
    Get.back(result: formData);
  }

  buildFilterData() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.productFilter.value.filters?.length,
      itemBuilder: (context, index) {
        var filter = controller.productFilter.value.filters?[index];
        return ExpansionTile(
          initiallyExpanded: true,
          title: Padding(
            padding: const EdgeInsets.all(0),
            child: CustomTextView(
              text: filter?.label.toString().toUpperCase() ?? "",
              color: colorSecondary,
              textAlign: TextAlign.start,
            ),
          ),
          children: [buildOptionData(filter?.options, filter?.value ?? "")],
        );
      },
    );
  }

  buildOptionData(List<Options>? options, dynamic arrSelected) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return SizedBox(
        height: 300,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: options?.length,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var option = options![index];
            return InkWell(
              onTap: () {
                if (arrSelected!.contains(option.id ?? "")) {
                  arrSelected?.remove(option.id);
                } else {
                  arrSelected?.add(option.id);
                }
                setState(() {});
              },
              child: ListTile(
                leading: arrSelected.contains(option.id ?? "")
                    ?  Icon(Icons.check_box, color:colorPrimary)
                    :  Icon(Icons.check_box_outline_blank),
                title: CustomTextView(
                  text: option.name ?? "",
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            );
          },
        ),
      );
    });
  }

  buildSortFilterData() {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
        child: CustomTextView(
          text: controller.productFilter.value.sort?.label?.toUpperCase() ?? "",
          color: colorSecondary,
          textAlign: TextAlign.start,
        ),
      ),
      subtitle: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration:  BoxDecoration(
            color: colorLightGray,
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextView(
                color: colorSecondary,
                fontSize: 16,
                text: controller
                        .productFilter.value.sort?.placeholder?.capitalize ??
                    ""),
            SizedBox(
              width: 220,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      controller.selectedSort(controller
                          .productFilter.value.sort?.options?[0].id
                          .toString());
                    },
                    child: Obx(
                      () => Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          controller.selectedSort.value ==
                                  controller
                                      .productFilter.value.sort?.options?[0].id
                                      .toString()
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: SvgPicture.asset(
                                    ImageConstant.icRadioActive,
                                    height: 22.adaptSize,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: SvgPicture.asset(
                                      ImageConstant.icRadioInactive,
                                      height: 22.adaptSize),
                                ),
                          CustomTextView(
                            text: controller.productFilter.value.sort
                                    ?.options?[0].name ??
                                "",
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      controller.selectedSort(controller
                          .productFilter.value.sort?.options?[1].id
                          .toString());
                    },
                    child: Obx(
                      () => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          controller.selectedSort.value ==
                                  controller
                                      .productFilter.value.sort?.options?[1].id
                                      .toString()
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: SvgPicture.asset(
                                    ImageConstant.icRadioActive,
                                    height: 22.adaptSize,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: SvgPicture.asset(
                                      ImageConstant.icRadioInactive,
                                      height: 22.adaptSize),
                                ),
                          CustomTextView(
                            text: controller.productFilter.value.sort
                                    ?.options?[1].name ??
                                "",
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
