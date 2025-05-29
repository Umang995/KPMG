import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/exhibitors/request_model/request_model.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:dreamcast/view/exhibitors/model/exhibitors_filter_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/app_decoration.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/textview/customTextView.dart';
import 'package:get/get.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/flow_widget.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/button/common_material_button.dart';
import '../controller/exhibitorsController.dart';

class ExhibitorFilterDialogPage extends GetView<BoothController> {
  const ExhibitorFilterDialogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: colorLightGray,
      appBar: _buildAppbar(),
      body: Container(
          height: context.height,
          width: double.maxFinite,
          margin: EdgeInsets.only(top: 0.v),
          padding:
              const EdgeInsets.only(top: 16, bottom: 10, right: 16, left: 16),
          decoration: AppDecoration.roundedBoxDecoration,
          child: GetX<BoothController>(
            builder: (controller) {
              return Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFilterOptionsRow(context),
                              _buildSortWidget(
                                  controller.exhibitorFilterData.value.sort),
                              // const SizedBox(height: 12,),
                              _buildFilterParentData(),
                              if (controller.exhibitorFilterData.value.notes !=
                                  null)
                                _buildFilterNotes(
                                    controller.exhibitorFilterData.value.notes),
                            ],
                          ),
                        ),
                      ),
                      CommonMaterialButton(
                        color: colorPrimary,
                        onPressed: () async {
                          if (controller.isReset.value) {
                            controller.tempExhibitorFilterData(
                                controller.exhibitorFilterData.value);
                            controller.isFilterApply(false);
                          } else {
                            controller.isFilterApply(true);
                          }
                          _sendDataToServer();
                        },
                        text: "Apply Filters".tr,
                      ),
                    ],
                  ),
                  Obx(() => controller.isLoading.value
                      ? const Loading()
                      : const SizedBox())
                ],
              );
            },
          )),
    );
  }

  _sendDataToServer() async {
    controller.isFilterApply(false);
    var parentMap = <String, dynamic>{};
    for (Filters data in controller.exhibitorFilterData.value.filters ?? []) {
      if (data.value != null && data.value.toString().isNotEmpty) {
        data.options?.forEach((option) {
          option.apply =
              data.value.toString().contains(option.id ?? "") ? true : false;
        });
        parentMap[data.name ?? ""] = data.value;
      } else {
        data.apply = false;
      }
    }
    final filter = controller.exhibitorFilterData.value;
    controller.bootRequestModel.filters = RequestFilters(
        text: controller.textController.value.text.trim() ?? "",
        sort: filter.sort?.value ?? "",
        notes: filter.notes?.value ?? false,
        params: parentMap);

    controller.exhibitorFilterData.value.notes?.apply =
        controller.isNotesFilter.value ? true : false;

    filter.notes?.apply = filter?.notes?.value ?? false;
    controller.isFilterApply(controller.isFilterApplied);
    Get.back(result: true);
  }

  //filter for block
  Widget _buildFilterNotes(RadioFilterData? notes) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 16),
      decoration: AppDecoration.grayFilterCardDialog.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppDecoration.commonLabelTextWidget(notes?.label ?? ""),
          GestureDetector(
              onTap: () async {
                if (notes?.value == true) {
                  notes?.value = false;
                } else {
                  notes?.value = true;
                }
                controller.isNotesFilter(notes?.value);
                controller.exhibitorFilterData.refresh();
              },
              child: SvgPicture.asset(
                  height: 20,
                  colorFilter: ColorFilter.mode(
                      notes?.value == true ? colorPrimary : colorGray,
                      BlendMode.srcIn),
                  notes?.value == true
                      ? ImageConstant.toggle_button
                      : ImageConstant.toggle_off))
        ],
      ),
    );
  }

  ///initial column widget
  _buildFilterParentData() {
    List<Filters> filterList =
        controller.exhibitorFilterData.value.filters ?? [];
    return ListView.builder(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: filterList.length,
      itemBuilder: (context, index) {
        var filter = filterList[index];
        return filter.type == "radio" || filter.type == "select"
            ? _buildSingleSelection(filter)
            : _buildMultipleSelection(filter);
      },
    );
  }

  ///used for radio Widget
  Widget _buildSingleSelection(Filters? filter) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        width: double.maxFinite,
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(20),
        decoration: AppDecoration.grayFilterCardDialog.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppDecoration.commonLabelTextWidget(filter?.label.toString() ?? ""),
            const SizedBox(
              height: 16,
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton2<Options>(
                isExpanded: true,
                hint: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 50,
                    width: context.width,
                    decoration: BoxDecoration(
                        color: white, borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextView(
                          text: filter?.value != null &&
                                  filter!.value.toString().isNotEmpty
                              ? filter.value.toString()
                              : filter?.placeholder ?? "",
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                        const Icon(Icons.arrow_drop_down,
                            color: Colors
                                .black), // Ensure 'black' is defined or use 'Colors.black'
                      ],
                    )),
                items: filter?.options
                    ?.map((Options option) => DropdownMenuItem<Options>(
                          value: option,
                          child: ListTile(
                            leading: SvgPicture.asset(
                              colorFilter: ColorFilter.mode(
                                  filter.value.toString() == option.id
                                      ? colorPrimary
                                      : colorGray,
                                  BlendMode.srcIn),
                              ImageConstant.icRadioActive,
                              width: 22,
                            ),
                            title: CustomTextView(
                              text: option.name ?? "",
                              fontSize: 15,
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.normal,
                              color: colorSecondary,
                            ),
                          ),
                        ))
                    .toList(),
                //value: ,
                onChanged: (Options? option) {
                  if (filter?.value.toString() == option?.id) {
                    filter?.value = "";
                  } else {
                    filter?.value = option?.id;
                  }
                  setState(() {});
                },
                buttonStyleData: const ButtonStyleData(
                  height: 50,
                  width: double.infinity,
                ),
                iconStyleData: const IconStyleData(
                  icon: SizedBox.shrink(), // Hide the icon
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 220,
                  width: context.width - 40 - 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: white,
                  ),
                  offset: const Offset(0, 0),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.zero,
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  ///used for checkbox Widget
  Widget _buildMultipleSelection(Filters? filter) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        width: context.width,
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(20),
        decoration: AppDecoration.grayFilterCardDialog.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppDecoration.commonLabelTextWidget(filter?.label.toString() ?? ""),
            const SizedBox(height: 5),
            _buildSelectedOption(filter!),
            const SizedBox(
              height: 12,
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton2<Options>(
                isDense: false,
                isExpanded: true,
                hint: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 50,
                    width: context.width,
                    decoration: BoxDecoration(
                        color: white, borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextView(
                          text: filter.placeholder ?? "",
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                        const Icon(Icons.arrow_drop_down,
                            color: Colors
                                .black), // Ensure 'black' is defined or use 'Colors.black'
                      ],
                    )),
                items: filter.options?.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    //disable default onTap to avoid closing menu when selecting an item
                    enabled: true,
                    child: StatefulBuilder(
                      builder: (context, menuSetState) {
                        final isSelected = filter.value.contains(item.id);
                        return InkWell(
                          onTap: () {
                            isSelected
                                ? filter.value.remove(item.id)
                                : filter.value.add(item.id ?? '');
                            //This rebuilds the StatefulWidget to update the button's text
                            setState(() {});
                            //This rebuilds the dropdownMenu Widget to update the check mark
                            menuSetState(() {});
                          },
                          child: Container(
                            height: double.infinity,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                    isSelected
                                        ? ImageConstant.icCheckboxOn
                                        : ImageConstant.icCheckboxOff,
                                    width: 21,
                                    height: 21,
                                    colorFilter: ColorFilter.mode(
                                        isSelected
                                            ? colorPrimary
                                            : defaultCheckboxColor,
                                        BlendMode.srcIn)),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CustomTextView(
                                    text: item.name.toString(),
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    onTap: () {},
                  );
                }).toList(),
                onChanged: (Options? option) {},
                //This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    //textEditingController.clear();
                  }
                },
                buttonStyleData: const ButtonStyleData(
                  height: 50,
                  width: double.infinity,
                ),
                iconStyleData: const IconStyleData(
                  icon: SizedBox.shrink(), // Hide the icon
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 220,
                  width: context.width - 40 - 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: white,
                  ),
                  offset: const Offset(0, 0),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.zero,
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  ///used for sort filter
  Widget _buildSortWidget(Filters? filter) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(20),
      decoration: AppDecoration.grayFilterCardDialog.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppDecoration.commonLabelTextWidget(filter?.label.toString() ?? ""),
          SizedBox(
            height: 20.v,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () {
                    filter?.value = filter.options?[0].id.toString();
                    controller.exhibitorFilterData.refresh();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      filter?.value == filter?.options?[0].id.toString()
                          ? Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                ImageConstant.icRadioActive,
                                height: 22.adaptSize,
                                colorFilter: ColorFilter.mode(
                                    colorPrimary, BlendMode.srcIn),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                  ImageConstant.icRadioInactive,
                                  height: 22.adaptSize),
                            ),
                      CustomTextView(
                        text: filter?.options?[0].name ?? "",
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w500,
                        color: colorSecondary,
                      ),
                    ],
                  )),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  filter?.value = filter.options?[1].id.toString();
                  controller.exhibitorFilterData.refresh();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    filter?.value == filter?.options?[1].id.toString()
                        ? Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: SvgPicture.asset(
                              ImageConstant.icRadioActive,
                              height: 22.adaptSize,
                              colorFilter: ColorFilter.mode(
                                  colorPrimary, BlendMode.srcIn),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: SvgPicture.asset(
                                ImageConstant.icRadioInactive,
                                height: 22.adaptSize),
                          ),
                    CustomTextView(
                      text: filter?.options?[1].name ?? "",
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.w500,
                      color: colorSecondary,
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar() {
    return CustomAppBar(
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
      title: ToolbarTitle(title: "filter".tr),
      backgroundColor: colorLightGray,
      dividerHeight: 0,
    );
  }

  /// Section Widget
  Widget _buildFilterOptionsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        CustomTextView(
          text: "choose_filters".tr,
          fontWeight: FontWeight.w600,
          fontSize: 22,
        ),
        GestureDetector(
          onTap: () async {
            controller
                .tempExhibitorFilterData(controller.exhibitorFilterData.value);
            controller.getAndResetFilter(isRefresh: true, isFromReset: true);
            controller.isReset(true);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(18)),
                border: Border.all(color: borderColor, width: 1)),
            child: Row(
              children: [
                CustomTextView(
                  text: "reset".tr,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                const SizedBox(
                  width: 7,
                ),
                CustomImageView(
                  imagePath: ImageConstant.reset_icon,
                  width: 13.h,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  ///show selected filter item via flow layout widget
  Widget _buildSelectedOption(Filters filters) {
    return filters.value != null && filters.value is List
        ? Wrap(
            spacing: 10,
            children: <Widget>[
              for (var item in filters.value)
                FlowWidgetWithClose(
                  text: item ?? "",
                  isBgColor: true,
                  onTap: (selectedItem) {
                    filters.value.remove(selectedItem);
                    controller.exhibitorFilterData.refresh();
                  },
                ),
            ],
          )
        : const SizedBox();
  }
}
