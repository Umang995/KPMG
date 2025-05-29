import 'package:flutter/material.dart';
import 'package:dreamcast/theme/app_colors.dart';

class AcceptTermsConditionCheck extends StatelessWidget {
  final Function press;
  final String textFirst;
  final String textLast;
  const AcceptTermsConditionCheck( {
    required Key key,
    required this.press,
    required this.textFirst,
    required this.textLast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Text(textFirst, softWrap: true ,style:  TextStyle(color: colorGray,fontSize: 12),
          ),
        ),
        GestureDetector(
          onTap: press(),
          child: Expanded(
            child: Text(textLast,softWrap: true ,style:  TextStyle(decoration: TextDecoration.underline, color: colorSecondary, fontWeight: FontWeight.bold,fontSize: 12
            ),
            ),
          ),
        ),
      ],
    );
  }
}
