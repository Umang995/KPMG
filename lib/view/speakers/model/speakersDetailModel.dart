import 'package:get/get.dart';

import '../../schedule/model/scheduleModel.dart';

class SpeakersDetailModel {
  bool? status;
  int? code;
  String? message;
  UserDetailBody? body;

  SpeakersDetailModel({this.status, this.code, this.message, this.body});

  SpeakersDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body =
        json['body'] != null ? new UserDetailBody.fromJson(json['body']) : null;
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

class UserDetailBody {
  String? favourite;
  String? id;
  String? name;
  String? shortName;
  String? company;
  String? position;
  String? avatar;
  String? role;
  String? timezone;
  String? status;
  int? isChat;
  int? isMeeting;
  dynamic isBlocked;
  String? keyword;
  String? category;
  dynamic isLoggedin;
  Bio? bio;
  Bio? socialMedia;
  Virtual? virtual;
  int? aiProfile;


  UserDetailBody(
      {this.favourite,
      this.id,
      this.name,
      this.shortName,
      this.company,
      this.position,
      this.avatar,
      this.role,
      this.timezone,
      this.status,
      this.isChat,
      this.isMeeting,
      this.keyword,
      this.category,
      this.isBlocked,
      this.isLoggedin,
      this.bio,
      this.socialMedia,
      this.virtual,this.aiProfile});

  UserDetailBody.fromJson(Map<String, dynamic> json) {
    favourite = json['favourite'];
    id = json['id'];
    name = json['name'];
    shortName = json['short_name'];
    company = json['company'];
    position = json['position'];
    avatar = json['avatar'];
    role = json['role'];
    timezone = json['timezone'];
    status = json['status'];
    isChat = json['is_chat'];
    isMeeting = json['is_meeting'];
    keyword = json['keyword'];
    category = json['category'];
    isBlocked = json['is_blocked'];
    isLoggedin = json['is_loggedin'];
    aiProfile=json['ai_profile'];

    bio = json['bio'] != null ? new Bio.fromJson(json['bio']) : null;
    socialMedia = json['social_media'] != null
        ? new Bio.fromJson(json['social_media'])
        : null;
    virtual =
        json['virtual'] != null ? new Virtual.fromJson(json['virtual']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['favourite'] = this.favourite;
    data['id'] = this.id;
    data['name'] = this.name;
    data['short_name'] = this.shortName;
    data['company'] = this.company;
    data['position'] = this.position;
    data['avatar'] = this.avatar;
    data['role'] = this.role;
    data['timezone'] = this.timezone;
    data['status'] = this.status;
    data['is_chat'] = this.isChat;
    data['is_meeting'] = this.isMeeting;
    data['keyword'] = this.keyword;
    data['category'] = this.category;
    data['is_blocked'] = this.isBlocked;
    data['is_loggedin'] = this.isLoggedin;
    data['ai_profile']=this.aiProfile;

    if (this.socialMedia != null) {
      data['social_media'] = this.socialMedia!.toJson();
    }
    if (this.bio != null) {
      data['bio'] = this.bio!.toJson();
    }
    if (this.virtual != null) {
      data['virtual'] = this.virtual!.toJson();
    }
    return data;
  }
}

class Bio {
  String? text;
  List<Params>? params;

  Bio({this.text, this.params});

  Bio.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    if (json['params'] != null) {
      params = <Params>[];
      json['params'].forEach((v) {
        params!.add(new Params.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    if (this.params != null) {
      data['params'] = this.params!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Params {
  String? text;
  dynamic value;

  Params({this.text, this.value});

  Params.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['value'] = this.value;
    return data;
  }
}

class Virtual {
  String? label;
  List<BasicParams>? virtualParams;

  Virtual({this.label, this.virtualParams});

  Virtual.fromJson(Map<String, dynamic> json) {
    label = json['text'];
    if (json['params'] != null) {
      virtualParams = <BasicParams>[];
      json['params'].forEach((v) {
        virtualParams!.add(new BasicParams.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.label;
    if (this.virtualParams != null) {
      data['params'] = this.virtualParams!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BasicParams {
  String? label;
  dynamic value;

  BasicParams({this.label, this.value});

  BasicParams.fromJson(Map<String, dynamic> json) {
    label = json['text'];
    if (json['value'] is String) {
      value = json['value'];
    } else {
      value = json['value'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.label;
    data['value'] = this.value;
    return data;
  }
}
