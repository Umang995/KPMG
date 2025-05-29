import 'package:get/get.dart';

class FeedDataModel {
  Body? body;
  bool? status;
  int? code;
  String? message;
  FeedDataModel({this.status, this.code, this.message, this.body});

  FeedDataModel.fromJson(Map<String, dynamic> json) {
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
  List<Posts>? posts;
  Filters? filters;
  bool? hasNextPage;

  Body({this.posts, this.filters, this.hasNextPage});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['posts'] != null) {
      posts = <Posts>[];
      json['posts'].forEach((v) {
        posts!.add(new Posts.fromJson(v));
      });
    }
    filters =
        json['filters'] != null ? new Filters.fromJson(json['filters']) : null;
    hasNextPage = json['hasNextPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.posts != null) {
      data['posts'] = this.posts!.map((v) => v.toJson()).toList();
    }
    if (this.filters != null) {
      data['filters'] = this.filters!.toJson();
    }
    data['hasNextPage'] = hasNextPage;

    return data;
  }
}

class Posts {
  bool showLikeButton = false;
  String? id;
  String? text;
  String? media;
  String? video; // Added new field for video
  String? type;
  bool? isPin; // Added new field for is_pin
  String? created;
  Emoticon? emoticon;
  Comment? comment;
  int? viewsCount;
  User? user;
  bool? isPlayVideo = false;

  var showPopup = false.obs;

  Posts({
    this.id,
    this.text,
    this.media,
    this.video, // Added new field for video
    this.type,
    this.isPin, // Added new field for is_pin
    this.created,
    this.emoticon,
    this.comment,
    this.user,
    this.viewsCount,
  });

  Posts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    media = json['media'];
    video = json['video']; // Initialize new field for video
    type = json['type'];
    isPin = json['is_pin']; // Initialize new field for is_pin
    viewsCount = json['views_count'];
    created = json['created'];
    emoticon =
        json['emoticon'] != null ? Emoticon.fromJson(json['emoticon']) : null;
    comment =
        json['comment'] != null ? Comment.fromJson(json['comment']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    data['media'] = media;
    data['video'] = video; // Serialize new field for video
    data['type'] = type;
    data['is_pin'] = isPin; // Serialize new field for is_pin
    data['views_count'] = viewsCount;
    data['created'] = created;
    if (emoticon != null) {
      data['emoticon'] = emoticon!.toJson();
    }
    if (comment != null) {
      data['comment'] = comment!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class Emoticon {
  bool isResponse = true;
  bool status = false;
  String? type;
  Total? total;
  List<String> emojiList = [];
  int count = 0;

  Emoticon({
    required this.status,
    this.type,
    this.total,
    required this.count,
  });

  Emoticon.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    type = json['type'];
    total = json['total'] != null ? Total.fromJson(json['total']) : null;
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
  int? like;
  int? love;
  int? care;
  int? haha;
  int? wow;
  int? sad;
  int? angry;
  int? clap;

  Total({
    this.like,
    this.love,
    this.care,
    this.haha,
    this.wow,
    this.sad,
    this.angry,
    this.clap,
  });

  Total.fromJson(Map<String, dynamic> json) {
    like = json['like'];
    love = json['love'];
    care = json['care'];
    haha = json['haha'];
    wow = json['wow'];
    sad = json['sad'];
    angry = json['angry'];
    clap = json['clap'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['like'] = like;
    data['love'] = love;
    data['care'] = care;
    data['haha'] = haha;
    data['wow'] = wow;
    data['sad'] = sad;
    data['angry'] = angry;
    data['clap'] = clap;
    return data;
  }

  // Helper method for dynamic access
  int? getReaction(String type) {
    switch (type) {
      case 'like':
        return like;
      case 'love':
        return love;
      case 'care':
        return care;
      case 'haha':
        return haha;
      case 'wow':
        return wow;
      case 'sad':
        return sad;
      case 'angry':
        return angry;
      case 'clap':
        return clap;
      default:
        return null;
    }
  }

  void setReaction(String type, int value) {
    switch (type) {
      case 'like':
        like = value;
        break;
      case 'love':
        love = value;
        break;
      case 'care':
        care = value;
        break;
      case 'haha':
        haha = value;
        break;
      case 'wow':
        wow = value;
        break;
      case 'sad':
        sad = value;
        break;
      case 'angry':
        angry = value;
        break;
      case 'clap':
        clap = value;
        break;
    }
  }
}

class Comment {
  int? total = 0;

  Comment({this.total});

  Comment.fromJson(Map<String, dynamic> json) {
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['short_name'] = shortName;
    data['avatar'] = avatar;
    return data;
  }
}

class Filters {
  int? page;
  String? type;

  Filters({this.page, this.type});

  Filters.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['type'] = type;
    return data;
  }
}
