

import 'meeting_model.dart';

class MeetingDetailModel {
  Meetings? body;
  bool? status;
  int? code;
  String? message;
  MeetingDetailModel({this.status,this.code,this.message, this.body});

  MeetingDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];    body = json['body'] != null ? new Meetings.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

