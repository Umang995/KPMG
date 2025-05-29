import 'package:dreamcast/view/schedule/model/scheduleModel.dart';

class SpeakerSessionModel {
  bool? status;
  int? code;
  String? message;
  List<SessionsData>? body;

  SpeakerSessionModel({this.status, this.code, this.message, this.body});

  SpeakerSessionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['body'] != null) {
      body = <SessionsData>[];
      json['body'].forEach((v) {
        body!.add(new SessionsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (body != null) {
      data['body'] = body!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
