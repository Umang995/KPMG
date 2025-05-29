import 'package:dreamcast/core/extension/content_extension.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:flutter/material.dart';
class PhotoListSkeleton extends StatelessWidget {
  const PhotoListSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,),
      itemCount: 10,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          color: colorLightGray,
          borderRadius: BorderRadius.circular(12),
        ),
        height: context.height,
        width: context.width,
      ),
    );
  }
}
