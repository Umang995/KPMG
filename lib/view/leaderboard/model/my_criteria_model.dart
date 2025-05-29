import 'criteriaModel.dart';

class MyCriteriaModel {
  bool? status;
  int? code;
  String? message;
  List<Criteria>? body;

  MyCriteriaModel({this.status, this.code, this.message, this.body});

  MyCriteriaModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['body'] != null) {
      body = <Criteria>[];
      json['body'].forEach((v) {
        body!.add(new Criteria.fromJson(v));
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

