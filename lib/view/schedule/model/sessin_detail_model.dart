import 'package:dreamcast/view/schedule/model/scheduleModel.dart';
import 'package:get/get.dart';

class SessionDetailModel {
  SessionsData? body;
  bool? status;
  int? code;
  SessionDetailModel({this.status, this.code, this.body});
  SessionDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    body = json['body'] != null ? new SessionsData.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

