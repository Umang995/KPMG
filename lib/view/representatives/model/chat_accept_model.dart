class ChatRequestAcceptModel {
  Body? body;
  bool? status;
  int? code;
  String? message;
  ChatRequestAcceptModel({this.status, this.code, this.message, this.body});

  ChatRequestAcceptModel.fromJson(Map<String, dynamic> json) {
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
  String? message;
  Room? room;

  Body({this.message, this.room});

  Body.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    room = json['room'] != null ? new Room.fromJson(json['room']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.room != null) {
      data['room'] = this.room!.toJson();
    }
    return data;
  }
}

class Room {
  String? id;
  int? status;
  String? text;
  User? user;
  String? iam;
  Node? node;

  Room({this.id, this.status, this.text, this.user, this.iam, this.node});

  Room.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    text = json['text'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    iam = json['iam'];
    node = json['node'] != null ? new Node.fromJson(json['node']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['text'] = this.text;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['iam'] = this.iam;
    if (this.node != null) {
      data['node'] = this.node!.toJson();
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

class Node {
  String? conversations;
  String? users;

  Node({this.conversations, this.users});

  Node.fromJson(Map<String, dynamic> json) {
    conversations = json['conversations'];
    users = json['users'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conversations'] = this.conversations;
    data['users'] = this.users;
    return data;
  }
}
