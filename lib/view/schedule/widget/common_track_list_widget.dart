import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/foundational_track_widget.dart';

class CommonTrackListWidget extends StatelessWidget {
  List<dynamic> keywordsList;
  CommonTrackListWidget({super.key, required this.keywordsList});

  List<Color> trackColor = [
    const Color(0xffCF138A),
    const Color(0xffEA4E1B),
    const Color(0xff1B81C3),
    const Color(0xff1D2542),
    const Color(0xffCF138A),
    const Color(0xffEA4E1B),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20.v,
        ),
        SizedBox(
          height: 29.v,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: keywordsList.length,
            itemBuilder: (context, index) {
              var keywords = keywordsList[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FoundationalTrackWidget(
                  color: trackColor[index % 6],
                  title: keywords.toString(),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
