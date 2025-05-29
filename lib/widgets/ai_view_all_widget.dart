import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/cupertino.dart';

import '../theme/app_colors.dart';

class AiViewAllWidget extends StatelessWidget {
  const AiViewAllWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 12),
      decoration: BoxDecoration(
          color: white,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          border: Border.all(color: borderColor,width: 1)
      ),
      child:  CustomTextView(
        text: "View All",fontSize: 14,color: colorSecondary,fontWeight: FontWeight.normal,

      ),
    );
  }
}
