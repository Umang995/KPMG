import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/breifcase/controller/common_document_controller.dart';
import 'package:dreamcast/view/breifcase/model/BriefcaseModel.dart';
import 'package:dreamcast/view/home/screen/inAppWebview.dart';
import 'package:dreamcast/view/home/screen/pdfViewer.dart';
import 'package:dreamcast/view/skeletonView/resource_center_skeleton.dart';
import 'package:dreamcast/widgets/app_bar/appbar_leading_image.dart';
import 'package:dreamcast/widgets/app_bar/custom_app_bar.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/widgets/fullscreen_image.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../routes/my_constant.dart';
import '../../../widgets/home_widget/common_document_widget.dart';
import '../../../widgets/loading.dart';
import '../../commonController/bookmark_request_model.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../skeletonView/ListDocumentSkeleton.dart';

class BriefcasePage extends GetView<CommonDocumentController> {
  BriefcasePage({super.key});
  static const routeName = "/BreifcasePage";

  TextEditingController editNotesController = TextEditingController();

  ///refresh the page.
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  CommonDocumentController resourceCenterController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        height: 72.v,
        leadingWidth: 45.h,
        leading: AppbarLeadingImage(
          imagePath: ImageConstant.imgArrowLeft,
          margin: EdgeInsets.only(
            left: 7.h,
            top: 3,
            // bottom: 12.v,
          ),
          onTap: () {
            Get.back();
          },
        ),
        title: ToolbarTitle(
            title: Get.arguments?[MyConstant.titleKey] ?? "briefcase".tr),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: initListviewBuilder(context), // Speakers Notes List
      ),
    );
  }

  ///*********** Speakers Notes List **************///
  initListviewBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GetX<CommonDocumentController>(
        builder: (controller) {
          // If no limit is set or it's not 3, fall back to the scrollable ListView
          return Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration:  BoxDecoration(
                  color: colorLightGray,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Skeletonizer(
                  enabled: controller.isFirstLoadRunning.value,
                  child: controller.isFirstLoadRunning.value
                      ? ResourceCenterSkeleton()
                      : ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: controller.briefcaseList.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            DocumentData data = controller.briefcaseList[index];
                            return CommonDocumentWidget(
                              data: data,
                              isBriefcase: true,
                              showBookmark: true,
                              onBookmarkTap: () async {
                                controller.briefcaseList.remove(data);
                                controller.briefcaseList.refresh();
                                //data.isFavLoading(true);
                                await controller.bookmarkToItem(
                                    requestBody: BookmarkRequestModel(
                                        itemType: MyConstant.document,
                                        itemId: data.id ?? ""));
                                //data.isFavLoading(false);
                              },
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(
                              height: 1,
                              color: borderColor,
                            );
                          },
                        ),
                ),
              ),
              _progressEmptyWidget()
            ],
          );
        },
      ),
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.loading.value
          ? const Loading()
          : !controller.isFirstLoadRunning.value &&
                  controller.briefcaseList.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }
}
