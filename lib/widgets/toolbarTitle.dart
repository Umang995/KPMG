import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';

class ToolbarTitle extends StatelessWidget {
  final String title;
  final Color color;
  const ToolbarTitle({
    super.key,
    required this.title,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,style: TextStyle(
          color: colorSecondary, fontSize: 28.fSize,
          fontWeight: FontWeight.bold),textAlign: TextAlign.start,
    );
  }
}
