import 'package:get/get.dart';

import '../../speakers/model/speakersModel.dart';

class AngelAllyModel {
  Body? body;
  bool? status;
  int? code;
  AngelAllyModel({this.status, this.code, this.body});
  AngelAllyModel.fromJson(Map<String, dynamic> json) {
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
    if (json['sessions'] != null) {
      sessions = <AngelBody>[];
      json['sessions'].forEach((v) {
        sessions!.add(new AngelBody.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
    request =
        json['request'] != null ? Request.fromJson(json['request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (sessions != null) {
      data['sessions'] = sessions!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = hasNextPage;
    if (request != null) {
      data['request'] = request!.toJson();
    }
    return data;
  }
}

class AngelBody {
  var isLoading = false.obs;
  String? id;
  String? label;
  String? startDatetime;
  String? endDatetime;
  String? description;
  dynamic isBooked;

  AngelBody({
    this.id,
    this.label,
    this.startDatetime,
    this.endDatetime,
    this.description,
    this.isBooked,
  });

  AngelBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['name'];
    startDatetime = json['start_datetime'];
    endDatetime = json['end_datetime'];
    description = json['description'];
    isBooked = json['is_booked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = label;
    data['start_datetime'] = startDatetime;
    data['end_datetime'] = endDatetime;
    data['description'] = description;
    data['is_booked'] = isBooked;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search'] = search;
    data['page'] = page;
    data['sort'] = sort;
    return data;
  }
}
