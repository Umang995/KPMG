class VideoModel {
  Head? head;
  Body? body;

  VideoModel({this.head, this.body});

  VideoModel.fromJson(Map<String, dynamic> json) {
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
  String? message;

  Head({this.status, this.code, this.message});

  Head.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}

class Body {
  List<Guides>? guides;
  bool? hasNextPage;
  Request? request;

  Body({this.guides, this.hasNextPage, this.request});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['video'] != null) {
      guides = <Guides>[];
      json['video'].forEach((v) {
        guides!.add(new Guides.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
    request =
    json['request'] != null ? new Request.fromJson(json['request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.guides != null) {
      data['video'] = this.guides!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = this.hasNextPage;
    if (this.request != null) {
      data['request'] = this.request!.toJson();
    }
    return data;
  }
}

class Guides {
  String? id;
  String? label;
  String? media;
  String? thumbnail;
  String? mediaType;
  String? bookmark;

  Guides(
      {this.id,
        this.label,
        this.media,
        this.thumbnail,
        this.mediaType,
        this.bookmark});

  Guides.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    media = json['media'];
    thumbnail = json['thumbnail'];
    mediaType = json['media_type'];
    bookmark = json['bookmark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    data['media'] = this.media;
    data['thumbnail'] = this.thumbnail;
    data['media_type'] = this.mediaType;
    data['bookmark'] = this.bookmark;
    return data;
  }
}

class Request {
  int? page;

  Request({this.page});

  Request.fromJson(Map<String, dynamic> json) {
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    return data;
  }
}