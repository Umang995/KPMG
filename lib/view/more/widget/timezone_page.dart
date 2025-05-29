import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:dreamcast/view/more/controller/timezoneController.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_search_view.dart';
import '../../../widgets/button/common_material_button.dart';
import '../../dashboard/showLoadingPage.dart';

class TimezonePage extends GetView<TimezoneController> {
  static const routeName = "/time_zone";

  @override
  final controller = Get.put(TimezoneController());

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final textController = TextEditingController().obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        height: 72.v,
        leadingWidth: 45.h,
        leading: AppbarLeadingImage(
          imagePath: ImageConstant.imgArrowLeft,
          margin: EdgeInsets.only(left: 7.h, top: 3),
          onTap: () => Get.back(),
        ),
        title: ToolbarTitle(title: "time_zone".tr),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: GetX<TimezoneController>(
                    builder: (controller) => Stack(
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 12),
                            _buildSearchView(),
                            const SizedBox(height: 5),
                            _buildSelectedTimezoneTile(),
                            const Divider(),
                            Expanded(
                              child: _buildRefreshIndicator(),
                            ),
                          ],
                        ),
                        _progressEmptyWidget(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildSearchView() {
    return CustomSearchView(
      isShowFilter: false,
      hintText: "search_here".tr,
      hintStyle: const TextStyle(fontSize: 16),
      controller: textController.value,
      press: () => controller.filterSearchResults(""),
      onSubmit: (result) => controller.filterSearchResults(result),
      onClear: (_) => controller.filterSearchResults(""),
    );
  }

  Widget _buildSelectedTimezoneTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: CustomTextView(
        text: "selected_timezone".tr,
        color: colorGray,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      subtitle: CustomTextView(
        text:
            controller.getTimezoneNameById(controller.selectedTimezone.value) ??
                "",
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      trailing: const Icon(Icons.check),
    );
  }

  Widget _buildRefreshIndicator() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      color: Colors.white,
      backgroundColor: colorSecondary,
      strokeWidth: 4.0,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () async {
        await controller.getTimezoneData();
      },
      child: buildListView(),
    );
  }

  Widget buildListView() {
    return ListView.separated(
      separatorBuilder: (_, __) =>
          SizedBox(height: 0, child: Container(color: borderColor)),
      itemCount: controller.tempList.length,
      itemBuilder: (context, index) {
        final timezone = controller.tempList[index];
        final isActive = timezone.value == controller.selectedTimezone.value;

        return InkWell(
          onTap: () => controller.selectedTimezone.value = timezone.value ?? "",
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: CustomTextView(
              text: "${timezone.offset?.text ?? ""} ${timezone.text ?? ""}",
              textAlign: TextAlign.start,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isLoading.value
          ? const Loading()
          : controller.tempList.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  Widget _buildSaveButton() {
    return Positioned(
      bottom: 6,
      left: 16,
      right: 16,
      child: CommonMaterialButton(
        color: colorPrimary,
        onPressed: () => controller.setTimezone(
          context: Get.context,
          timezone: controller.selectedTimezone.value,
        ),
        text: "save_changes".tr,
      ),
    );
  }
}
