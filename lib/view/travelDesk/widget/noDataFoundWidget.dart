
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoDataFoundWidget extends StatelessWidget {
  final image, title, description;
  const NoDataFoundWidget({super.key, this
  .title, this.description, this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 85,
            width: 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: const Color.fromRGBO(244, 243, 247, 1),
            ),
            child: SvgPicture.asset(image),
          ),
          const SizedBox(
            height: 25,
          ),
          CustomTextView(
            text: title,
             color: colorSecondary,
            fontSize: 22,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(
            height: 12,
          ),
           CustomTextView(
            text: description,
            color: colorSecondary,
            fontSize: 16,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
