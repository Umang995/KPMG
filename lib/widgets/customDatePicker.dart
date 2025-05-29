import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/view/meeting/controller/meetingController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';

class CustomDatePicker extends GetView<MeetingController> {
  String title;
  final Function(dynamic) chooseDate;
  final Function chooseFilter;
  CustomDatePicker(
      {Key? key,
      required this.title,
      required this.chooseDate,
      required this.chooseFilter})
      : super(key: key);

// Initial Selected Value

  @override
  Widget build(BuildContext context) {
    return GetX<MeetingController>(builder: (controller) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 8,
            child: InkWell(
              onTap: () {
                Future.delayed(Duration.zero, () async {
                  chooseDate("");
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    border: Border.all(color: borderColor, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextView(
                      text: controller.selectedOption.value.name!.isEmpty
                          ? "select_date".tr
                          : controller.selectedOption.value.name ?? "",
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                Future.delayed(Duration.zero, () async {
                  chooseFilter();
                });
              },
              child: Image.asset(
                "assets/icons/filter_icon.png",
                width: 25,
                height: 25,
                color: Colors.black,
              ),
            ),
          ),
        ],
      );
    });
  }
}
