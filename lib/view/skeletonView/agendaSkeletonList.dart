import 'package:dreamcast/view/schedule/model/scheduleModel.dart';
import 'package:flutter/material.dart';

import '../schedule/view/session_list_body.dart';

class ListAgendaSkeleton extends StatelessWidget {
  const ListAgendaSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) => SessionListBody(
        isFromBookmark: false,
        session: SessionsData(
            description: "Conference Closing",
            label: "Conference Closing",
            bookmark: "",
            speakers: [],
            thumbnail: "",
            keywords: [],
            startDatetime: "2024-05-09T04:35:00Z",
            status: Status(value: 0, text: "", color: ""),
        ),
        index: 0,
        size: 10,
      ),
    );
  }
}
