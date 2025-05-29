import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
class InternetChecker {
  InternetChecker() {
    InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.disconnected:
          Get.snackbar(
            backgroundColor: Colors.red,
            "Network",
            "Please check your internet.",
          );
          break;
      }
    });
  }
}