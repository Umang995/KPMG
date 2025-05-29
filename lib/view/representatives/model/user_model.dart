import 'package:get/get.dart';

import '../../../widgets/az_listview/src/az_common.dart';

class RepresentativeModel {
  Body? body;
  bool? status;
  int? code;

  RepresentativeModel({this.body, this.status, this.code});

  RepresentativeModel.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
    status = json['status'];
    code = json['code'];
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
  List<Representatives>? representatives;
  bool? hasNextPage;
  Request? request;

  Body({this.representatives, this.hasNextPage, this.request});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      representatives = <Representatives>[];
      json['users'].forEach((v) {
        representatives!.add(new Representatives.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
    request =
        json['request'] != null ? new Request.fromJson(json['request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (representatives != null) {
      data['users'] = representatives!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = hasNextPage;
    if (request != null) {
      data['request'] = request!.toJson();
    }
    return data;
  }
}

class Representatives extends ISuspensionBean {
  String? id;
  String? name;
  String? shortName;
  String? company;
  String? position;
  String? avatar;
  String? role;
  String? timezone;
  String? bookmark;
  dynamic status;
  dynamic isBlocked;
  dynamic category;
  dynamic isLoggedin;
  dynamic isNotes;
  String? tagIndex = "";
  var isLoading = false.obs;

  Representatives(
      {this.id,
      this.name,
      this.shortName,
      this.company,
      this.position,
      this.avatar,
      this.role,
      this.timezone,
      this.bookmark,
      this.status,
      this.isBlocked,
      this.category,
      this.isLoggedin,
      this.isNotes});

  // Override equality operator
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Representatives && other.id == id);

  // Override hashCode
  @override
  int get hashCode => id.hashCode;

  Representatives.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortName = json['short_name'];
    company = json['company'];
    position = json['position'];
    avatar = json['avatar'];
    role = json['role'];
    timezone = json['timezone'];
    bookmark = json['bookmark'];
    status = json['status'];
    isBlocked = json['is_blocked'];
    category = json['category'];
    isLoggedin = json['is_loggedin'];
    isNotes = json['is_notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['short_name'] = shortName;
    data['company'] = company;
    data['position'] = position;
    data['avatar'] = avatar;
    data['role'] = role;
    data['timezone'] = timezone;
    data['bookmark'] = bookmark;
    data['status'] = status;
    data['is_blocked'] = isBlocked;
    data['category'] = category;
    data['is_loggedin'] = isLoggedin;
    data['is_notes'] = isNotes;
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
    data['search'] = search;
    data['page'] = page;
    data['sort'] = sort;
    return data;
  }
}
