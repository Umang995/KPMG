class QrScannedUserDetailsModel {
  bool? status;
  int? code;
  String? message;
  Data? body;

  QrScannedUserDetailsModel({this.status, this.code, this.message, this.body});

  QrScannedUserDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? new Data.fromJson(json['body']) : null;
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

class Data {
  String? avatar;
  String? shortName;
  String? name;
  String? company;
  String? position;
  String? email;
  String? mobile;

  Data(
      {this.avatar,
        this.shortName,
        this.name,
        this.company,
        this.position,
        this.email,
        this.mobile});

  Data.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    shortName = json['short_name'];
    name = json['name'];
    company = json['company'];
    position = json['position'];
    email = json['email'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['short_name'] = this.shortName;
    data['name'] = this.name;
    data['company'] = this.company;
    data['position'] = this.position;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    return data;
  }
}
