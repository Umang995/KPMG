import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dreamcast/theme/app_colors.dart';

import '../routes/my_constant.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final String lableText;
  final bool isMobile;
  final bool? enable;
  final int maxLength;
  final IconData icon;
  final String inputExperssion;
  final TextInputType inputType;
  final TextEditingController controller;
  final TextInputAction inputAction;
  final FormFieldValidator<String> validator;
  final ValueChanged<String>? valueChanged;

  const RoundedInputField(
      {Key? key,
      this.inputExperssion = "",
      this.isMobile = false,
      this.enable = true,
      required this.controller,
      required this.inputAction,
      required this.inputType,
      required this.hintText,
      this.lableText = "",
      this.maxLength = 50,
      this.icon = Icons.person,
      required this.validator,
      this.valueChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          enabled: enable,
          controller: controller,
          textInputAction: inputAction,
          keyboardType: inputType,
          validator: validator,
          onChanged: valueChanged,
          maxLength: maxLength,
          inputFormatters: inputExperssion.isNotEmpty
              ? [
                  FilteringTextInputFormatter.allow(RegExp(inputExperssion)),
                ]
              : [
                  FilteringTextInputFormatter.allow(
                      RegExp("[()a-zA-Z 0123456789@. ]")),
                ],
          style:
              const TextStyle(fontSize: 16, fontFamily: MyConstant.currentFont),
          cursorColor: colorSecondary,
          decoration: inputDecoration(lableText, hintText),
        ),
        isMobile
            ? Positioned(
                child: CountryCodePicker(
                  onChanged: print,
                  showCountryOnly: true,
                  initialSelection: 'IN',
                  showFlag: false,
                  onInit: (code) => debugPrint(
                      "on init ${code?.name} ${code?.dialCode} ${code?.name}"),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  InputDecoration inputDecoration(String labelText, String hintTxt,
      {String? prefix, String? helperText}) {
    return InputDecoration(
      counter: const Offstage(),
      contentPadding: EdgeInsets.fromLTRB(isMobile ? 60 : 15, 15, 15, 15),
      helperText: helperText,
      labelText: labelText,
      hintText: hintTxt,
      labelStyle: const TextStyle(
          color: Colors.black,
          fontFamily: MyConstant.currentFont,
          fontSize: 15),
      fillColor: Colors.transparent,
      filled: true,
      prefixText: prefix,
      prefixIconConstraints: const BoxConstraints(minWidth: 60),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorSecondary)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black)),
    );
  }
}
