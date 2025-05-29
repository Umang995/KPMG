import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';

import '../routes/my_constant.dart';
import '../theme/app_colors.dart';

class GradientTextView extends StatelessWidget {
  var text = "";
  GradientTextView({super.key, required this.text});

  final Shader linearGradient = LinearGradient(
    colors: <Color>[
      gradientEnd,
      gradientBegin,
    ],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22.fSize,
            foreground: Paint()..shader = linearGradient));
  }
}
