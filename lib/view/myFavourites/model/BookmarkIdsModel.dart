class BookmarkIdsModel {
  bool? status;
  int? code;
  String? message;
  List<Body>? body;

  BookmarkIdsModel({this.status, this.code, this.message, this.body});

  BookmarkIdsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['body'] != null) {
      body = <Body>[];
      json['body'].forEach((v) {
        body!.add(new Body.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (body != null) {
      data['body'] = body!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Body {
  String? favourite;
  String? id;
  bool? isRecommended;
  String? isBlocked;


  Body({this.favourite, this.id,this.isRecommended});

  Body.fromJson(Map<String, dynamic> json) {
    favourite = json['favourite'];
    id = json['id'];
    isRecommended = json['recommended'];
    isBlocked = json['is_blocked'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['favourite'] = favourite;
    data['id'] = id;
    data['recommended'] = isRecommended;
    data['is_blocked'] = isBlocked;
    return data;
  }
}
