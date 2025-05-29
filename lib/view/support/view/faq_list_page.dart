import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/view/guide/controller/info_guide_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';

import 'package:skeletonizer/skeletonizer.dart';
import '../../../routes/my_constant.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../skeletonView/ListDocumentSkeleton.dart';
import '../controller/faq_controller.dart';

class FaqListPage extends GetView<SOSFaqController> {
  FaqListPage({Key? key}) : super(key: key);

  static const routeName = "/FaqListPage";

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  ExpansionTileController expansionTileController = ExpansionTileController();
  var expendIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        centerTitle: false,
        title: ToolbarTitle(
          title: "faq".tr,
          color: Colors.black,
        ),
        shape:
            const Border(bottom: BorderSide(color: borderColor, width: 1)),
        backgroundColor: white,
        iconTheme: IconThemeData(color: colorSecondary),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 12, left: 15, right: 15),
        child: GetX<SOSFaqController>(
          builder: (controller) {
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
                        controller.getFaqList(isRefresh: true);
                      },
                    );
                  },
                  child: buildListView(context),
                ),
                // when the first load function is running
                _progressEmptyWidget()
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.loading.value
          ? const Loading()
          : !controller.isFirstLoading.value && controller.faqList.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  Widget buildListView(BuildContext context) {
    return Skeletonizer(
        enabled: controller.isFirstLoading.value,
        child: controller.isFirstLoading.value
            ? const ListDocumentSkeleton()
            : ListView.separated(
                padding: EdgeInsets.zero,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 12,
                  );
                },
                itemCount: controller.faqList.length,
                itemBuilder: (context, index) {
                  var data = controller.faqList[index];
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    decoration:  BoxDecoration(
                      color: colorLightGray,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        initiallyExpanded:
                            index == expendIndex.value ? true : false,
                        tilePadding: const EdgeInsets.only(bottom: 0),
                        title: CustomTextView(
                          text: data.title ?? "",
                          fontSize: 18,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w500,
                          maxLines: 20,
                        ),
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: HtmlWidget(
                                textStyle: TextStyle(
                                  color: colorGray,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16.fSize,
                                ),
                                data.description ?? "",
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ));
  }
}
