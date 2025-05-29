class MyPhotoModel {
  bool? status;
  int? code;
  String? message;
  dynamic body;

  MyPhotoModel({this.status, this.code, this.message, this.body});

  MyPhotoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    data['body'] = this.body;
    return data;
  }
}

