class ColleaguesModel {
  Head? head;
  Body? body;

  ColleaguesModel({this.head, this.body});

  ColleaguesModel.fromJson(Map<String, dynamic> json) {
    head = json['head'] != null ? new Head.fromJson(json['head']) : null;
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (head != null) {
      data['head'] = head!.toJson();
    }
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class Head {
  bool? status;
  int? code;

  Head({this.status, this.code});

  Head.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    return data;
  }
}

class Body {
  List<ColleaguesUser>? userList;
  Body({this.userList});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['user'] != null) {
      userList = <ColleaguesUser>[];
      json['user'].forEach((v) {
        userList!.add(new ColleaguesUser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (userList != null) {
      data['user'] = userList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ColleaguesUser {
  String? id;
  String? name;
  String? shortName;
  String? company;
  String? position;
  String? avatar;
  String? role;
  String? timezone;
  String? accessType;

  ColleaguesUser(
      {this.id,
        this.name,
        this.shortName,
        this.company,
        this.position,
        this.avatar,
        this.role,
        this.timezone,
        this.accessType});

  ColleaguesUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortName = json['short_name'];
    company = json['company'];
    position = json['position'];
    avatar = json['avatar'];
    role = json['role'];
    timezone = json['timezone'];
    accessType = json['access_type'];
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
    data['access_type'] = accessType;
    return data;
  }
}

