import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../routes/my_constant.dart';
import '../theme/app_colors.dart';
import '../view/breifcase/controller/common_document_controller.dart';
import '../view/breifcase/model/BriefcaseModel.dart';

import '../view/commonController/bookmark_request_model.dart';
import 'home_widget/common_document_widget.dart';

class ResourceCenterWidget extends GetView<CommonDocumentController> {
  final bool isFromHome; // Optional limit parameter to control item display

  const ResourceCenterWidget({super.key, required this.isFromHome});

  @override
  Widget build(BuildContext context) {
    return GetX<CommonDocumentController>(
      builder: (controller) {
        int itemCount = isFromHome
            ? (controller.launchpadResCenterList.length > 3
                ? 3
                : controller.launchpadResCenterList.length)
            : controller.resourceCenterList.length;
        // If no limit is set or it's not 3, fall back to the scrollable ListView
        return Container(
          decoration: BoxDecoration(
            color: colorLightGray,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: itemCount,
            physics: isFromHome
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              DocumentData data = isFromHome
                  ? controller.launchpadResCenterList[index]
                  : controller.resourceCenterList[index];
              return CommonDocumentWidget(
                data: data,
                isBriefcase: false,
                onBookmarkTap: () async {
                  //data.isFavLoading(true);
                  if (controller.bookMarkIdsList.contains(data.id)) {
                    controller.bookMarkIdsList.remove(data.id);
                  } else {
                    controller.bookMarkIdsList.add(data.id);
                  }
                  await controller.bookmarkToItem(
                      requestBody: BookmarkRequestModel(
                          itemType: MyConstant.document,
                          itemId: data.id ?? ""));
                },
                showBookmark: true,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                height: 1,
                color: borderColor,
              );
            },
          ),
        );
      },
    );
  }
}
