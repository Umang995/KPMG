/*
import 'dart:io';

import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/beforeLogin/login/login_controller.dart';
import 'package:dreamcast/view/beforeLogin/signup/screen/signup_dropdown_dialog.dart';
import 'package:dreamcast/view/beforeLogin/splash/model/config_model.dart';
import '../../widgets/loading.dart';
import '../../widgets/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import '../../../../theme/strings.dart';
import '../../../../theme/ui_helper.dart';
import '../../../widgets/customTextView.dart';
import '../../../widgets/common_material_button.dart';
import '../../../widgets/toolbarTitle.dart';

class SignupPage extends GetView<LoginController> {
  SignupPage({Key? key}) : super(key: key);
  static const routeName = "/signup";
  final AuthenticationManager authenticationManager = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        title: const ToolbarTitle(
          title: "Signup Page",
        ),
        iconTheme: const IconThemeData(color: appIconColor),
        shape: Border.all(width: 1, color: indicatorColor),
        centerTitle: false,
      ),
      body: Container(
          padding: const EdgeInsets.all(12),
          alignment: Alignment.topCenter,
          color: Colors.transparent,
          height: context.height,
          child: GetX<LoginController>(
            builder: (controller) {
              return Stack(
                children: [
                  Container(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: formKey,
                        child: controller.signupFieldList.isNotEmpty?buildListView(context):SizedBox(),
                      )),
                  controller.isLoading.value
                      ? const Loading()
                      : const SizedBox(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ProfileButton(
                      text: MyStrings.saveChange,
                      press: () {
                        if(formKey.currentState?.validate() ?? false){
                          FocusManager.instance.primaryFocus?.unfocus();
                          controller.signupPostAPi(context);
                        }
                      },
                    ),
                  )
                ],
              );
            },
          )),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget buildListView(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 0,
          child: Container(
            color: secondaryColor,
          ),
        );
      },
      itemCount: controller.signupFieldList.length,
      itemBuilder: (context, index) {
        SignupField createFieldBody = controller.signupFieldList[index];
        return createFieldBody.type == "text"
            ? _buildEditText(createFieldBody)
            : createFieldBody.type == "select"
            ? _buildDropdown(createFieldBody,context)
            : createFieldBody.type == "textarea"
            ? _buildTextArea(createFieldBody)
            : createFieldBody.type == "file"
            ? fileImage(createFieldBody,context)
            : const SizedBox();
      },
    );
  }


  _buildEditText(SignupField createFieldBody) {
    final TextEditingController textAreaController = TextEditingController();
    textAreaController.text = createFieldBody.value ?? "";
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        textInputAction: TextInputAction.done,
        controller: textAreaController,
        maxLength: createFieldBody.validationAs.toString().contains("email")
            ? 50
            : createFieldBody.validationAs.toString().contains("Mobile") ||
            createFieldBody.validationAs
                .toString()
                .contains("alternative_mobile")
            ? 12
            : 30,
        keyboardType: createFieldBody.validationAs.toString().contains("email")
            ? TextInputType.emailAddress
            : createFieldBody.validationAs.toString().contains("Mobile landline")
            ? TextInputType.phone
            : TextInputType.text,
        validator: (String? value) {
          if (createFieldBody.rules.toString().contains("required")) {
            if (value!.trim().isEmpty || value.trim() == null) {
              return "${createFieldBody.validationAs.toString().capitalize} required";
            } else if (value.length < 2) {
              return "Please enter valid ${createFieldBody.validationAs.toString().capitalize}";
            } else if (createFieldBody.validationAs
                .toString()
                .contains("email")) {
              if (!UiHelper.isEmail(value.toString())) {
                return MyStrings.enter_valid_email_address;
              }
            } else if (createFieldBody.validationAs
                .toString()
                .contains("Mobile")) {
              if (!UiHelper.isValidPhoneNumber(value.toString())) {
                return "Please enter valid mobile";
              }
            }
          }
          return null;
        },
        onChanged: (value) {
          if (value.isNotEmpty) {
            createFieldBody.value = textAreaController.text;
          }
        },
        decoration: InputDecoration(
          counter: const Offstage(),
          contentPadding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
          labelText:
          "${createFieldBody.label} ${createFieldBody.rules.toString().contains("required") ? "*" : ""}",
          //labelText: "${createFieldBody.rules.toString().contains("required")? "*"}",
          hintText: "Enter ${createFieldBody.label}",
          labelStyle: const TextStyle(color: signupStyleColor, fontSize: 16),
          fillColor: Colors.transparent,
          filled: true,
          prefixIconConstraints: const BoxConstraints(minWidth: 60),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: signupStyleColor)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black)),
        ),
      ),
    );
  }

  _buildTextArea(SignupField createFieldBody) {
    final TextEditingController textAreaController = TextEditingController();
    textAreaController.text = createFieldBody.value.toString()!;

    return TextFormField(
      textInputAction: TextInputAction.done,
      controller: textAreaController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          createFieldBody.value = textAreaController.text;
        }
      },
      validator: (String? value) {
        if (createFieldBody.rules.toString().contains("required")) {
          if (value!.trim().isEmpty) {
            return "Please enter ${createFieldBody.validationAs.toString().capitalize}";
          }
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        labelText:
        "${createFieldBody.label} ${createFieldBody.rules.toString().contains("required") ? "*" : ""}",
        hintText: "",
        labelStyle: const TextStyle(color: signupStyleColor),
        fillColor: Colors.transparent,
        filled: true,
        prefixIconConstraints: const BoxConstraints(minWidth: 60),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: signupStyleColor)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black)),
      ),
      minLines: 3,
      maxLines: 6,
    );
  }

  _buildDropdown(SignupField createFieldBody, BuildContext context) {
    return InkWell(
      onTap: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        // FormFields createFieldBody;
        await Get.to(() => SignupDropdownDialog(
          createFieldBody: createFieldBody,
        ));
        controller.signupFieldList.refresh();
        controller.update();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        width: context.width,
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: gray1, width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RegularTextView(
              color: signupStyleColor,
              textSize: 16,
              text: createFieldBody.value.toString().isEmpty
                  ? "${createFieldBody.label} ${createFieldBody.rules.toString().contains("required") ? "*" : ""}"
                  : createFieldBody.countryCode.toString(),
            ),
            const Icon(Icons.arrow_drop_down)
          ],
        ),
      ),
    ); //selected of
  }

  fileImage(SignupField createFieldBody, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RegularTextView(
              textSize: 16,color: signupStyleColor,
              text:
              "${createFieldBody.label ?? ""} ${createFieldBody.rules.toString().contains("required") ? "*" : ""}"),
          const SizedBox(
            height: 15,
          ),
          Container(
            width: 400,
            height: 200,
            decoration: const BoxDecoration(
                color: grayColorLight,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => showPicker(context,createFieldBody),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        image: createFieldBody.file !=
                            null
                            ? DecorationImage(
                          image: FileImage(File(createFieldBody.file!.path)),
                          fit: BoxFit.cover,
                        )
                            : const DecorationImage(
                            image:
                            AssetImage("assets/icons/camera.png"),
                            fit: BoxFit.contain),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(
                          color: grayColorLight,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const customTextView(
                    text: "DROP YOUR IMAGE HERE OR BROWSE",
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const RegularTextView(
                      text: "SUPPORT only PNG(UPTO 800 KB)")
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();

  void showPicker(BuildContext context, SignupField signupField) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(
                      Icons.photo_library,
                      color: kIconColor,
                    ),
                    title: const RegularTextView(
                      text: "Photo",
                      textAlign: TextAlign.start,
                    ),
                    onTap: () {
                      imgFromGallery(signupField,context);
                      Navigator.of(bc).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera, color: kIconColor),
                  title: const RegularTextView(
                      text: "Camera", textAlign: TextAlign.start),
                  onTap: () {
                    imgFromCamera(signupField,context);
                    Navigator.of(bc).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  imgFromCamera(SignupField signupField,BuildContext context) async {
    controller.pickedFile = await _picker.pickImage(
        source: ImageSource.camera);
    _cropImage(signupField,context);
   */
/* final bytes = (await pickedFile!.readAsBytes()).lengthInBytes;
    final kb = (bytes / 1024);
    print(kb);
    if (kb > 800) {
      Get.snackbar(
        backgroundColor: Colors.red,
        colorText: Colors.white,
        "Image size exceed",
        "The selected image could not be uploaded. The image is too long; the maximum size is 800 KB.",
      );
      return;
    }*//*

  }

  imgFromGallery(SignupField signupField,BuildContext context) async {
    controller.pickedFile = await _picker.pickImage(
        source: ImageSource.gallery);

    _cropImage(signupField,context);
  }

  Future<void> _cropImage(SignupField signupField,BuildContext context) async {
    if (controller.pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: controller.pickedFile!.path,
        compressFormat: ImageCompressFormat.png,
        compressQuality: 100,aspectRatioPresets: [CropAspectRatioPreset.square],
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          maxHeight: 500,maxWidth: 500,
         */
/*uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
         ],*//*

      );
      if (croppedFile != null) {
        File file= File(croppedFile!.path);

        final pngSize = ImageSizeGetter.getSize(FileInput(file));
        if(pngSize.height<500  && pngSize.width<500){
          UiHelper.showFailureMsg(context, "Required minimum size of image is 500 px");
          return;
        }
        signupField.file=file!;
        print('png = $pngSize');
        controller.signupFieldList.refresh();
      }
    }
  }

}


*/
