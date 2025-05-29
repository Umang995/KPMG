import 'dart:convert';
import 'dart:math';

import 'package:dreamcast/view/beforeLogin/splash/model/config_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dreamcast/routes/app_pages.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/dashboard/dashboard_page.dart';
import 'package:signin_with_linkedin/signin_with_linkedin.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../main.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/pref_utils.dart';

class SplashController extends GetxController {
  AuthenticationManager? authenticationManager;
  var loading = true.obs;
  var isDarkMode = true;

  @override
  void onInit() {
    initialCall();
    super.onInit();
  }

  Color getRandomColor() {
    final Random random = Random();
    return Color(0xFF000000 + random.nextInt(0x00FFFFFF));
  }

  initialCall() async {
    authenticationManager = Get.find<AuthenticationManager>();
    Future.delayed(const Duration(seconds: 3), () async {
      await authenticationManager?.getConfigDetail();
      update();
      nextScreen();
    });
  }

  Future<void> nextScreen() async {
    final isLoggedIn = authenticationManager?.isLogin() ?? false;
    final isGuestEnabled = PrefUtils.getGuestLogin();
    print("isGuestEnabled: $isGuestEnabled");
    final isGuest = PrefUtils.getGuestLoginId().isNotEmpty;

    if (isLoggedIn) {
      await Future.delayed(const Duration(milliseconds: 600));
      Get.offAllNamed(DashboardPage.routeName);
    } else if (isGuest && isGuestEnabled) {
      await Future.delayed(const Duration(milliseconds: 600));
      Get.offAllNamed(DashboardPage.routeName);
    } else {
      SignInWithLinkedIn.logout();
      Get.offAndToNamed(Routes.LOGIN);
    }
  }
}
