import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/app_decoration.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:dreamcast/view/schedule/controller/session_controller.dart';
import 'package:dreamcast/view/schedule/model/session_filter_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import 'package:get/get.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/flow_widget.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/button/common_material_button.dart';
import '../request_model/session_request_model.dart';

class SessionFilterDialogPage extends StatefulWidget {
  const SessionFilterDialogPage({Key? key}) : super(key: key);

  @override
  State<SessionFilterDialogPage> createState() =>
      _SessionFilterDialogPageState();
}

class _SessionFilterDialogPageState extends State<SessionFilterDialogPage> {
  SessionController sessionController = Get.find();
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    sessionController.isReset(false);
  }

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
          child: GetX<SessionController>(builder: (controller) {
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFilterOptionsRow(),
                            //_buildSortWidget(controller.userFilterBody.value.sort),
                            // const SizedBox(height: 6,),
                            _buildFilterParentData(),
                          ],
                        ),
                      ),
                    ),
                    CommonMaterialButton(
                      color: colorPrimary,
                      onPressed: () async {
                        if (controller.isReset.value) {
                          controller.isFilterApply(false);
                          controller.tempSessionFilterBody(
                              controller.sessionFilterBody.value);
                        }
                        _sendDataToServer();
                      },
                      text: "Apply Filters".tr,
                    ),
                  ],
                ),
                controller.isFirstLoading.value
                    ? const Loading()
                    : const SizedBox()
              ],
            );
          })),
    );
  }

  _sendDataToServer() async {
    sessionController.isFilterApply(false);
    var filterApplyStatus = false;
    var parentMap = <String, dynamic>{};
    for (Params data
        in sessionController.sessionFilterBody.value.params ?? []) {
      if (data.value != null && data.value.toString().isNotEmpty) {
        if (data.value is List) {
          data.options?.forEach((option) {
            option.apply = data.value.toString().contains(option.value ?? "");
          });
        }
        if (data.name != "date") {
          parentMap[data.name ?? ""] = data.value;
        }

        ///check the filter is apply or not
        if (data.value.isNotEmpty && data.name != "date") {
          filterApplyStatus = true;
        }
      } else {
        data.apply = false;
      }
    }
    sessionController.sessionRequestModel.filters?.sort =
        sessionController.selectedFilterSort.value;
    sessionController.sessionRequestModel.filters?.params?.additionalParams =
        parentMap;
    sessionController.sessionRequestModel.filters?.params?.date =
        sessionController.defaultDate;

    ///check the filter is apply or not
    if (filterApplyStatus == true) {
      sessionController.isFilterApply(true);
    }
    Get.back(result: false);
  }

  ///used for sort filter
  Widget _buildSortWidget(Params? sort) {
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
            CustomTextView(text: sort?.label.toString() ?? ""),
            // SizedBox(height: 20.v,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    sessionController.selectedFilterSort(sessionController
                        .sessionFilterBody.value.sort?.options?[0].value
                        .toString());
                    // setState(() {});
                  },
                  child: Obx(() => Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          sessionController.selectedFilterSort ==
                                  sessionController.sessionFilterBody.value.sort
                                      ?.options?[0].value
                                      .toString()
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: SvgPicture.asset(
                                    ImageConstant.icRadioActive,
                                    height: 22.adaptSize,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: SvgPicture.asset(
                                      ImageConstant.icRadioInactive,
                                      height: 22.adaptSize),
                                ),
                          CustomTextView(
                            text: sessionController.sessionFilterBody.value.sort
                                    ?.options?[0].text ??
                                "",
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ],
                      )),
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    sessionController.selectedFilterSort(sessionController
                        .sessionFilterBody.value.sort?.options?[1].value
                        .toString());
                    //setState(() {});
                  },
                  child: Obx(
                    () => Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        sessionController.selectedFilterSort.value ==
                                sessionController.sessionFilterBody.value.sort
                                    ?.options?[1].value
                                    .toString()
                            ? Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SvgPicture.asset(
                                  ImageConstant.icRadioActive,
                                  height: 22.adaptSize,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SvgPicture.asset(
                                    ImageConstant.icRadioInactive,
                                    height: 22.adaptSize),
                              ),
                        CustomTextView(
                          text: sessionController.sessionFilterBody.value.sort
                                  ?.options?[1].text ??
                              "",
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );
    });
  }

  ///initial column widget
  _buildFilterParentData() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: sessionController.sessionFilterBody.value.params?.length,
      itemBuilder: (context, index) {
        var filter = sessionController.sessionFilterBody.value.params?[index];
        return filter?.type == "select" || filter?.type == "radio"
            ? filter?.name == "date" || filter?.name == "pitch_stage"
                ? const SizedBox()
                : _buildSingleSelection(filter)
            : _buildMultipleSelection(filter);
      },
    );
  }

  ///used for radio Widget
  Widget _buildSingleSelection(Params? filter) {
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
                    // Row to align text and icon
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextView(
                        text: getTextById(filter).toString().isNotEmpty
                            ? getTextById(filter).toString()
                            : "Select",
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                      const Icon(Icons.arrow_drop_down,
                          color: Colors.black), // Icon aligned with text
                    ],
                  ),
                ),
                items: filter?.options
                    ?.map((Options option) => DropdownMenuItem<Options>(
                          value: option,
                          child: ListTile(
                            leading: SvgPicture.asset(
                              colorFilter: ColorFilter.mode(
                                  filter.value.toString() == option.value
                                      ? colorPrimary
                                      : colorGray,
                                  BlendMode.srcIn),
                              ImageConstant.icRadioActive,
                              width: 22,
                            ),
                            title: CustomTextView(
                              text: option.text ?? "",
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
                  if (filter?.value.toString() == option?.value) {
                    filter?.value = "";
                  } else {
                    filter?.value = option?.value;
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

  String getTextById(Params? filter) {
    var value = "";
    for (var data in filter?.options ?? []) {
      if (data.value == filter?.value) {
        value = data.text ?? "";
      }
    }
    return value;
  }

  ///get the checkbox value from
  String getCheckboxValue(Params? filter, String id) {
    var value = "";
    for (var data in filter?.options ?? []) {
      if (data.value == id) {
        value = data.text ?? "";
      }
    }
    return value;
  }

  ///used for checkbox Widget
  Widget _buildMultipleSelection(Params? filter) {
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
            _buildSelectedOption(filter ?? Params()),
            const SizedBox(height: 12),
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
                          text: "choose_item".tr,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                        const Icon(Icons.arrow_drop_down,
                            color: Colors
                                .black), // Ensure 'black' is defined or use 'Colors.black'
                      ],
                    )),
                items: filter?.options?.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    //disable default onTap to avoid closing menu when selecting an item
                    enabled: true,
                    child: StatefulBuilder(
                      builder: (context, menuSetState) {
                        final isSelected = filter.value.contains(item.value);
                        return InkWell(
                          onTap: () {
                            isSelected
                                ? filter.value.remove(item.value)
                                : filter.value.add(item.value ?? '');
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
                                    text: item.text.toString(),
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      print("cloc");
                    },
                  );
                }).toList(),
                onChanged: (Options? option) {},
                //This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    textEditingController.clear();
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

  /// Section Widget
  Widget _buildFilterOptionsRow() {
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
            sessionController.tempSessionFilterBody(
                sessionController.sessionFilterBody.value);
            sessionController.getAndResetFilter(
                isRefresh: true, isFromReset: true);
            sessionController.isReset(true);
            setState(() {});
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
                    imagePath: ImageConstant.reset_icon, width: 13.h),
              ],
            ),
          ),
        )
      ],
    );
  }

  ///show selected filter item via flow layout widget
  Widget _buildSelectedOption(Params filters) {
    return filters.value != null && filters.value is List
        ? Wrap(
            spacing: 10,
            children: <Widget>[
              for (var item in filters.value)
                FlowWidgetWithObjectClose(
                  text: getCheckboxValue(filters, item ?? "").toString(),
                  id: item,
                  onTap: (selectedItem) {
                    filters.value.remove(selectedItem);
                    sessionController.sessionFilterBody.refresh();
                  },
                ),
            ],
          )
        : const SizedBox();
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
}
