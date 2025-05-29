import 'package:dreamcast/view/schedule/model/scheduleModel.dart';
import 'package:get/get.dart';

import 'angelAllyModel.dart';

class AngelAllyDetailModel {
  Body? body;
  bool? status;
  int? code;
  AngelAllyDetailModel({this.status, this.code, this.body});
  AngelAllyDetailModel.fromJson(Map<String, dynamic> json) {
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
  List<AngelBody>? sessions;
  bool? hasNextPage;
  Request? request;

  Body({
    this.sessions,
    this.hasNextPage,
    this.request,
  });

  Body.fromJson(Map<String, dynamic> json) {
    if (json['webinars'] != null) {
      sessions = <AngelBody>[];
      json['webinars'].forEach((v) {
        sessions!.add(AngelBody.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
    request =
    json['request'] != null ? new Request.fromJson(json['request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (sessions != null) {
      data['webinars'] = sessions!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = hasNextPage;
    if (request != null) {
      data['request'] = request!.toJson();
    }
    return data;
  }
}

class Status {
  String? color;
  String? text;
  int? value;

  Status({this.color, this.text, this.value});

  Status.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    text = json['text'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['color'] = color;
    data['text'] = text;
    data['value'] = value;
    return data;
  }
}


class Request {
  String? search;
  dynamic page;
  String? sort;

  Request({this.search, this.page, this.sort});

  Request.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    page = json['page'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['search'] = search;
    data['page'] = page;
    data['sort'] = sort;
    return data;
  }
}
