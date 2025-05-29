import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/bestForYou/controller/aiMatchController.dart';
import 'package:dreamcast/widgets/loadMoreItem.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/view/exhibitors/model/exibitorsModel.dart';
import 'package:dreamcast/view/exhibitors/view/bootListBody.dart';
import 'package:dreamcast/view/skeletonView/gridViewSkeleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_decoration.dart';
import '../../../widgets/custom_search_view.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../exhibitors/controller/exhibitorsController.dart';

class AiMatchExhibitorPage extends GetView<AiMatchController> {
  static const routeName = "/AiMatchesBootList";
  AiMatchExhibitorPage({super.key});

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final textController = TextEditingController().obs;
  final BoothController exhibitorsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 0,
        centerTitle: false,
        shape:
            const Border(bottom: BorderSide(color: borderColor, width: 1)),
        title: ToolbarTitle(
          title: "exhibitors".tr,
          color: Colors.black,
        ),
        backgroundColor: white,
        iconTheme:  IconThemeData(color: colorSecondary),
      ),
      body: Container(
        width: context.width,
        padding: EdgeInsets.symmetric(
            vertical: 14.adaptSize, horizontal: 15.adaptSize),
        child: GetX<AiMatchController>(builder: (controller) {
          return Stack(
            children: [
              RefreshIndicator(
                  backgroundColor: colorSecondary,
                  key: _refreshIndicatorKey,
                  child: buildChildList(context),
                  onRefresh: () {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        refreshListAPi(search: "");
                      },
                    );
                  }),
              // when the first load function is running
              _progressEmptyWidget()
            ],
          );
        }),
      ),
    );
  }

  refreshListAPi({required String search}) {
    controller.getDataByIndexPage(1);
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isLoading.value || exhibitorsController.isLoading.value
          ? const Loading()
          : controller.aiExhibitorsList.isEmpty &&
                  !controller.isFirstLoading.value
              ? ShowLoadingPage(
                  refreshIndicatorKey: _refreshIndicatorKey,
                )
              : const SizedBox(),
    );
  }

  Widget buildChildList(BuildContext context) {
    return Skeletonizer(
        enabled: controller.isFirstLoading.value,
        child: controller.isFirstLoading.value
            ? const BootViewSkeleton()
            : GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: controller.exibitorScrollController,
                itemCount: controller.aiExhibitorsList.length,
                itemBuilder: (context, index) =>
                    buildChildMenuBody(controller.aiExhibitorsList[index]),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 9 / 10,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15)));
  }

  Widget buildChildMenuBody(Exhibitors exhibitors) {
    return GestureDetector(
      onTap: () {
        exhibitorsController.getExhibitorsDetail(exhibitors.id);
      },
      child: BootListBody(
        exhibitor: exhibitors,
        isApiLoading: controller.isFirstLoading.value,
      ),
    );
  }
}
