
import 'package:dreamcast/view/partners/model/partnersModel.dart';

class PartnerDetailModel {
  Partner? body;
  bool? status;
  int? code;
  String? message;
  PartnerDetailModel({this.status, this.code, this.message, this.body});

  PartnerDetailModel.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? Partner.fromJson(json['body']) : null;
    status = json['status'];
    code = json['code'];
    message = json['message'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

