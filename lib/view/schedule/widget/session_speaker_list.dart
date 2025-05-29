import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/view/schedule/controller/session_controller.dart';
import 'package:dreamcast/view/speakers/model/speakersModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../speakers/controller/speakersController.dart';
import '../../speakers/view/speakerListBody.dart';

class SessionSpeakerList extends GetView<SessionController> {
  List<SpeakersData> speakerList;
  SessionSpeakerList({super.key, required this.speakerList});

  SpeakersDetailController speakersController = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: speakerList.length,
      itemBuilder: (context, index) => buildListBody(speakerList[index]),
    );
  }

  Widget buildListBody(SpeakersData speakerData) {
    return InkWell(
      onTap: () async {
        controller.loading(true);
        final SpeakersDetailController _speakerController = Get.find();
        await _speakerController.getSpeakerDetail(
            speakerId: speakerData.id,
            role: speakerData.role??MyConstant.speakers,
            isSessionSpeaker: true);
        controller.loading(false);

      },
      child: SpeakerViewWidget(
        speakerData: speakerData,
        isSpeakerType: true,
        isApiLoading: false,
      ),
    );
  }
}
