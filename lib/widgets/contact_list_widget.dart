import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../theme/app_colors.dart';
import '../view/beforeLogin/globalController/authentication_manager.dart';
import '../view/contact/controller/contact_controller.dart';
import '../view/representatives/controller/user_detail_controller.dart';
import 'customImageWidget.dart';
import 'textview/customTextView.dart';
import 'button/custom_icon_button.dart';

class ContactListBody extends GetView<ContactController> {
  dynamic representatives;
  final Function press;

  ContactListBody({
    super.key,
    required this.representatives,
    required this.press,
  });

  final AuthenticationManager authenticationManager = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Future.delayed(Duration.zero, () async {
          press();
        });
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      // Ensure alignment to the left
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: CustomImageWidget(
                          imageUrl: representatives.avatar ?? "",
                          shortName: representatives.shortName ?? "",
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(width: 6,),
                  Expanded(
                      flex: 11,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextView(
                              text:
                                  representatives.name?.toString().trim() ?? "",
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              textAlign: TextAlign.start,
                              color: colorSecondary,
                            ),
                            Container(
                              padding: const EdgeInsets.only(right: 3.0),
                              child:
                                  representatives.type.toString() == "Meeting"
                                      ? SvgPicture.asset(
                                          "assets/svg/ic_contact_meeting.svg",
                                          width: 18,
                                        )
                                      : SvgPicture.asset(
                                          "assets/svg/ic_scanned.svg",
                                          width: 16,
                                        ),
                            ),
                            //const SizedBox(width: 30,)
                          ],
                        ),
                        subtitle: Container(
                          margin: EdgeInsets.only(right: 80.adaptSize),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextView(
                                text: "${representatives.position ?? ""}",
                                fontSize: 14,
                                maxLines: 2,
                                fontWeight: FontWeight.normal,
                                color: colorGray,
                                textAlign: TextAlign.start,
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 80),
                                child: CustomTextView(
                                  text: "${representatives.company ?? ""}",
                                  fontSize: 14,
                                  maxLines: 2,
                                  fontWeight: FontWeight.w600,
                                  color: colorGray,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              if (representatives.email?.isNotEmpty ?? false)
                                CustomTextView(
                                  text:
                                      "Email : ${representatives.email ?? ""}",
                                  fontSize: 14,
                                  maxLines: 2,
                                  fontWeight: FontWeight.normal,
                                  color: colorSecondary,
                                  textAlign: TextAlign.start,
                                ),
                              if (representatives.mobile?.isNotEmpty ?? false)
                                CustomTextView(
                                  text:
                                      "Phone : ${representatives.mobile ?? ""}",
                                  fontSize: 14,
                                  maxLines: 2,
                                  fontWeight: FontWeight.normal,
                                  color: colorSecondary,
                                  textAlign: TextAlign.start,
                                ),
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: CustomIconButton(
                    onTap: () {
                      controller.requestPermissionAndSaveContact(
                          context, representatives);
                    },
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.h, vertical: 5.h),
                    decoration: BoxDecoration(
                        color: colorLightGray,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    height: 28.v,
                    width: 84.h,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            "assets/svg/ic_add_to_phone.svg",
                            height: 19.h,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Padding(
                            padding: EdgeInsets.zero,
                            child: CustomTextView(
                              text: "Add",
                              fontWeight: FontWeight.normal,
                              color: colorSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ))),
          )
        ],
      ),
    );
  }
}
