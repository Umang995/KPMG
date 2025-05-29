import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../routes/my_constant.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/fullscreen_image.dart';
import '../../../widgets/home_widget/common_document_widget.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../commonController/bookmark_request_model.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../home/screen/inAppWebview.dart';
import '../../home/screen/pdfViewer.dart';
import '../controller/exhibitorsController.dart';

class DocumentListPage extends GetView<BoothController> {
  DocumentListPage({Key? key}) : super(key: key);

  bool showAppbar = false;

  static const routeName = "/DocumentListPage";
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

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
        title: ToolbarTitle(title: "documents".tr),
      ),
      body: Container(
          padding: const EdgeInsets.all(16),
          child: GetX<BoothController>(builder: (controller) {
            return Stack(
              children: [
                RefreshIndicator(
                  key: _refreshIndicatorKey,
                  color: colorLightGray,
                  backgroundColor: colorPrimary,
                  strokeWidth: 1.0,
                  triggerMode: RefreshIndicatorTriggerMode.anywhere,
                  onRefresh: () async {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        controller.getExhibitorsDocument(
                            type: "documents",
                            isRefresh: true,
                            context: context);
                      },
                    );
                  },
                  child: buildListView(context),
                ),
                // when the first load function is running
                _progressEmptyWidget()
              ],
            );
          })),
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isLoading.value
          ? const Loading()
          : controller.documentList.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  Widget buildListView(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        color: colorLightGray,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 1,
            color: borderColor,
          );
        },
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: controller.documentList.length,
        itemBuilder: (context, index) {
          var data = controller.documentList[index];
          return CommonDocumentWidgetBoot(
            data: data,
            showBookmark: true,
            onBookmarkTap: () async {
              //data.isFavLoading(true);
              await controller.bookmarkToExhibitorItem(
                  id: data.id, itemType: "document");
              //data.isFavLoading(false);
            },
          );
        },
      ),
    );
  }
}
