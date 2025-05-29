import 'package:dreamcast/core/extension/content_extension.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
class Partnerslistskeleton extends StatelessWidget {
  const Partnerslistskeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 5,
      itemBuilder: (context, index) => ListTile(
        contentPadding: EdgeInsets.zero,
        title: Container(
          decoration: BoxDecoration(
            color: colorLightGray,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(bottom: 20,top: 15),
          height: 20,
          width: 30,
        ),
        subtitle: GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1 / 1,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,),
            itemCount: 3,
            itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                color: colorLightGray,
                borderRadius: BorderRadius.circular(12),
              ),
              height: context.height,
              width: context.width,
            )
        )
    ));
  }
}
