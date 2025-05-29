import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/controller/theme_controller.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../utils/image_constant.dart';
import 'app_bar/appbar_leading_image.dart';
import 'app_bar/custom_app_bar.dart';

class ThemeSettingsPage extends GetView<ThemeController> {
  ThemeController themeController = Get.find<ThemeController>();
  final List<String> fonts = ['Fester', 'FigTree'];

  @override
  Widget build(BuildContext context) {
    return GetX<ThemeController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: CustomAppBar(
            height: 72.v,
            leadingWidth: 45.h,
            leading: AppbarLeadingImage(
              imagePath: ImageConstant.imgArrowLeft,
              margin: EdgeInsets.only(left: 7.h, top: 3),
              onTap: () => Get.back(),
            ),
            title: const ToolbarTitle(title: "Theme Settings"),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Theme'),
                subtitle: Text(
                  themeController.themeMode.value == ThemeMode.system
                      ? 'System default'
                      : themeController.themeMode.value == ThemeMode.dark
                          ? 'Dark'
                          : 'Light',
                ),
                onTap: _showThemeSelectorBottomSheet,
              ),
              const SizedBox(height: 24),
              const Text('Font Style', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: themeController.fontFamily.value,
                items: fonts.map((font) {
                  return DropdownMenuItem(
                    value: font,
                    child: Text(font, style: TextStyle(fontFamily: font)),
                  );
                }).toList(),
                onChanged: (value) {
                  themeController.changeFont(value!);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showThemeSelectorBottomSheet() {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Choose Theme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildThemeTile(ThemeMode.system, 'System default'),
            _buildThemeTile(ThemeMode.light, 'Light'),
            _buildThemeTile(ThemeMode.dark, 'Dark'),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildThemeTile(ThemeMode mode, String label) {
    return ListTile(
      title: Text(label),
      trailing: themeController.themeMode.value == mode
          ? const Icon(Icons.check, color: Colors.green)
          : null,
      onTap: () {
        themeController.toggleTheme();

        Get.back();
      },
    );
  }
}
