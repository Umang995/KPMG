import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class EventTimerConstant {
  static String getRemainingMonthNew(
      {required String eventDate,
      required String eventEndDate,
      required String timezone}) {
    String monthDateLabel = "00 Day";
    if (eventDate != null && eventDate.isNotEmpty) {
      tz.initializeTimeZones();

      final pacificTimeZone = tz.getLocation(timezone /*?? "Asia/Kolkata"*/);

      DateTime startDate =
          DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(eventDate, true).toLocal();

      var inputDate = tz.TZDateTime.from(startDate, pacificTimeZone);

      DateTime endDate = DateTime.now();

      // Calculate the difference between two dates
      Duration duration = inputDate.difference(endDate);

      if (duration.isNegative) {
        return "00 Day";
      }
      int hours = duration.inHours % 24;
      int minutes = duration.inMinutes % 60;
      int seconds = duration.inSeconds % 60;

      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitDay = twoDigits(duration.inDays.remainder(365).abs());
      String twoDigitHour = twoDigits(hours);
      String twoDigitMinutes = twoDigits(minutes);
      String twoDigitSeconds = twoDigits(seconds);

      if (duration.inDays >= 2) {
        if (duration.inHours > 1) {
          return monthDateLabel = "${duration.inDays + 1} ${"Days"}";
        } else if (duration.inMinutes > 1) {
          return monthDateLabel = "${duration.inDays + 1} ${"Days"}";
        } else {
          return monthDateLabel = "${duration.inDays} ${"Days"}";
        }
      } else if (duration.inDays >= 1) {
        return monthDateLabel =
            "${duration.inHours} : $twoDigitMinutes : $twoDigitSeconds";
      } else if (duration.inDays == 0) {
        if (duration.inHours >= 1) {
          return monthDateLabel =
              "${duration.inHours} : $twoDigitMinutes : $twoDigitSeconds";
        } else if (duration.inHours == 0) {
          return monthDateLabel = "$twoDigitMinutes : $twoDigitSeconds";
        } else if (duration.inMinutes > 0) {
          return monthDateLabel = "$twoDigitMinutes : $twoDigitSeconds";
        } else if (duration.inMinutes == 0) {
          return monthDateLabel = "${00} : $twoDigitSeconds";
        } else if (duration.inSeconds == 0) {
          return monthDateLabel = "00 Day";
        } else {
          return monthDateLabel = "00 Day";
        }
      } else {
        return monthDateLabel = "00 Day";
      }
    } else {
      return monthDateLabel = "00 Day";
    }
  }

  static int? isCurrentDateInRangeOrCrossed({
    required String currentDateTime,
    required String startDateTime,
    required String endDateTime,
  }) {
    try {
      // Parse the ISO 8601 formatted strings into DateTime objects
      DateTime start = DateTime.parse(startDateTime);
      DateTime current = DateTime.parse(currentDateTime);
      DateTime end = DateTime.parse(endDateTime);

      if ((current.isAtSameMomentAs(start) || current.isAfter(start)) &&
          current.isBefore(end)) {
        return 1; // Current date is within the range
      } else if (current.isAfter(end)) {
        return 2; // Current date has crossed the end date
      }
    } catch (e) {
      print("Error parsing date: $e");
      return 0;
    }
    return 0; // Default, in case it’s before the start date
  }
}
