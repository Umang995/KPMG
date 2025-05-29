class ChatRequestStatusModel {
  ChatRequestBody? body;
  bool? status;
  int? code;
  String? message;
  ChatRequestStatusModel({this.status, this.code, this.message, this.body});

  ChatRequestStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null
        ? new ChatRequestBody.fromJson(json['body'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class ChatRequestBody {
  String? id;
  int? status;
  String? text;
  User? user;
  String? iam;
  Node? node;

  ChatRequestBody(
      {this.id, this.status, this.text, this.user, this.iam, this.node});

  ChatRequestBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    text = json['text'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    iam = json['iam'];
    node = json['node'] != null ? new Node.fromJson(json['node']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['status'] = status;
    data['text'] = text;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['iam'] = iam;
    if (node != null) {
      data['node'] = node!.toJson();
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
    data['conversations'] = conversations;
    data['users'] = users;
    return data;
  }
}
