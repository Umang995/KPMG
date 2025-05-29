class CreateCommentModel {
  Body? body;
  bool? status;
  int? code;
  String? message;

  CreateCommentModel({this.status, this.code, this.message, this.body});

  CreateCommentModel.fromJson(Map<String, dynamic> json) {
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
  String? feedId;
  String? content;
  String? userId;
  dynamic status;
  String? id;
  String? created;
  User? user;

  Body(
      {this.feedId,
        this.content,
        this.userId,
        this.status,
        this.id,this.created,
        this.user});

  Body.fromJson(Map<String, dynamic> json) {
    feedId = json['feed_id'];
    content = json['content'];
    userId = json['user_id'];
    status = json['status'];
    id = json['id'];
    created = json['created'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['feed_id'] = this.feedId;
    data['content'] = this.content;
    data['user_id'] = this.userId;
    data['status'] = this.status;
    data['id'] = this.id;
    data['created'] = this.created;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? name;
  String? id;
  String? shortName;
  String? avatar;

  User({this.name, this.id, this.shortName, this.avatar});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    shortName = json['short_name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['short_name'] = this.shortName;
    data['avatar'] = this.avatar;
    return data;
  }
}
