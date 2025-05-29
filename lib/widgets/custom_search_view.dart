import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../utils/image_constant.dart';
import 'custom_image_view.dart';

class CustomSearchView extends StatelessWidget {
  CustomSearchView(
      {Key? key,
      this.alignment,
      this.width,
      this.scrollPadding,
      this.controller,
      this.focusNode,
      this.autofocus = false,
      this.textStyle,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.hintText,
      this.hintStyle,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.suffixConstraints,
      this.contentPadding,
      this.borderDecoration,
      this.fillColor,
      this.filled = true,
      this.onSubmit,
      this.onClear,
      this.press,
      this.isShowFilter,
      this.isFilterApply,
      this.onChanged})
      : super(
          key: key,
        );

  final Alignment? alignment;

  final double? width;

  final TextEditingController? scrollPadding;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool? autofocus;

  final TextStyle? textStyle;

  final TextInputType? textInputType;

  final int? maxLines;

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;
  final bool? isFilterApply;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final Function(String)? onClear;
  final Function? press;

  bool? isShowFilter;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center, child: searchViewWidget(context))
        : searchViewWidget(context);
  }

  Widget searchViewWidget(BuildContext context){
    return SizedBox(
      width: width ?? double.maxFinite,
      height: 55,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autocorrect: false,
              scrollPadding: EdgeInsets.only(
                  bottom: MediaQuery.of(Get.context!).viewInsets.bottom),
              controller: controller,
              focusNode: focusNode,
              onTapOutside: (event) {
                if (focusNode != null) {
                  focusNode?.unfocus();
                } else {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              autofocus: autofocus!,
              style: TextStyle(
                  color: colorSecondary,
                  fontWeight: FontWeight.normal,
                  fontSize: 18),
              keyboardType: textInputType,
              maxLines: maxLines ?? 1,
              decoration: decoration,
              //validator: validator,
              onSubmitted: (data) {
                //inputData(data);
                if (data.isNotEmpty) {
                  Future.delayed(Duration.zero, () async {
                    onSubmit?.call(data);
                  });
                }
              },
              onChanged: (String value) {
                onChanged?.call(value);
              },
            ),
          ),
          SizedBox(
              width: isShowFilter != null && isShowFilter == true ? 14.h : 0),
          isShowFilter != null && isShowFilter == true
              ? InkWell(
            onTap: () {
              Future.delayed(Duration.zero, () async {
                press?.call();
              });
            },
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: CustomImageView(
                      imagePath: ImageConstant.filterIcon,
                      height: 20.adaptSize,
                      width: 20.adaptSize,color:Theme.of(context).colorScheme.onSurface
                  ),
                ),
                Positioned(
                    top: -1,
                    right: -1,
                    child: Icon(
                      Icons.circle,
                      size: 8,
                      color:
                      isFilterApply != null && isFilterApply == true
                          ? colorFilterDot
                          : Colors.transparent,
                    ))
              ],
            ),
          )
              : const SizedBox()
        ],
      ),
    );
  }
  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: TextStyle(
            color: colorGray, fontWeight: FontWeight.normal, fontSize: 18),
        prefixIcon: prefix ??
            Container(
              margin: EdgeInsets.fromLTRB(17.h, 14.v, 10.h, 14.v),
              child: CustomImageView(
                imagePath: ImageConstant.imgRewind,
                height: 22.adaptSize,
                width: 22.adaptSize,
              ),
            ),
        prefixIconConstraints: prefixConstraints ??
            BoxConstraints(
              maxHeight: 56.v,
            ),
        suffixIcon: controller?.text != null && controller!.text.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(
                  right: 1.h,
                ),
                child: IconButton(
                  onPressed: () {
                    controller!.clear();
                    onClear?.call("");
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey.shade600,
                  ),
                ),
              )
            : const SizedBox(),
        suffixIconConstraints: suffixConstraints ??
            BoxConstraints(
              maxHeight: 56.v,
            ),
        isDense: true,
        contentPadding: contentPadding ??
            EdgeInsets.only(
              top: 16.v,
              right: 16.h,
              bottom: 16.v,
            ),
        fillColor: fillColor ?? colorLightGray,
        filled: filled,
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.h),
              borderSide: BorderSide.none,
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.h),
              borderSide: BorderSide.none,
            ),
        focusedBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.h),
              borderSide: BorderSide.none,
            ),
      );
}

class NewCustomSearchView extends StatelessWidget {
  NewCustomSearchView(
      {Key? key,
      this.alignment,
      this.width,
      this.scrollPadding,
      this.controller,
      this.focusNode,
      this.autofocus = false,
      this.textStyle,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.hintText,
      this.hintStyle,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.suffixConstraints,
      this.contentPadding,
      this.borderDecoration,
      this.fillColor,
      this.filled = true,
      this.onSubmit,
      this.onClear,
      this.press,
      this.isShowFilter,
      this.onChanged})
      : super(
          key: key,
        );

  final Alignment? alignment;

  final double? width;

  final TextEditingController? scrollPadding;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool? autofocus;

  final TextStyle? textStyle;

  final TextInputType? textInputType;

  final int? maxLines;

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final Function(String)? onClear;
  final Function? press;

  bool? isShowFilter;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center, child: searchViewWidget)
        : searchViewWidget;
  }

  Widget get searchViewWidget => SizedBox(
        width: width ?? double.maxFinite,
        height: 55,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                autocorrect: false,
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(Get.context!).viewInsets.bottom),
                controller: controller,
                focusNode: focusNode,
                onTapOutside: (event) {
                  if (focusNode != null) {
                    focusNode?.unfocus();
                  } else {
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                },
                autofocus: autofocus!,
                style: TextStyle(
                    color: colorSecondary,
                    fontWeight: FontWeight.normal,
                    fontSize: 18),
                keyboardType: textInputType,
                maxLines: maxLines ?? 1,
                decoration: decoration,
                //validator: validator,
                onSubmitted: (data) {
                  //inputData(data);
                  if (data.isNotEmpty) {
                    Future.delayed(Duration.zero, () async {
                      onSubmit?.call(data);
                    });
                  }
                },
                onChanged: (String value) {
                  onChanged?.call(value);
                },
              ),
            ),
            SizedBox(
                width: isShowFilter != null && isShowFilter == true ? 14.h : 0),
            isShowFilter != null && isShowFilter == true
                ? InkWell(
                    onTap: () {
                      Future.delayed(Duration.zero, () async {
                        press?.call();
                      });
                    },
                    child: CustomImageView(
                      imagePath: ImageConstant.filterIcon,
                      height: 20.adaptSize,
                      width: 20.adaptSize,
                    ),
                  )
                : const SizedBox()
          ],
        ),
      );
  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: TextStyle(
            color: colorGray, fontWeight: FontWeight.normal, fontSize: 18),
        prefixIcon: prefix ??
            Container(
              margin: EdgeInsets.fromLTRB(17.h, 14.v, 10.h, 14.v),
              child: CustomImageView(
                imagePath: ImageConstant.imgRewind,
                height: 22.adaptSize,
                width: 22.adaptSize,
              ),
            ),
        prefixIconConstraints: prefixConstraints ??
            BoxConstraints(
              maxHeight: 56.v,
            ),
        suffixIcon: controller != null && controller!.text.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(
                  right: 1.h,
                ),
                child: IconButton(
                  onPressed: () {
                    controller!.clear();
                    onClear?.call("");
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey.shade600,
                  ),
                ),
              )
            : const SizedBox(),
        suffixIconConstraints: suffixConstraints ??
            BoxConstraints(
              maxHeight: 56.v,
            ),
        isDense: true,
        contentPadding: contentPadding ??
            EdgeInsets.only(
              top: 16.v,
              right: 16.h,
              bottom: 16.v,
            ),
        fillColor: fillColor ?? colorLightGray,
        filled: filled,
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.h),
              borderSide: BorderSide.none,
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.h),
              borderSide: BorderSide.none,
            ),
        focusedBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.h),
              borderSide: BorderSide.none,
            ),
      );
}
