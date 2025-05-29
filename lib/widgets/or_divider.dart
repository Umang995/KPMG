import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
      width: size.width * 0.8,
      child: Row(
        children: <Widget>[
          buildDivider(),
           Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: CustomTextView(text: "OR",fontSize: 14,textAlign: TextAlign.center,color: colorGray,),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return  Expanded(
      child: Divider(
        color: colorGray,
        height: 1.5,
      ),
    );
  }
}
