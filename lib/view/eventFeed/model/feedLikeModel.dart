class LikeFeedModel {
  FeedLikeBody? body;
  bool? status;
  int? code;
  String? message;

  LikeFeedModel({this.status, this.code, this.message, this.body});

  LikeFeedModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body =
        json['body'] != null ? new FeedLikeBody.fromJson(json['body']) : null;
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

class FeedLikeBody {
  Like? like;
  Like? love;
  Like? care;
  Haha? haha;
  Like? wow;
  Like? sad;
  Like? angry;
  Like? clap;

  FeedLikeBody(
      {this.like,
      this.love,
      this.care,
      this.haha,
      this.wow,
      this.sad,
      this.angry,
      this.clap});

  FeedLikeBody.fromJson(Map<String, dynamic> json) {
    like = json['like'] != null ? new Like.fromJson(json['like']) : null;
    love = json['love'] != null ? new Like.fromJson(json['love']) : null;
    care = json['care'] != null ? new Like.fromJson(json['care']) : null;
    haha = json['haha'] != null ? new Haha.fromJson(json['haha']) : null;
    wow = json['wow'] != null ? new Like.fromJson(json['wow']) : null;
    sad = json['sad'] != null ? new Like.fromJson(json['sad']) : null;
    angry = json['angry'] != null ? new Like.fromJson(json['angry']) : null;
    clap = json['clap'] != null ? new Like.fromJson(json['clap']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.like != null) {
      data['like'] = this.like!.toJson();
    }
    if (this.love != null) {
      data['love'] = this.love!.toJson();
    }
    if (this.care != null) {
      data['care'] = this.care!.toJson();
    }
    if (this.haha != null) {
      data['haha'] = this.haha!.toJson();
    }
    if (this.wow != null) {
      data['wow'] = this.wow!.toJson();
    }
    if (this.sad != null) {
      data['sad'] = this.sad!.toJson();
    }
    if (this.angry != null) {
      data['angry'] = this.angry!.toJson();
    }
    if (this.clap != null) {
      data['clap'] = this.clap!.toJson();
    }
    return data;
  }
}

class Like {
  List<Emoticons>? emoticons;
  int? count;
  bool? active;

  Like({this.emoticons, this.count, this.active});

  Like.fromJson(Map<String, dynamic> json) {
    if (json['emoticons'] != null) {
      emoticons = <Emoticons>[];
      json['emoticons'].forEach((v) {
        emoticons!.add(new Emoticons.fromJson(v));
      });
    }
    count = json['count'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.emoticons != null) {
      data['emoticons'] = this.emoticons!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['active'] = this.active;
    return data;
  }
}

class Haha {
  List<Emoticons>? emoticons;
  int? count;
  bool? active;

  Haha({this.emoticons, this.count, this.active});

  Haha.fromJson(Map<String, dynamic> json) {
    if (json['emoticons'] != null) {
      emoticons = <Emoticons>[];
      json['emoticons'].forEach((v) {
        emoticons!.add(new Emoticons.fromJson(v));
      });
    }
    count = json['count'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.emoticons != null) {
      data['emoticons'] = this.emoticons!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['active'] = this.active;
    return data;
  }
}

class Emoticons {
  String? id;
  String? type;
  String? created;
  User? user;

  Emoticons({this.id, this.type, this.created, this.user});

  Emoticons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    created = json['created'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['created'] = this.created;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? name;
  String? avatar;
  String? shortName;
  String? company;
  String? position;

  User({this.name, this.avatar, this.shortName});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    avatar = json['avatar'];
    shortName = json['short_name'];
    position = json['position'];
    company = json['company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['short_name'] = this.shortName;
    data['company'] = this.company;
    data['position'] = this.position;
    return data;
  }
}
