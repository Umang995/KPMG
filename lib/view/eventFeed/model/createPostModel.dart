class CreatePostModel {
  Body? body;
  bool? status;
  int? code;
  String? message;
  CreatePostModel({this.status, this.code, this.message, this.body});

  CreatePostModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
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

class Body {
  String? text;
  String? type;
  String? media;
  String? created;
  String? id;
  User? user;
  Emoticon? emoticon;
  Comment? comment;
  String? message;

  Body(
      {this.text,
      this.type,
      this.media,
      this.created,
      this.id,
      this.user,
      this.emoticon,
      this.comment,
      this.message});

  Body.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    type = json['type'];
    media = json['media'];
    created = json['created'];
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    emoticon = json['emoticon'] != null
        ? new Emoticon.fromJson(json['emoticon'])
        : null;
    comment =
        json['comment'] != null ? new Comment.fromJson(json['comment']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = text;
    data['type'] = type;
    data['media'] = media;
    data['created'] = created;
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (emoticon != null) {
      data['emoticon'] = emoticon!.toJson();
    }
    if (comment != null) {
      data['comment'] = comment!.toJson();
    }
    data['message'] = message;
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
    data['name'] = name;
    data['id'] = id;
    data['short_name'] = shortName;
    data['avatar'] = avatar;
    return data;
  }
}

class Emoticon {
  bool? status;
  String? type;
  Total? total;
  int? count;

  Emoticon({this.status, this.type, this.total, this.count});

  Emoticon.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    type = json['type'];
    total = json['total'] != null ? new Total.fromJson(json['total']) : null;
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['type'] = type;
    if (total != null) {
      data['total'] = total!.toJson();
    }
    data['count'] = count;
    return data;
  }
}

class Total {
  int? angry;
  int? clap;
  int? care;
  int? haha;
  int? like;
  int? love;
  int? sad;
  int? wow;

  Total(
      {this.angry,
      this.clap,
      this.care,
      this.haha,
      this.like,
      this.love,
      this.sad,
      this.wow});

  Total.fromJson(Map<String, dynamic> json) {
    angry = json['angry'];
    clap = json['clap'];
    care = json['care'];
    haha = json['haha'];
    like = json['like'];
    love = json['love'];
    sad = json['sad'];
    wow = json['wow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['angry'] = angry;
    data['clap'] = clap;
    data['care'] = care;
    data['haha'] = haha;
    data['like'] = like;
    data['love'] = love;
    data['sad'] = sad;
    data['wow'] = wow;
    return data;
  }
}

class Comment {
  int? total;

  Comment({this.total});

  Comment.fromJson(Map<String, dynamic> json) {
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = total;
    return data;
  }
}
