class PostLikeModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  PostLikeModel({this.status, this.code, this.message, this.body});

  PostLikeModel.fromJson(Map<String, dynamic> json) {
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
  bool? status;
  bool? toggle;
  int? count;

  Body({this.status, this.toggle, this.count});

  Body.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    toggle = json['toggle'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['toggle'] = this.toggle;
    data['count'] = this.count;
    return data;
  }
}