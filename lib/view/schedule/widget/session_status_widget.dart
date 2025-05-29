import 'package:flutter/material.dart';

import '../../../widgets/textview/customTextView.dart';
class SessionStatusWidget extends StatelessWidget {
  Color statusColor;
  String title;
  SessionStatusWidget({super.key,required this.statusColor,required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle,
            color: statusColor, size: 6),
        const SizedBox(
          width: 6,
        ),
        CustomTextView(
          text: title,
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
