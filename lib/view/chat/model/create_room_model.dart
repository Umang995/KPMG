class CreateRoomModel {
  Body? body;
  int? code;
  bool? status;

  CreateRoomModel({this.body,this.code, this.status});

  factory CreateRoomModel.fromJson(Map<String, dynamic> json) {
    return CreateRoomModel(
      body: json['body'] != null ? Body.fromJson(json['body']) : null,
      code: json['code'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (body != null) {
      data['body'] = body!.toJson();
    }
    data['code'] = code;
    data['status'] = status;
    return data;
  }
}

class Body {
  String? message;
  Room? room;

  Body({this.message, this.room});

  Body.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    room = json['room'] != null ? new Room.fromJson(json['room']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = message;
    if (room != null) {
      data['room'] = room!.toJson();
    }
    return data;
  }
}

class Room {
  String? text;
  int? status;
  String? id;
  String? iam;
  User? user;

  Room({this.text, this.status, this.id, this.iam, this.user});

  Room.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    status = json['status'];
    id = json['id'];
    iam = json['iam'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = text;
    data['status'] = status;
    data['id'] = id;
    data['iam'] = iam;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? shortName;
  String? company;
  String? position;
  String? avatar;
  String? role;
  String? vendor;
  String? timezone;

  User(
      {this.id,
        this.name,
        this.shortName,
        this.company,
        this.position,
        this.avatar,
        this.role,
        this.vendor,
        this.timezone});

  User.fromJson(Map<String, dynamic> json) {
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
    data['id'] = id;
    data['name'] = name;
    data['short_name'] = shortName;
    data['company'] = company;
    data['position'] = position;
    data['avatar'] = avatar;
    data['role'] = role;
    data['vendor'] = vendor;
    data['timezone'] = timezone;
    return data;
  }
}