import '../../../account/model/createProfileModel.dart';

class StateResponseModel {
  List<Options>? body;
  bool? status;
  int? code;
  String? message;

  StateResponseModel({this.status, this.code, this.message, this.body});

  StateResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['body'] != null) {
      body = <Options>[];
      json['body'].forEach((v) {
        body!.add(new Options.fromJson(v));
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

