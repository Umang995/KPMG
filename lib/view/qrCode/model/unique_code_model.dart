class UniqueCodeModel {
  Body? body;
  bool? status;
  int? code;
  String? message;
  UniqueCodeModel({this.status, this.code,this.message, this.body});

  UniqueCodeModel.fromJson(Map<String, dynamic> json) {
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
  String? message;
  String? code;

  Body({this.status, this.message, this.code});

  Body.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    code = json['qrcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['qrcode'] = this.code;
    return data;
  }
}
