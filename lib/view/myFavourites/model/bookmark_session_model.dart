import 'package:dreamcast/view/schedule/model/scheduleModel.dart';

class SessionBookmarkModel {
  Body? body;
  bool? status;
  int? code;
  SessionBookmarkModel({this.status, this.code, this.body});

  SessionBookmarkModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class Body {
  List<SessionsData>? bookmarks;
  bool? hasNextPage;
  Request? request;

  Body({this.bookmarks, this.hasNextPage, this.request});

  Body.fromJson(Map<String, dynamic> json) {
    /*if (json['favourites'] != null) {
      bookmarks = <SessionsData>[];
      json['favourites'].forEach((v) {
        bookmarks!.add(new SessionsData.fromJson(v));
      });
    }*/
    if (json['favourites'] != null) {
      bookmarks = <SessionsData>[];
      json['favourites'].forEach((v) {
        bookmarks!.add(SessionsData.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
    request =
    json['request'] != null ? new Request.fromJson(json['request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    /*if (this.bookmarks != null) {
      data['favourites'] = this.bookmarks!.map((v) => v.toJson()).toList();
    }*/
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
    data['page'] = page;
    data['sort'] = sort;
    return data;
  }
}
