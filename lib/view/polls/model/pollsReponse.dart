class PollsSubmitModel {
  Body? body;
  bool? status;
  int? code;
  String? message;
  PollsSubmitModel({this.status, this.code, this.message,this.body});

  PollsSubmitModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
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
class Body {
  String? opinion;
  String? id;
  String? message;

  Body({this.id, this.opinion,this.message});

  Body.fromJson(Map<String, dynamic> json) {
    opinion = json['opinion'];
    id = json['id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['opinion'] = this.opinion;
    data['id'] = this.id;
    data['message'] = this.message;
    return data;
  }
}
