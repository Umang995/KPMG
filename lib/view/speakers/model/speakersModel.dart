import 'package:get/get.dart';

import '../../../widgets/az_listview/src/az_common.dart';

class SpeakersModel {
  Body? body;
  bool? status;
  int? code;
  SpeakersModel({this.status, this.code, this.body});

  SpeakersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class Body {
  List<SpeakersData>? representatives;
  bool? hasNextPage;
  Request? request;

  Body({this.representatives, this.hasNextPage, this.request});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      representatives = <SpeakersData>[];
      json['users'].forEach((v) {
        representatives!.add(new SpeakersData.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
    request =
        json['request'] != null ? new Request.fromJson(json['request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.representatives != null) {
      data['users'] = this.representatives!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = this.hasNextPage;
    if (this.request != null) {
      data['request'] = this.request!.toJson();
    }
    return data;
  }
}

class SpeakersData extends ISuspensionBean {
  String? id;
  String? name;
  String? shortName;
  String? company;
  String? position;
  dynamic avatar;
  String? role;
  String? timezone;
  dynamic category;
  String? favourite;
  String? type;
  dynamic isNotes;
  var isLoading = false.obs;
  String? tagIndex = "";

  SpeakersData(
      {this.id,
      this.name,
      this.shortName,
      this.company,
      this.position,
      this.avatar,
      this.role,
      this.timezone,
      this.category,
      this.favourite,
      this.type,
      this.isNotes});

  // Override equality operator
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is SpeakersData && other.id == id);

  // Override hashCode
  @override
  int get hashCode => id.hashCode /*^ name.hashCode*/;

  SpeakersData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortName = json['short_name'];
    company = json['company'];
    position = json['position'];
    avatar = json['avatar'];
    role = json['role'];
    timezone = json['timezone'];
    category = json['category'];
    favourite = json['favourite'];
    type = json['type'];
    isNotes = json['is_notes'];
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
    data['timezone'] = this.timezone;
    data['category'] = this.category;
    data['favourite'] = this.favourite;
    data['type'] = this.type;
    data['is_notes'] = this.isNotes;
    return data;
  }

  @override
  String getSuspensionTag() => tagIndex!;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search'] = this.search;
    data['page'] = this.page;
    data['sort'] = this.sort;
    return data;
  }
}
