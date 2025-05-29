import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_decoration.dart';
import 'textview/customTextView.dart';

class CustomImageWidget extends StatelessWidget {
  var imageUrl;
  var shortName;
  double? size;
  Color? color;
  final double? fontSize;
  final double? borderWidth;
  CustomImageWidget(
      {Key? key,
      this.imageUrl,
      this.shortName,
      this.size,
      this.fontSize,
      this.borderWidth,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(imageUrl);
    return SizedBox(
      height: size?.adaptSize ?? 70.adaptSize,
      width: size?.adaptSize ?? 70.adaptSize,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: color ?? colorLightGray, width: borderWidth ?? 1),
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
          ),
        ),
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            border: Border.all(color: color ?? colorLightGray, width: 1),
            shape: BoxShape.circle,
            color: color,
          ),
          child: Center(
              child: CustomTextView(
            text: shortName,
            fontSize: fontSize ?? 22,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w600,
          )),
        ),
      ),
    );
  }
}

class CustomSqureImageWidget extends StatelessWidget {
  var imageUrl;
  var shortName;
  double? size;
  CustomSqureImageWidget({Key? key, this.imageUrl, this.shortName, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size?.adaptSize ?? 70.adaptSize,
      width: size?.adaptSize ?? 70.adaptSize,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            color: colorLightGray,
            border: Border.all(color: colorLightGray, width: 1),
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
          ),
        ),
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            border: Border.all(color: colorLightGray, width: 1),
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            color: colorLightGray,
          ),
          child: Center(
              child: CustomTextView(
            text: shortName,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          )),
        ),
      ),
    );
  }
}

class DetailImageWidget extends StatelessWidget {
  var imageUrl;
  var shortName;
  DetailImageWidget({Key? key, this.imageUrl, this.shortName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 94.78.adaptSize,
      width: 94.78.adaptSize,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            border: Border.all(color: colorPrimary, width: 0),
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
          ),
        ),
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: AppDecoration.shortNameImageDecoration(),
          child: Center(
              child: CustomTextView(
            text: shortName,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          )),
        ),
      ),
    );
  }
}
