import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/startNetworking/controller/angelHallController.dart';
import 'package:dreamcast/view/startNetworking/model/startNetworkingSlot.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../utils/image_constant.dart';
import '../../../../utils/pref_utils.dart';
import '../../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../../widgets/app_bar/custom_app_bar.dart';
import '../../../../widgets/customImageWidget.dart';
import '../../../../widgets/button/custom_icon_button.dart';
import '../../../../widgets/toolbarTitle.dart';
import '../../controller/invenstorController.dart';

class InvestorSlotDialog extends GetView<InvestorController> {
  String personName, profileImg, shortName, duration;
  InvestorSlotDialog(
      {super.key,
      required this.personName,
      required this.profileImg,
      required this.shortName,
      required this.duration});
  static const routeName = "/BookAppointmentPage";

  final textFieldController = TextEditingController(text: "select_date".tr);
  final notesFieldController = TextEditingController(text: "");

  final AuthenticationManager _authController = Get.find();
  final _selectedDate = 0.obs;
  final _selectedSlot = 0.obs;
  var showPopup = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorLightGray,
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
        title: ToolbarTitle(title: "book_slot".tr),
        backgroundColor: colorLightGray,
        dividerHeight: 0,
      ),
      body: Container(
        height: context.height,
        width: context.width,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: white,
          boxShadow: [
            BoxShadow(
              color: colorGray,
              blurRadius: 10.0,
              offset: const Offset(0, 6),
            ),
          ],
          // borderRadius: BorderRadius.all(Radius.circular(19)),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        child: GetX<InvestorController>(
          builder: (controller) {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      CustomTextView(
                        text: "want_to_book_meeting".tr,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      buildDateView(context),
                      const Divider(
                        height: 24,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      CustomTextView(
                        text: "select_time_for_day".tr,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      controller.timeslotsList.isNotEmpty
                          ? buildSlotsListView(context)
                          : Center(
                              child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CustomTextView(
                                text:
                                    "There is no slot available at this time.",
                                textAlign: TextAlign.center,
                              ),
                            )),
                      const SizedBox(
                        height: 24,
                      ),
                      controller.timeslotsList.isNotEmpty
                          ? CustomIconButton(
                              height: 55,
                              width: context.width,
                              decoration: BoxDecoration(
                                color: controller.meetingDisable.value
                                    ? colorPrimary.withOpacity(0.5)
                                    : colorPrimary, // Background color
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                /*border:
                                    Border.all(color: colorAccent, width: 1),*/
                              ),
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                if (controller.meetingDisable.value) {
                                  return;
                                }
                                var body = {
                                  "date_time": controller
                                      .slots[_selectedSlot.value].dateTime,
                                  "duration": controller
                                      .timeslotsList[_selectedDate.value]
                                      .duration!,
                                  "message":
                                      notesFieldController.text.toString() ?? ""
                                };
                                Get.back(result: body);
                              },
                              child: const Center(
                                child: CustomTextView(
                                  text: "Confirm",
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                  showPopup.value
                      ? Positioned(
                          top: context.height * 0.12,
                          right: 0,
                          left: 0,
                          child: buildDatePopup(
                            context,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildDateView(BuildContext context) {
    if (controller.timeslotsList.isNotEmpty) {
      controller.slots.clear();
      controller.slots.addAll(UiHelper.createTimeslotMeeting(
          startDate:
              controller.timeslotsList[_selectedDate.value].startDatetime,
          endDate: controller.timeslotsList[_selectedDate.value].endDatetime,
          duration: controller.timeslotsList[_selectedDate.value].duration,
          gap: controller.timeslotsList[_selectedDate.value].gap,
          timezone: PrefUtils.getTimezone()));

      textFieldController.text = UiHelper.getSlotsDate(
          date:
              controller.timeslotsList[_selectedDate.value].startDatetime ?? "",
          timezone: PrefUtils.getTimezone());
    }
    return GestureDetector(
      onTap: () {
        if (controller.timeslotsList.isEmpty) {
          return;
        }
        showPopup(!showPopup.value);
      },
      child: TextFormField(
        textInputAction: TextInputAction.done,
        controller: textFieldController,
        maxLength: 100,
        keyboardType: TextInputType.text,
        validator: (String? value) {},
        onChanged: (value) {},
        decoration: InputDecoration(
            counter: const Offstage(),
            contentPadding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            labelText: "select_date".tr,
            enabled: false,
            hintText: "select_date".tr,
            labelStyle: TextStyle(color: colorSecondary, fontSize: 13),
            filled: true,
            suffixIcon: Icon(
              Icons.arrow_drop_down,
              color: colorSecondary,
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 60),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: borderColor))),
      ),
    );
  }

  Widget buildDatePopup(BuildContext? context) {
    return SizedBox(
      width: context?.width,
      child: Card(
        color: white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: borderColor, width: 1)),
        elevation: 6,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          scrollDirection: Axis.vertical,
          itemCount: controller.timeslotsList.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            MeetingSlots meetingsSlot = controller.timeslotsList[index];
            return InkWell(
              onTap: () {
                controller.slots.clear();
                controller.slots.addAll(UiHelper.createTimeslotMeeting(
                    startDate: meetingsSlot.startDatetime,
                    endDate: meetingsSlot.endDatetime,
                    duration: meetingsSlot.duration,
                    gap: meetingsSlot.gap,
                    timezone: PrefUtils.getTimezone()));
                _selectedDate.value = index;
                textFieldController.text = UiHelper.getSlotsDate(
                    date: meetingsSlot.startDatetime ?? "",
                    timezone: PrefUtils.getTimezone());
                showPopup(false);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                child: CustomTextView(
                  text: UiHelper.getSlotsDate(
                      date: meetingsSlot.startDatetime ?? "",
                      timezone: PrefUtils.getTimezone()),
                  maxLines: 2,
                  softWrap: true,
                  textAlign: TextAlign.start,
                  fontSize: 16,
                  color: index == _selectedDate.value
                      ? colorPrimary
                      : colorSecondary,
                  fontWeight: index == _selectedDate.value
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildSlotsListView(BuildContext context) {
    return SizedBox(
      height: 300.v,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: controller.slots.length,
        itemBuilder: (context, index) {
          var slotData = controller.slots[index];
          return GestureDetector(
            onTap: () {
              if (controller.meetingDisable.value ||
                  controller.bookingAppointmentList.contains(
                      slotData.dateTime?.replaceAll("00+00:00", "00Z"))) {
                return;
              }
              _selectedSlot.value = index;
            },
            child: Obx(
              () => Container(
                decoration: BoxDecoration(
                    color: controller.meetingDisable.value ||
                            controller.bookingAppointmentList.contains(slotData
                                .dateTime
                                ?.replaceAll("00+00:00", "00Z"))
                        ? colorGray.withOpacity(0.5)
                        : white,
                    shape: BoxShape.rectangle,
                    border: Border.all(
                        width: 1,
                        color: index == _selectedSlot.value
                            ? colorPrimary
                            : borderColor),
                    borderRadius: const BorderRadius.all(Radius.circular(6))),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextView(
                        color: index == _selectedSlot.value
                            ? colorPrimary
                            : colorSecondary,
                        text: controller.slots[index].time ?? "",
                        fontSize: 16,
                        fontWeight: index == _selectedSlot.value
                            ? FontWeight.bold
                            : FontWeight.normal,
                        textAlign: TextAlign.center,
                      ),
                      controller.meetingDisable.value ||
                              controller.bookingAppointmentList.contains(
                                  slotData.dateTime
                                      ?.replaceAll("00+00:00", "00Z"))
                          ? CustomTextView(
                              text: "not_available".tr,
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              textAlign: TextAlign.center,
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.5 / 1,
            mainAxisSpacing: 12,
            crossAxisSpacing: 20),
      ),
    );
  }
}

class AngelSlotDialog extends GetView<AngelHallController> {
  String personName, profileImg, shortName, duration;
  AngelSlotDialog(
      {super.key,
      required this.personName,
      required this.profileImg,
      required this.shortName,
      required this.duration});
  static const routeName = "/BookAppointmentPage";

  final textFieldController = TextEditingController(text: "Choose Date");
  final notesFieldController = TextEditingController(text: "");

  final AuthenticationManager _authController = Get.find();
  final _selectedDate = 0.obs;
  final _selectedSlot = 0.obs;
  var showPopup = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorLightGray,
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
        title: ToolbarTitle(title: "book_slot".tr),
        backgroundColor: colorLightGray,
        dividerHeight: 0,
      ),
      body: Container(
        height: context.height,
        width: context.width,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: white,
          boxShadow: [
            BoxShadow(
              color: colorGray,
              blurRadius: 10.0,
              offset: Offset(0, 6),
            ),
          ],
          // borderRadius: BorderRadius.all(Radius.circular(19)),
          borderRadius: BorderRadius.vertical(top: Radius.circular(19)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        child: GetX<AngelHallController>(
          builder: (controller) {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      CustomTextView(
                        text: "want_to_book_meeting".tr,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      buildDateView(context),
                      const Divider(
                        height: 24,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      CustomTextView(
                        text: "select_time_for_day".tr,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      controller.timeslotsList.isNotEmpty
                          ? buildSlotsListView(context)
                          : Center(
                              child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomTextView(
                                text: "no_clot_available_this_time".tr,
                                textAlign: TextAlign.center,
                              ),
                            )),
                      const SizedBox(
                        height: 24,
                      ),
                      controller.timeslotsList.isNotEmpty
                          ? CustomIconButton(
                              height: 55,
                              width: context.width,
                              decoration: BoxDecoration(
                                color: colorPrimary, // Background color
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border:
                                    Border.all(color: colorPrimary, width: 1),
                              ),
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                var body = {
                                  "date_time": controller
                                      .slots[_selectedSlot.value].dateTime,
                                  "duration": controller
                                      .timeslotsList[_selectedDate.value]
                                      .duration!,
                                  "message":
                                      notesFieldController.text.toString() ?? ""
                                };
                                Get.back(result: body);
                              },
                              child: Center(
                                child: CustomTextView(
                                  text: "show_interest".tr,
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                  showPopup.value
                      ? Positioned(
                          top: context.height * 0.12,
                          right: 0,
                          left: 0,
                          child: buildDatePopup(
                            context,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildDateView(BuildContext context) {
    if (controller.timeslotsList.isNotEmpty) {
      controller.slots.clear();
      controller.slots.addAll(UiHelper.createTimeslotMeeting(
          startDate:
              controller.timeslotsList[_selectedDate.value].startDatetime,
          endDate: controller.timeslotsList[_selectedDate.value].endDatetime,
          duration: controller.timeslotsList[_selectedDate.value].duration,
          gap: controller.timeslotsList[_selectedDate.value].gap,
          timezone: PrefUtils.getTimezone()));

      textFieldController.text = UiHelper.getSlotsDate(
          date:
              controller.timeslotsList[_selectedDate.value].startDatetime ?? "",
          timezone: PrefUtils.getTimezone());
    }
    return GestureDetector(
      onTap: () {
        if (controller.timeslotsList.isEmpty) {
          return;
        }
        showPopup(!showPopup.value);
      },
      child: TextFormField(
        textInputAction: TextInputAction.done,
        controller: textFieldController,
        maxLength: 100,
        keyboardType: TextInputType.text,
        validator: (String? value) {},
        onChanged: (value) {},
        decoration: InputDecoration(
          counter: const Offstage(),
          contentPadding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          labelText: "Select Date",
          enabled: false,
          hintText: "Select Date",
          labelStyle: TextStyle(color: colorSecondary, fontSize: 13),
          // hintStyle: const TextStyle(color: textGrayColor, fontSize: 13),
          filled: true,
          suffixIcon: Icon(
            Icons.arrow_drop_down,
            color: colorSecondary,
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 60),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: borderColor),
          ),
        ),
      ),
    );
  }

  Widget buildDatePopup(BuildContext? context) {
    return SizedBox(
      width: context?.width,
      child: Card(
        color: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: borderColor, width: 1),
        ),
        elevation: 6,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          scrollDirection: Axis.vertical,
          itemCount: controller.timeslotsList.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            MeetingSlots meetingsSlot = controller.timeslotsList[index];
            return InkWell(
              onTap: () {
                controller.slots.clear();
                controller.slots.addAll(UiHelper.createTimeslotMeeting(
                    startDate: meetingsSlot.startDatetime,
                    endDate: meetingsSlot.endDatetime,
                    duration: meetingsSlot.duration,
                    gap: meetingsSlot.gap,
                    timezone: PrefUtils.getTimezone()));
                _selectedDate.value = index;
                textFieldController.text = UiHelper.getSlotsDate(
                    date: meetingsSlot.startDatetime ?? "",
                    timezone: PrefUtils.getTimezone());
                showPopup(false);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                child: CustomTextView(
                  text: UiHelper.getSlotsDate(
                      date: meetingsSlot.startDatetime ?? "",
                      timezone: PrefUtils.getTimezone()),
                  maxLines: 2,
                  softWrap: true,
                  textAlign: TextAlign.start,
                  fontSize: 16,
                  color: index == _selectedDate.value
                      ? colorPrimary
                      : colorSecondary,
                  fontWeight: index == _selectedDate.value
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildSlotsListView(BuildContext context) {
    return SizedBox(
      height: 300.v,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: controller.slots.length,
        itemBuilder: (context, index) {
          var slotData = controller.slots[index];
          return GestureDetector(
            onTap: () {
              if (controller.bookingAppointmentList
                  .contains(slotData.dateTime?.replaceAll("00+00:00", "00Z"))) {
                UiHelper.showSuccessMsg(context, "Slot has been booked");
                return;
              }

              _selectedSlot.value = index;
            },
            child: Obx(
              () => Container(
                decoration: BoxDecoration(
                  color: controller.bookingAppointmentList.contains(
                          slotData.dateTime?.replaceAll("00+00:00", "00Z"))
                      ? colorLightGray
                      : white,
                  shape: BoxShape.rectangle,
                  border: Border.all(
                      width: 1,
                      color: index == _selectedSlot.value
                          ? colorPrimary
                          : borderColor),
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextView(
                        color: index == _selectedSlot.value
                            ? colorPrimary
                            : colorSecondary,
                        text: controller.slots[index].time ?? "",
                        fontSize: 16,
                        fontWeight: index == _selectedSlot.value
                            ? FontWeight.bold
                            : FontWeight.normal,
                        textAlign: TextAlign.center,
                      ),
                      controller.bookingAppointmentList.contains(
                              slotData.dateTime?.replaceAll("00+00:00", "00Z"))
                          ? CustomTextView(
                              text: "Not Available",
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              textAlign: TextAlign.center,
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.5 / 1,
            mainAxisSpacing: 12,
            crossAxisSpacing: 20),
      ),
    );
  }

  Widget buildNotesWidget() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorLightGray,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.zero,
            child: CustomTextView(
              text: "Write A Message",
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: EdgeInsets.zero,
            child: TextFormField(
              textInputAction: TextInputAction.newline,
              controller: notesFieldController,
              maxLength: 100,
              maxLines: 6,
              minLines: 1,
              focusNode: FocusNode(),
              keyboardType: TextInputType.multiline,
              validator: (String? value) {},
              onChanged: (value) {},
              decoration: InputDecoration(
                counter: const Offstage(),
                contentPadding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
                labelText: "Notes",
                hintText: "Type here",
                hintStyle: TextStyle(
                    color: colorGray,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
                labelStyle: TextStyle(color: colorGray, fontSize: 14),
                filled: true,
                prefixIconConstraints: const BoxConstraints(minWidth: 60),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colorSecondary),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildUserInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // First Row for profile and name
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min, // Adjust width to fit content
              children: [
                CustomImageWidget(
                    size: 41, imageUrl: profileImg, shortName: shortName),
                const SizedBox(width: 7),
                CustomTextView(
                  text: personName ?? "",
                  color: colorSecondary,
                  maxLines: 2,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          // Divider
          Container(
            height: 46,
            width: 1,
            color: borderColor,
          ),
          // Space between divider and the next row
          const SizedBox(width: 16), // Adjust this value as needed
          // Second Row for duration info
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min, // Adjust width to fit content
              children: [
                SvgPicture.asset("assets/svg/calendar_icon.svg", width: 18),
                const SizedBox(width: 10),
                CustomTextView(
                  text: "$duration Mins Meeting",
                  color: colorSecondary,
                  maxLines: 3,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
