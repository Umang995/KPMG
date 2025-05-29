import 'package:get/get.dart';

import '../../schedule/model/scheduleModel.dart';

class BestForYouDataModel {
  bool? status;
  int? code;
  String? message;
  Body? body;
  BestForYouDataModel({this.status, this.code, this.message, this.body});

  BestForYouDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
  List<AiUser>? user;
  List<SessionsData>? session;
  List<AiSpeaker>? speaker;
  Body({this.user, this.speaker, this.session});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['user'] != null) {
      user = <AiUser>[];
      json['user'].forEach((v) {
        user!.add(AiUser.fromJson(v));
      });
    }
    else if (json['speaker'] != null) {
      speaker = <AiSpeaker>[];
      json['speaker'].forEach((v) {
        speaker!.add(AiSpeaker.fromJson(v));
      });
    }
    else if (json['session'] != null) {
      session = <SessionsData>[];
      json['session'].forEach((v) {
        session!.add(SessionsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.map((v) => v.toJson()).toList();
    }
    else if (speaker != null) {
      data['speaker'] = speaker!.map((v) => v.toJson()).toList();
    }
    else if (session != null) {
      data['session'] = session!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class AiSpeaker {
  String? id;
  String? firstName;
  String? lastName;
  String? name;
  String? company;
  String? role;
  String? position;
  String? avatar;
  String? shortName;
  var isLoading = false.obs;

  AiSpeaker(
      {this.id,
      this.firstName,
      this.lastName,
      this.name,
      this.company,
      this.role,
      this.position,
      this.avatar,
      this.shortName});

  AiSpeaker.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    name = json['name'];
    company = json['company'];
    role = json['role'];
    position = json['position'];
    avatar = json['avatar'];
    shortName = json['short_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['name'] = name;
    data['company'] = company;
    data['role'] = role;
    data['position'] = position;
    data['avatar'] = avatar;
    data['short_name'] = shortName;

    return data;
  }
}

class AiUser {
  String? id;
  String? firstName;
  String? lastName;
  String? name;
  String? company;
  String? role;
  String? position;
  String? avatar;
  String? shortName;
  var isLoading = false.obs;

  AiUser(
      {this.id,
      this.firstName,
      this.lastName,
      this.name,
      this.company,
      this.role,
      this.position,
      this.avatar});

  AiUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    name = json['name'];
    company = json['company'];
    role = json['role'];
    position = json['position'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['name'] = name;
    data['company'] = company;
    data['role'] = role;
    data['position'] = position;
    data['avatar'] = avatar;
    return data;
  }
}

/*class AiSessionData {
  String? id;
  String? label;
  String? startDatetime;
  String? endDatetime;
  Status? status;

  AiSessionData(
      {this.id, this.label, this.startDatetime, this.endDatetime, this.status});

  AiSessionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['name'];
    startDatetime = json['start_datetime'];
    endDatetime = json['end_datetime'];
    status =
    json['status'] != null ? Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = label;
    data['start_datetime'] = startDatetime;
    data['end_datetime'] = endDatetime;
    if (status != null) {
      data['status'] = status!.toJson();
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['color'] = color;
    data['text'] = text;
    data['value'] = value;
    return data;
  }
}*/
