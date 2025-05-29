import 'package:dreamcast/view/meeting/model/meeting_model.dart';
import 'package:flutter/material.dart';
import '../../widgets/meeting_list_body.dart';

class MeetingListSkeleton extends StatelessWidget {
  const MeetingListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => MeetingListBodyWidget(
          Meetings(
              status: 1,
              iam: "sender",
              location: "In person",
              startDatetime: "2024-05-09T04:00:00Z",
              endDatetime: "2024-05-09T04:15:00Z",
              user: User(
                  avatar: "",
                  shortName: "AB",
                  name: "Test User",
                  company: "dreamcast",
                  position: "Flutter")),
          10,
          index,
          false),
    );
  }
}
