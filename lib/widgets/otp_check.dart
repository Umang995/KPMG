import 'package:flutter/material.dart';
import 'package:dreamcast/theme/app_colors.dart';

class OTPCheck extends StatelessWidget {
  final bool login;
  final Function press;
  const OTPCheck(this.login, {
    Key? key,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Didn't receive an OTP? " : "Already have an Account ? ",
          style: const TextStyle(color: Colors.black),
        ),
        GestureDetector(
          onTap: press(),
          child: Text(login ? "Resend OTP" : "Sign In",
            style:  TextStyle(
              decoration: TextDecoration.underline,
              color: colorSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
