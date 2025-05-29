/*
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/view/representatives/controller/user_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/customTextView.dart';
import '../../../widgets/button/custom_icon_button.dart';
import '../../../widgets/dialog/custom_animated_dialog_widget.dart';

class ConnectChatDialog extends GetView<UserDetailController> {
  ConnectChatDialog({Key? key}) : super(key: key);
  static const routeName = "/ConnectChatDialog";
  final textFieldController = TextEditingController();
  final AuthenticationManager _authController = Get.find();
  TextEditingController txtController = TextEditingController();
  var focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white.withOpacity(0.0),
        body: Container(
          //color: Colors.black.withOpacity(0.70),
          padding: const EdgeInsets.all(24),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white),
                  child: GetX<UserDetailController>(builder: (controller) {
                    return SingleChildScrollView(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 22,
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () {
                                    Get.back(result: false);
                                  },
                                  child: const Icon(Icons.close),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: CustomTextView(
                                  text: "enter_your_message".tr,
                                  color: colorSecondary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(
                                height: 22,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xffDCDCDD),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.all(20),
                                child: TextField(
                                  decoration: InputDecoration.collapsed(
                                      hintText: "type_here".tr,
                                      focusColor: Colors.black,
                                      hintStyle: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Color(0xffB2B2B2))),
                                  controller: txtController,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  focusNode: focusNode,
                                  maxLines: 6,
                                  minLines: 4,
                                ),
                              ),
                              const SizedBox(
                                height: 22,
                              ),
                              CustomIconButton(
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  if (txtController.text.trim().isEmpty) {
                                    UiHelper.showFailureMsg(
                                        context, "description_required".tr);
                                    return;
                                  }
                                  var result = await controller.sendChatRequest(
                                    context: context,
                                    body: {
                                      "receiver_id":
                                          controller.userDetailBody.value.id,
                                      "text": txtController.text.trim()
                                    },
                                  );
                                  Get.back(result: result);
                                },
                                height: 50.adaptSize,
                                decoration: BoxDecoration(
                                  color: colorPrimary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 123.adaptSize,
                                child: Center(
                                  child: CustomTextView(
                                    text: "oneToOne".tr,
                                    fontWeight: FontWeight.w500,
                                    color: white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 22,
                              ),
                            ],
                          ),
                          controller.isLoading.value
                              ? SizedBox(
                                  height: 100.adaptSize, child: const Loading())
                              : const SizedBox()
                        ],
                      ),
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
*/
