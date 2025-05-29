class FeedCommentModel {
  Body? body;
  bool? status;
  int? code;
  String? message;

  FeedCommentModel({this.status, this.code, this.message, this.body});

  FeedCommentModel.fromJson(Map<String, dynamic> json) {
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
  List<Comments>? comments;
  bool? hasNextPage;


  Body({this.comments,this.hasNextPage});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = this.hasNextPage;

    return data;
  }
}

class Comments {
  bool? isPost=false;
  String? id;
  String? content;
  String? created;
  UserData? user;

  Comments({this.isPost,this.id, this.content, this.created, this.user});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    created = json['created'];
    user = json['user'] != null ? new UserData.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['content'] = this.content;
    data['created'] = this.created;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class UserData {
  String? name;
  String? id;
  String? shortName;
  String? avatar;

  UserData({this.name, this.id, this.shortName, this.avatar});

  UserData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    shortName = json['short_name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = this.name;
    data['id'] = this.id;
    data['short_name'] = this.shortName;
    data['avatar'] = this.avatar;
    return data;
  }
}
