import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/textview/customTextView.dart';
import '../model/criteriaModel.dart';

class CriteriaChildWidget extends StatelessWidget {
  Criteria points;
  CriteriaChildWidget({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: CustomTextView(
        text: points.name ?? "",
        color: colorSecondary,
        maxLines: 3,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        textAlign: TextAlign.start,
      ),
      trailing: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6), color: colorLightGray),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextView(
                text: points.point.toString() ?? "",
                color: colorPrimary,maxLines: 1,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
               CustomTextView(
                text: "Points",
                color: colorGray,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
