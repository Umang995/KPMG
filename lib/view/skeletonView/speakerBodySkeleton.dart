import 'package:flutter/material.dart';
import '../speakers/model/speakersModel.dart';
import '../speakers/view/speakerListBody.dart';

class SpeakerListSkeleton extends StatelessWidget {
  const SpeakerListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SpeakerViewWidget(
        speakerData: SpeakersData(
          avatar: "",
          name: "Sample user name",
          company: "Dreamcast",
          position: "Android developer",
        ),
        isSpeakerType: true,
            ),
      ));
  }
}
