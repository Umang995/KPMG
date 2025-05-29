import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/cupertino.dart';

import '../theme/app_colors.dart';
import '../theme/app_decoration.dart';
import 'textview/customTextView.dart';

class RecommendedWidget extends StatelessWidget {
  const RecommendedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      /*child: Image.asset("assets/images/recommended_tag.png",height: 20.adaptSize,),*/
      decoration: AppDecoration.recommendedDecoration(),
      child: CustomTextView(
        text: "Recommended",
        textAlign: TextAlign.center,
        fontSize: 12,
        color: white,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class SpeakerTypeWidget extends StatelessWidget {
  String type;
  SpeakerTypeWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
      decoration: AppDecoration.speakerDecoration(),
      child: CustomTextView(
        text: type,
        textAlign: TextAlign.start,
        fontSize: 12,
        color: white,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
