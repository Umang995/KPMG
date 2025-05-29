import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/beforeLogin/widget/loginFormWidget.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../widget/login_signup_widget.dart';
import 'login_controller.dart';

class LoginPageOTP extends GetView<LoginController> {
  LoginPageOTP({Key? key}) : super(key: key);

  // Fetching authentication manager using Get.find()
  final AuthenticationManager _authManager = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Prevents UI shift when the keyboard appears
      body: Stack(
        children: [
          _buildBgImage(context), // Background image
          Column(
            mainAxisSize: MainAxisSize.min, // Uses only required space
            children: [
              SizedBox(height: 100.v),
              _buildLoginLogo(), // Logo widget
              SizedBox(height: 44.v),
              // Observing `signup form` state and rebuilding only this widget
              Obx(() => controller.signupform.value
                  ? LoginSignupWidget(isGuestForm: false)
                  : LoginFormWidget(isGuestForm: false)),
            ],
          ),
          // Aligning bottom image at the bottom
          Align(alignment: Alignment.bottomCenter, child: _buildBottomImage()),
        ],
      ),
    );
  }

  /// Builds the login logo, showing network image if available, else uses asset image.
  Widget _buildLoginLogo() {
    final logoUrl = _authManager.configModel.body?.meta?.logos?.icon;

    print("logoUrl: $logoUrl");

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: logoUrl != null && logoUrl.isNotEmpty
          ? Image.network(logoUrl, height: 45, fit: BoxFit.contain)
          : Image.asset(ImageConstant.header_logo,
              height: 45, fit: BoxFit.contain),
    );
  }

  /// Builds the background image using `CachedNetworkImage`
  Widget _buildBgImage(BuildContext context) {
    final bgUrl =
        _authManager.configModel.body?.meta?.backgrounds?.loginBg ?? "";
    print("bgUrl: $bgUrl");
    return CachedNetworkImage(
      imageUrl: bgUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: context.height,
        width: context.width,
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (_, __) =>
          _defaultBgImage(context), // Default background image when loading
      errorWidget: (_, __, ___) =>
          _defaultBgImage(context), // Default image in case of error
    );
  }

  /// Returns a default background image (used as a placeholder and error fallback).
  Widget _defaultBgImage(BuildContext context) {
    return Container(
      //ImageConstant.login_bg,
      height: context.height,
      width: context.width,
      color: Colors.black,
      // fit: BoxFit.cover,
    );
  }

  /// Builds the bottom branding section with a "Powered by" text and a logo.
  Widget _buildBottomImage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Takes only the necessary space
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "powered_by".tr, // Translatable text
              style: TextStyle(
                color: white,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SvgPicture.asset(ImageConstant.icDreamcast, height: 26.adaptSize),
        ],
      ),
    );
  }
}
