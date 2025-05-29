import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/skeletonView/ListDocumentSkeleton.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher_string.dart';
import '../../../../../theme/app_colors.dart';
import '../../../routes/my_constant.dart';
import '../../../widgets/custom_linkfy.dart';
import '../../dashboard/showLoadingPage.dart';
import '../controller/info_guide_controller.dart';
import 'package:flutter/services.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../widgets/loading.dart';

class DoDontScreen extends GetView<InfoFaqController> {
  DoDontScreen({Key? key}) : super(key: key);

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final controller = Get.put(InfoFaqController());
  ExpansionTileController expansionTileController = ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: GetX<InfoFaqController>(
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
                        controller.getTips(isRefresh: false);
                      },
                    );
                  },
                  child: Container(
                    decoration:  BoxDecoration(
                        color: colorLightGray,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Skeletonizer(
                      enabled: controller.isFirstLoading.value,
                      child: controller.isFirstLoading.value
                          ? const ListDocumentSkeleton()
                          : SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  controller.tipsList.value.doData?.options !=
                                              null &&
                                          controller.tipsList.value.doData
                                              ?.options.isNotEmpty
                                      ? ListTile(
                                          title: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: CustomTextView(
                                              text: controller.tipsList.value
                                                      .doData?.label ??
                                                  "",
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          subtitle: buildListView(
                                              context,
                                              controller.tipsList.value.doData
                                                      ?.options ??
                                                  []),
                                        )
                                      : const SizedBox(),
                                  controller.tipsList.value.donotData
                                                  ?.options !=
                                              null &&
                                          controller.tipsList.value.donotData
                                              ?.options.isNotEmpty
                                      ? ListTile(
                                          title: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: CustomTextView(
                                              text: controller.tipsList.value
                                                      .donotData?.label ??
                                                  "",
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          subtitle: buildListView(
                                              context,
                                              controller.tipsList.value
                                                      .donotData?.options ??
                                                  []),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                    ),
                  ),
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
      child: controller.isFirstLoading.value
          ? const SizedBox()
          : !controller.isFirstLoading.value &&
                      (controller.tipsList.value.doData == null &&
                          controller.tipsList.value.donotData == null) ||
                  (controller.tipsList.value.doData?.options.isEmpty &&
                      controller.tipsList.value.donotData?.options.isEmpty)
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  Widget buildListView(BuildContext context, List itemList) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 12,
        );
      },
      itemCount: itemList.length,
      itemBuilder: (context, index) {
        final item = itemList[index];
        String numbering = (index + 1).toString();
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CustomTextView(
                  text: "$numbering.",
                  fontSize: 20,
                  color: colorSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                  child: ReadMoreLinkify(
                text: item?.replaceAll("<br", "").replaceAll("/>", "") ?? "",
                maxLines:
                    100, // Set the maximum number of lines before truncation
                style: TextStyle(
                    fontSize: 16.fSize,
                    color: colorSecondary,
                    fontWeight: FontWeight.normal),
                textAlign: TextAlign.start,
                linkStyle: TextStyle(
                    fontSize: 16.fSize,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500),
                onOpen: (link) async {
                  final Uri url = Uri.parse(link.url);
                  if (await canLaunchUrlString(link.url)) {
                    await launchUrlString(link.url,
                        mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ))
            ],
          ),
          const SizedBox(height: 16),
        ]);
      },
    );
  }
}
