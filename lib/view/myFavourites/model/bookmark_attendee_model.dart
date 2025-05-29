class BookmarkAttendeeModel {
  Head? head;
  Body? body;

  BookmarkAttendeeModel({this.head, this.body});

  BookmarkAttendeeModel.fromJson(Map<String, dynamic> json) {
    head = json['head'] != null ? new Head.fromJson(json['head']) : null;
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.head != null) {
      data['head'] = this.head!.toJson();
    }
    if (this.body != null) {
      data['body'] = this.body!.toJson();
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
    data['status'] = this.status;
    data['code'] = this.code;
    return data;
  }
}

class Body {
  List<BookmarksAttendee>? bookmarks;
  bool? hasNextPage;
  Request? request;

  Body({this.bookmarks, this.hasNextPage, this.request});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['bookmarks'] != null) {
      bookmarks = <BookmarksAttendee>[];
      json['bookmarks'].forEach((v) {
        bookmarks!.add(new BookmarksAttendee.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
    request =
    json['request'] != null ? new Request.fromJson(json['request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bookmarks != null) {
      data['bookmarks'] = this.bookmarks!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = this.hasNextPage;
    if (this.request != null) {
      data['request'] = this.request!.toJson();
    }
    return data;
  }
}

class BookmarksAttendee {
  String? id;
  User? user;

  BookmarksAttendee({this.id, this.user});

  BookmarksAttendee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
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
  String? timezone;
  dynamic? accessType;

  User(
      {this.id,
        this.name,
        this.shortName,
        this.company,
        this.position,
        this.avatar,
        this.role,
        this.timezone,
        this.accessType});

  User.fromJson(Map<String, dynamic> json) {
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
    data['id'] = this.id;
    data['name'] = this.name;
    data['short_name'] = this.shortName;
    data['company'] = this.company;
    data['position'] = this.position;
    data['avatar'] = this.avatar;
    data['role'] = this.role;
    data['timezone'] = this.timezone;
    data['access_type'] = this.accessType;
    return data;
  }
}

class Request {
  String? page;
  String? sort;

  Request({this.page, this.sort});

  Request.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['sort'] = this.sort;
    return data;
  }
}
