class UserModelModel {
  Body? body;
  bool? status;
  int? code;
  UserModelModel({this.status, this.code, this.body});

  UserModelModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class Body {
  bool? status;
  Data? data;

  Body({this.status, this.data});

  Body.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  dynamic id;
  String? name;
  String? email;
  String? shortName;
  String? company;
  String? position;
  String? mobile;

  Data({this.id, this.name, this.email, this.shortName, this.company,this.position});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    shortName = json['short_name'];
    company = json['company'];
    position=json['position'];
    mobile=json['mobile'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['short_name'] = shortName;
    data['company'] = company;
    data['position']=position;
    data['mobile']=mobile;
    return data;
  }
}
