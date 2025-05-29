import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/skeletonView/gridViewSkeleton.dart';
import 'package:dreamcast/view/speakers/view/speakerListBody.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../theme/app_decoration.dart';
import '../../../../utils/image_constant.dart';
import '../../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../../widgets/app_bar/custom_app_bar.dart';
import '../../../../widgets/custom_search_view.dart';
import '../../../../widgets/loadMoreItem.dart';
import '../../../../widgets/loading.dart';
import '../../../../widgets/toolbarTitle.dart';
import '../../../dashboard/showLoadingPage.dart';
import '../../../skeletonView/investorBodySkeleton.dart';
import '../../controller/invenstorController.dart';
import 'investorDetailsPage.dart';
import '../../../../widgets/investorListBody.dart';

class InvestorListPage extends GetView<InvestorController> {
  InvestorListPage({Key? key}) : super(key: key);
  static const routeName = "/InvestorListPage";

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
        title: ToolbarTitle(title: controller.title),
      ),
      body: GetX<InvestorController>(builder: (controller) {
        return Container(
          color: Colors.transparent,
          width: context.width,
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      child: RefreshIndicator(
                    backgroundColor: colorSecondary,
                    key: _refreshIndicatorKey,
                    onRefresh: () {
                      return Future.delayed(
                        const Duration(seconds: 1),
                        () {
                          callUserListAPi(search: "", isRefresh: false);
                        },
                      );
                    },
                    child: buildChildList(context),
                  )),
                  // when the _loadMore function is running
                  controller.isLoadMoreRunning.value
                      ? const LoadMoreLoading()
                      : const SizedBox()
                ],
              ),
              _progressEmptyWidget()
            ],
          ),
        );
      }),
    );
  }

  callUserListAPi({required String search, required isRefresh}) async {
    var body = {
      "page": "1",
      "type": controller.isInvestor ? "investor" : "mentor"
    };
    await controller.getAspireList(requestBody: body, isRefresh: isRefresh);
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isLoading.value
          ? const Loading()
          : !controller.isFirstLoadRunning.value &&
                  controller.investorList.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  Widget buildChildList(BuildContext context) {
    return Skeletonizer(
        enabled: controller.isFirstLoadRunning.value,
        child: controller.isFirstLoadRunning.value
            ? const InvestorListSkeleton()
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: controller.scrollController,
                itemCount: controller.investorList.length,
                itemBuilder: (context, index) =>
                    buildListBody(controller.investorList[index]),
              ));
  }

  Widget buildListBody(dynamic representatives) {
    return InkWell(
      onTap: () async {
        await controller.getUserDetail(
            representatives.id);
        if (controller.investorBody.value.id != null) {
          Get.toNamed(InvestorDetailPage.routeName,
              arguments: controller.isInvestor);
        }
      },
      child: InvestorListBody(representatives: representatives),
    );
  }
}
