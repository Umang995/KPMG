import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/image_constant.dart';
import '../../widgets/textview/customTextView.dart';

class ListDocumentSkeleton extends StatelessWidget {
  const ListDocumentSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration:  BoxDecoration(
            color: true ? colorLightGray : colorGray,
            borderRadius: const BorderRadius.all(Radius.circular(6))),
        margin: const EdgeInsets.all(5),
        child: const ListTile(
          title: Text("Hello Notification description"),
          subtitle: Text("Notification description Notification description"),
        ),
      ),
    );
  }
}

class NotesSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8, right: 8),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        height: 30,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 30, bottom: 20),
                    child: CustomReadMoreText(
                      text: "title",
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    height: 50,
                    decoration:  BoxDecoration(
                        color: colorLightGray,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: const Icon(Icons.circle),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 100.h,
                              child:  CustomTextView(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  text: "Details of user",
                                  color: colorPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        SvgPicture.asset(ImageConstant.arrowDetails,
                            color: colorPrimary),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}
