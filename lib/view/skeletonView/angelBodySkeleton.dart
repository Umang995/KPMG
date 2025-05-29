import 'package:dreamcast/view/startNetworking/view/angelAlly/angelWidget/AngelListBody.dart';
import 'package:flutter/material.dart';
import '../startNetworking/model/angelAllyModel.dart';

class AngelListSkeleton extends StatelessWidget {
  const AngelListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => AngelHallBody(
      session: AngelBody(
        description: "Conference Closing",
        label: "Conference Closing",
        endDatetime: "Dreamcast",
        startDatetime: "2024-05-09T04:35:00Z",
      ),
        index: 0,size: 0,
    ));
  }
}
