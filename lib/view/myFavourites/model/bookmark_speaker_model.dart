import 'package:get/get.dart';

class BookmarkSpeakerModel {
  Body? body;
  bool? status;
  int? code;

  BookmarkSpeakerModel({this.status, this.code, this.body});

  BookmarkSpeakerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class Body {
  List<BookmarksRepresentative>? bookmarks;
  bool? hasNextPage;
  Request? request;

  Body({this.bookmarks, this.hasNextPage, this.request});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['favourites'] != null) {
      bookmarks = <BookmarksRepresentative>[];
      json['favourites'].forEach((v) {
        bookmarks!.add(new BookmarksRepresentative.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
    request =
    json['request'] != null ? new Request.fromJson(json['request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bookmarks != null) {
      data['favourites'] = bookmarks!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = hasNextPage;
    if (request != null) {
      data['request'] = request!.toJson();
    }
    return data;
  }
}

class BookmarksRepresentative {
  String? id;
  User? user;

  BookmarksRepresentative({this.id, this.user});

  BookmarksRepresentative.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  var isLoading=false.obs;
  String? id;
  String? name;
  String? shortName;
  String? company;
  String? position;
  dynamic avatar;
  String? role;
  String? vendor;
  String? timezone;
  String? favourite;
  String? type;
  String? hasNote;


  User(
      {this.id,
        this.name,
        this.shortName,
        this.company,
        this.position,
        this.avatar,
        this.role,
        this.vendor,
        this.timezone,
        this.favourite,this.type});

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
    favourite = json['favourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['short_name'] = shortName;
    data['company'] = company;
    data['position'] = position;
    data['avatar'] = avatar;
    data['role'] = role;
    data['vendor'] = vendor;
    data['timezone'] = timezone;
    data['favourite'] = favourite;
    return data;
  }
}

class Request {
  dynamic page;
  String? sort;

  Request({this.page, this.sort});

  Request.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['sort'] = sort;
    return data;
  }
}
