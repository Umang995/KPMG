import 'package:dreamcast/utils/pref_utils.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../app_colors.dart';

class ThemeController extends GetxController with WidgetsBindingObserver {
  // Observable theme mode and font
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;
  RxString fontFamily = "FigTree".obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this); // Start listening
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this); // Clean up
    super.onClose();
  }

  // Called when app resumes from background
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final context = Get.context;
      if (context != null) {
        loadThemeBasedOnSystem(context);
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    // This waits until after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = Get.context;
      if (context != null) {
        loadThemeBasedOnSystem(context);
      }
    });
  }

  void loadThemeBasedOnSystem(BuildContext context) {
    final isSystemDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    PrefUtils.setThemeMode(isSystemDarkMode);
    themeMode.value = isSystemDarkMode ? ThemeMode.dark : ThemeMode.light;
    // Optionally apply theme and update UI
    Get.changeThemeMode(themeMode.value);
    setColorAsPerTheme(isSystemDarkMode);
  }

  void setColorAsPerTheme(bool isDarkMode) {
    primary = isDarkMode ? const Color(0xffF08E20) : const Color(0xff4658A7);
    secondary = isDarkMode ? const Color(0xffDCDCDD) : const Color(0xFF333333);
    lightGray = isDarkMode ? const Color(0xff343434) : const Color(0xffF4F3F7);
    backgroundColor =
        isDarkMode ? const Color(0xff000000) : const Color(0xffFFFFFF);
    Get.forceAppUpdate();
  }

  // Toggle between light and dark mode
  void toggleTheme() {
    // Toggle theme mode
    themeMode.value =
        themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    // Save theme mode in preferences
    PrefUtils.setThemeMode(themeMode.value == ThemeMode.dark ? true : false);
    print(
        "Theme mode loaded: $themeMode.value == ThemeMode.dark ? true : false");

    // Apply the theme first
    Get.changeThemeMode(themeMode.value);

    // Use the new theme context to update your color variables
    final bool isDarkMode = themeMode.value == ThemeMode.dark;
    setColorAsPerTheme(isDarkMode); // abstract your color update logic here
  }

  // Change the app font dynamically
  void changeFont(String font) {
    fontFamily.value = font;
    Get.forceAppUpdate(); // Force rebuild to apply new font
  }

  Future<void> updateColor({
    required Color primaryColor,
    required Color secondaryColor,
    Color? lightGrayColor,
    Color? backgroundColor,
  }) async {
    primary = themeMode.value == ThemeMode.dark
        ? const Color(0xffF08E20)
        : primaryColor;

    secondary = themeMode.value == ThemeMode.dark
        ? const Color(0xffDCDCDD)
        : secondaryColor;

    // Optional colors
    if (lightGrayColor != null) {
      lightGray = lightGrayColor;
    }
    if (backgroundColor != null) {
      backgroundColor = backgroundColor;
    }

    Get.forceAppUpdate();
  }

  // Return ThemeData based on current settings
  ThemeData get lightTheme => ThemeData(
      brightness: Brightness.light,
      fontFamily: fontFamily.value,
      secondaryHeaderColor: Colors.white,
      shadowColor: Colors.black,
      cardColor: const Color(0xFF333333),
      highlightColor: Colors.white,
      dividerColor: const Color(0xffDCDCDD),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFFF4F3F7), // Light background for text fields
      ),
      tabBarTheme: TabBarTheme(
        overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.2)),
        labelStyle: TextStyle(
            fontFamily: fontFamily.value,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: colorPrimary), // for selected tabs
        unselectedLabelStyle: TextStyle(
            fontFamily: fontFamily.value,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: colorGray), // for unselected tabs
      ),
      scaffoldBackgroundColor: white,
      colorScheme: ColorScheme.light(
          onSurface: const Color(0xFF333333),
          onPrimary: Colors.black,
          primary: colorPrimary,
          secondary: colorSecondary));

  ThemeData get darkTheme => ThemeData(
      brightness: Brightness.dark,
      fontFamily: fontFamily.value,
      tabBarTheme: TabBarTheme(
        overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.2)),
        labelStyle: TextStyle(
            fontFamily: fontFamily.value,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: colorPrimary), // for selected tabs
        unselectedLabelStyle: TextStyle(
            fontFamily: fontFamily.value,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: colorGray), // for unselected tabs
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xff343434), // Dark background for text fields
      ),
      scaffoldBackgroundColor: white,
      secondaryHeaderColor: Colors.black,
      shadowColor: Colors.white,
      highlightColor: Colors.white,
      dividerColor: const Color(0xffDCDCDD),
      cardColor: const Color(0xFF333333),
      colorScheme: ColorScheme.dark(
        onSurface: const Color(0xffDCDCDD),
        onPrimary: Colors.white,
        primary: const Color(0xffF08E20),
        secondary: colorSecondary,
      ));
}
