import '../../speakers/model/speakersModel.dart';

class SpeakerModelWebinarModel {
  bool? status;
  int? code;
  String? message;
  List<SpeakerWebinar>? body;

  SpeakerModelWebinarModel({this.status, this.code, this.message, this.body});

  SpeakerModelWebinarModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['body'] != null) {
      body = <SpeakerWebinar>[];
      json['body'].forEach((v) {
        body!.add(new SpeakerWebinar.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.body != null) {
      data['body'] = this.body!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SpeakerWebinar {
  List<SpeakersData>? sessionSpeaker;
  String? id;

  SpeakerWebinar({this.sessionSpeaker, this.id});

  SpeakerWebinar.fromJson(Map<String, dynamic> json) {
    if (json['speakers'] != null) {
      sessionSpeaker = <SpeakersData>[];
      json['speakers'].forEach((v) {
        sessionSpeaker!.add(new SpeakersData.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sessionSpeaker != null) {
      data['speakers'] = this.sessionSpeaker!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
  }
}

