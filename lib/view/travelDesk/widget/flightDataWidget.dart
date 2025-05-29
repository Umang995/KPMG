import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/travelDesk/controller/flightController.dart';
import 'package:dreamcast/view/travelDesk/controller/travelDeskController.dart';
import 'package:dreamcast/view/travelDesk/model/travelFlightGetModel.dart';
import 'package:dreamcast/view/travelDesk/widget/commonImageOrPdfWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../widgets/textview/customTextView.dart';
import '../view/travelSaveFormPage.dart';

class FlightDataWidget extends GetView<FlightController> {
  final String title;
  final Arrival data;
  final String? slug;

  FlightDataWidget(
      {super.key, required this.title, required this.data, this.slug});

  TravelDeskController travelDeskController = Get.find();
  AuthenticationManager authenticationManager = Get.find();

  @override
  Widget build(BuildContext context) {
    showAirport(data);
    return Container(
      decoration: BoxDecoration(
        color: colorLightGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 16, bottom: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextView(
                    text: title ?? "",
                    fontSize: 18,
                    maxLines: 10,
                    color: colorPrimary,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed(TravelSaveFormPage.routeName, arguments: {
                    "type": slug,
                  });
                },
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 25, top: 16, bottom: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 14),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: borderColor),
                      ),
                      child: SvgPicture.asset(
                        ImageConstant.editIcon,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          UiHelper.commonDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                data.flightFrom != null &&
                        data.flightFrom!.isNotEmpty &&
                        data.flightFrom is Object
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 CustomTextView(
                                  text: "From" ?? "",
                                  fontSize: 16,
                                  maxLines: 10,
                                  color: colorGray,
                                  textAlign: TextAlign.start,
                                  fontWeight: FontWeight.w500,
                                ),
                                CustomTextView(
                                  text: data.flightFrom?[0] ?? "",
                                  fontSize: 22,
                                  maxLines: 10,
                                  color: colorSecondary,
                                  textAlign: TextAlign.start,
                                  fontWeight: FontWeight.w600,
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 300),
                                  child: CustomTextView(
                                    // text: showAirport(data),
                                    text: data.flightFrom != null &&
                                            data.flightFrom!.length > 2
                                        ? "${data.flightFrom?[1] ?? ""} (${data.flightFrom?[2] ?? ""})"
                                        : "",
                                    fontSize: 14,
                                    maxLines: 10,
                                    color: colorSecondary,
                                    textAlign: TextAlign.start,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 300),
                                  child: CustomTextView(
                                    text: data.terminalFrom ?? "",
                                    fontSize: 16,
                                    maxLines: 10,
                                    color: colorSecondary,
                                    textAlign: TextAlign.start,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: UiHelper.commonDivider(),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 CustomTextView(
                                  text: "To" ?? "",
                                  fontSize: 16,
                                  maxLines: 10,
                                  color: colorGray,
                                  textAlign: TextAlign.start,
                                  fontWeight: FontWeight.w500,
                                ),
                                CustomTextView(
                                  text: data.flightTo?[0] ?? "",
                                  fontSize: 22,
                                  maxLines: 10,
                                  color: colorSecondary,
                                  textAlign: TextAlign.start,
                                  fontWeight: FontWeight.w600,
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 300),
                                  child: CustomTextView(
                                    text: data.flightTo != null &&
                                            data.flightTo!.length > 2
                                        ? "${data.flightTo?[1] ?? ""} (${data.flightTo?[2] ?? ""})"
                                        : "",
                                    fontSize: 14,
                                    maxLines: 10,
                                    color: colorSecondary,
                                    textAlign: TextAlign.start,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 300),
                                  child: CustomTextView(
                                    text: data.terminalTo ?? "",
                                    fontSize: 16,
                                    maxLines: 10,
                                    color: colorSecondary,
                                    textAlign: TextAlign.start,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                UiHelper.commonDivider(),
                data.flightDateTime != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 CustomTextView(
                                  text: "Date of Travel" ?? "",
                                  fontSize: 14,
                                  maxLines: 10,
                                  color: colorGray,
                                  textAlign: TextAlign.start,
                                  fontWeight: FontWeight.w500,
                                ),
                                CustomTextView(
                                  text: formatDateTime(
                                      data.flightDateTime.toString()),
                                  fontSize: 18,
                                  maxLines: 10,
                                  color: colorSecondary,
                                  textAlign: TextAlign.start,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                UiHelper.commonDivider(),
                data.pnrNumber != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               CustomTextView(
                                text: "PNR Number" ?? "",
                                fontSize: 14,
                                maxLines: 10,
                                color: colorGray,
                                textAlign: TextAlign.start,
                                fontWeight: FontWeight.w500,
                              ),
                              CustomTextView(
                                text: data.pnrNumber ?? "",
                                fontSize: 18,
                                maxLines: 10,
                                color: colorSecondary,
                                textAlign: TextAlign.start,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                               CustomTextView(
                                text: "Airline" ?? "",
                                fontSize: 14,
                                maxLines: 10,
                                color: colorGray,
                                textAlign: TextAlign.start,
                                fontWeight: FontWeight.w500,
                              ),
                              CustomTextView(
                                text: data.flightName ?? "",
                                fontSize: 18,
                                maxLines: 1,
                                color: colorSecondary,
                                textAlign: TextAlign.start,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox(),
                SizedBox(
                  height: 20.v,
                ),
                if (data.ticketPdf != null && data.ticketPdf != "")
                  CommonImageOrPdfWidget(
                    fileUrl: data.ticketPdf ?? "",
                    title: "${title.replaceAll("Details", "")} Air Ticket",
                  ),
                if (data.ticketPdf != null && data.ticketPdf != "")
                  const SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void showAirport(Arrival data) {
    processFlightDetails(data.flightFrom);
    processFlightDetails(data.flightTo);
  }

  void processFlightDetails(List<String>? flightDetails) {
    if (flightDetails == null || flightDetails.isEmpty) return;

    String flightDetailsString = flightDetails.length > 2
        ? "${flightDetails[0]} / ${flightDetails[1]} / ${flightDetails[2]}"
        : flightDetails[0];

    List<String> parts = flightDetailsString.split(" / ");
    String city = parts.first.isNotEmpty ? parts.first : parts[1];
    String cityCode = parts.last;
    String airportName =
        parts.length > 2 ? parts.sublist(1, parts.length - 1).join(" ") : "";
    print("City: $city");
    print("Airport Name: $airportName");
    print("City Code: $cityCode");
    flightDetails
        .replaceRange(0, flightDetails.length, [city, airportName, cityCode]);
  }


  String formatDateTime(String input) {
    if (input.isEmpty || input == "null") {
      return "";
    }
    try {
      DateTime dateTime;
      String formattedTime = "";
      if (input.contains("|")) {
        // Split and parse when input is in "yyyy-MM-dd | hh:mm a" format
        List<String> parts = input.split('|');
        dateTime = DateFormat("yyyy-MM-dd").parse(parts[0].trim());
        formattedTime = parts.length > 1 ? parts[1].trim() : "";
      } else {
        dateTime = DateTime.parse(input);
        formattedTime = DateFormat('h:mm a').format(dateTime);
      }

      String dayWithSuffix = UiHelper.getDaySuffix(dateTime.day);
      String month = DateFormat('MMM').format(dateTime);
      String year = DateFormat('yyyy').format(dateTime);

      return "${dateTime.day}$dayWithSuffix $month, $year | $formattedTime";
    } catch (e) {
      return "";
    }
  }


}
