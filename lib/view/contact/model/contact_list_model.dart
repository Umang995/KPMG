import 'package:get/get.dart';

import '../../../widgets/az_listview/src/az_common.dart';

class ContactListModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  ContactListModel({this.status, this.code, this.message, this.body});

  ContactListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
  List<Contacts>? contacts;
  bool? hasNextPage;

  Body({this.contacts, this.hasNextPage});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      contacts = <Contacts>[];
      json['items'].forEach((v) {
        contacts!.add(new Contacts.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.contacts != null) {
      data['items'] = this.contacts!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = this.hasNextPage;
    return data;
  }
}

class Contacts {
  String? avatar;
  String? shortName;
  String? name;
  String? company;
  String? position;
  String? email;
  String? mobile;
  String? id;
  String? type;
  String? role;

  Contacts(
      {this.avatar,
        this.shortName,
        this.name,
        this.company,
        this.position,
        this.email,
        this.mobile,
        this.id,
        this.role,
        this.type});

  Contacts.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    shortName = json['short_name'];
    name = json['name'];
    company = json['company'];
    position = json['position'];
    email = json['email'];
    mobile = json['mobile'];
    id = json['id'];
    type = json['type'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['avatar'] = this.avatar;
    data['short_name'] = this.shortName;
    data['name'] = this.name;
    data['company'] = this.company;
    data['position'] = this.position;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['id'] = this.id;
    data['type'] = this.type;
    data['role'] = this.role;
    return data;
  }
}

class Request {
  String? search;
  dynamic page;
  String? sort;

  Request({this.search, this.page, this.sort});

  Request.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    page = json['page'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['search'] = this.search;
    data['page'] = this.page;
    data['sort'] = this.sort;
    return data;
  }
}