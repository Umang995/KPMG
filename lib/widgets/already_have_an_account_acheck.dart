import 'package:dreamcast/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'textview/customTextView.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  const AlreadyHaveAnAccountCheck(
    this.login, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CustomTextView(
          text: login
              ? "dont_have_account".tr
              : "already_have_account".tr,
          color: colorSecondary,fontWeight: FontWeight.normal,
          fontSize: 15,
        ),
        CustomTextView(text:login ? "signup".tr : "Login",
                underline: true,
                fontSize: 15,fontWeight: FontWeight.normal,
                color: colorPrimary),
        //RegularTextView(text: login ? MyStrings.signup : "Login",color: primaryColor,)
      ],
    );
  }
}

class LoginLinkedin extends StatelessWidget {
  final bool login;
  const LoginLinkedin(
    this.login, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
         CustomTextView(text: "Sign in with",
            underline: true,
            fontWeight: FontWeight.normal,
            fontSize: 15,
                color: colorPrimary),
        const SizedBox(
          width: 6,
        ),
        Image.asset("assets/icons/linkedin.png", height: 26),
      ],
    );
  }
}

class LoginViaApple extends StatelessWidget {
  final bool login;
  const LoginViaApple(
    this.login, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
         Text("Sign in with",
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 14,
                color: colorSecondary)),
        const SizedBox(
          width: 6,
        ),
        Image.asset("assets/icons/ic_apple.png", height: 26),
      ],
    );
  }
}
