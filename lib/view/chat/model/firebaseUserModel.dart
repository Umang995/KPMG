class FirebaseUserModel {
  Head? head;
  List<UserData>? userData;

  FirebaseUserModel({this.head, this.userData});

  FirebaseUserModel.fromJson(Map<String, dynamic> json) {
    head = json['head'] != null ? new Head.fromJson(json['head']) : null;
    if (json['body'] != null) {
      userData = <UserData>[];
      json['body'].forEach((v) {
        userData!.add(new UserData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.head != null) {
      data['head'] = this.head!.toJson();
    }
    if (this.userData != null) {
      data['body'] = this.userData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Head {
  bool? status;
  int? code;
  String? message;

  Head({this.status, this.code, this.message});

  Head.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}

class UserData {
  String? id;
  String? name;
  String? shortName;
  String? company;
  String? position;
  String? avatar;
  String? role;
  String? vendor;
  String? timezone;

  UserData(
      {this.id,
        this.name,
        this.shortName,
        this.company,
        this.position,
        this.avatar,
        this.role,
        this.vendor,
        this.timezone});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortName = json['short_name'];
    company = json['company'];
    position = json['position'];
    avatar = json['avatar'];
    role = json['role'];
    vendor = json['vendor'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['short_name'] = this.shortName;
    data['company'] = this.company;
    data['position'] = this.position;
    data['avatar'] = this.avatar;
    data['role'] = this.role;
    data['vendor'] = this.vendor;
    data['timezone'] = this.timezone;
    return data;
  }
}
