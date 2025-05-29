import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/leaderboard/model/my_criteria_model.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/loading.dart';
import '../../dashboard/showLoadingPage.dart';
import '../controller/leaderboard_controller.dart';
import '../model/criteriaModel.dart';
import '../widget/criteria_child_widget.dart';

class MyPointsPage extends GetView<LeaderboardController> {
  MyPointsPage({Key? key}) : super(key: key);

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final LeaderboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
          padding: const EdgeInsets.all(12),
          child: GetX<LeaderboardController>(builder: (controller) {
            return Stack(
              alignment: Alignment.center,
              children: [
                RefreshIndicator(
                  key: _refreshIndicatorKey,
                  color: Colors.white,
                  backgroundColor: colorPrimary,
                  strokeWidth: 2.0,
                  triggerMode: RefreshIndicatorTriggerMode.anywhere,
                  onRefresh: () async {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        controller.getMyCriteriaApi(isRefresh: true);
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
      child: controller.loading.value
          ? const Loading()
          : !controller.isFirstLoadRunning.value &&
                  controller.myCriteria.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  Widget buildListView(BuildContext context) {
    var pointsList = controller.myCriteria ?? [];
    return Skeletonizer(
      enabled: controller.isFirstLoadRunning.value,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 0),
        separatorBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(
              height: 3,color: borderColor,
            ),
          );
        },
        itemCount: controller.isFirstLoadRunning.value ? 5 : pointsList.length,
        itemBuilder: (context, index) {
          if (controller.isFirstLoadRunning.value) {
            return CriteriaChildWidget(
                points: Criteria(name: "Hello this is dummy text \n Hello "));
          }
          Criteria points = pointsList[index];
          return CriteriaChildWidget(
            points: points,
          );
        },
      ),
    );
  }
}
