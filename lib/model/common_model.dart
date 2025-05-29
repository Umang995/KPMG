class CommonModel {
  bool? status;
  int? code;
  String? message;
  dynamic body ;
  CommonModel({this.status, this.code, this.message, this.body});

  CommonModel.fromJson(Map<String, dynamic> json) {
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
    if (body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }

}
class Body {
  String? email;
  bool? status;
  String? message;

  Body({this.email,this.message});

  Body.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    email = json['email'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['email'] = this.email;
    data['message'] = this.message;

    return data;
  }
}
