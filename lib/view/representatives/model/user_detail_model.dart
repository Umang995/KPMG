class UserDetailModel {
  bool? status;
  int? code;
  String? message;
  UserDetailBody? body;

  UserDetailModel({this.status, this.code, this.message, this.body});

  UserDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? UserDetailBody.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
  String? id;
  String? role;
  String? shortName;
  String? name;
  String? company;
  String? position;
  dynamic interest;
  dynamic avatar;
  String? description;
  String? linkedin;
  String? facebook;
  String? twitter;
  dynamic website;
  String? timezone;
  int? isChat;
  int? isMeeting;
  int? isPublicProfile;
  int? aiProfile;
  dynamic isBlocked;
  dynamic insights;
  dynamic keyword;
  Info? info;
  Info? bio;
  Info? socialMedia;
  Virtual? virtual;
  String? favourite;

  UserDetailBody(
      {this.id,
      this.role,
      this.shortName,
      this.name,
      this.company,
      this.position,
      this.interest,
      this.avatar,
      this.description,
      this.linkedin,
      this.facebook,
      this.twitter,
      this.website,
      this.timezone,
      this.isChat,
      this.isMeeting,
      this.isPublicProfile,
      this.insights,
      this.keyword,
      this.info,
      this.bio,
      this.socialMedia,
      this.virtual,
      this.favourite,
      this.isBlocked,this.aiProfile});

  UserDetailBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    shortName = json['short_name'];
    name = json['name'];
    company = json['company'];
    position = json['position'];
    interest = json['interest'];
    avatar = json['avatar'];
    description = json['description'];
    linkedin = json['linkedin'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    website = json['website'];
    timezone = json['timezone'];
    isChat = json['is_chat'];
    isMeeting = json['is_meeting'];
    isPublicProfile = json['is_public_profile'];
    aiProfile=json['ai_profile'];
    insights = json['insights'];
    keyword = json['interest'];
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
    bio = json['bio'] != null ? new Info.fromJson(json['bio']) : null;
    socialMedia = json['social_media'] != null
        ? new Info.fromJson(json['social_media'])
        : null;
    virtual = json['virtual'] != null
        ? new Virtual.fromJson(json['virtual'])
        : null;
    favourite = json['favourite'];
    isBlocked = json['is_blocked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role'] = this.role;
    data['short_name'] = this.shortName;
    data['name'] = this.name;
    data['company'] = this.company;
    data['position'] = this.position;
    data['interest'] = this.interest;
    data['avatar'] = this.avatar;
    data['description'] = this.description;
    data['linkedin'] = this.linkedin;
    data['facebook'] = this.facebook;
    data['twitter'] = this.twitter;
    data['website'] = this.website;
    data['timezone'] = this.timezone;
    data['is_chat'] = this.isChat;
    data['ai_profile']=this.aiProfile;
    data['is_meeting'] = this.isMeeting;
    data['is_public_profile'] = this.isPublicProfile;
    data['insights'] = this.insights;
    data['interest'] = this.keyword;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    if (this.bio != null) {
      data['bio'] = this.bio!.toJson();
    }
    if (this.socialMedia != null) {
      data['social_media'] = this.socialMedia!.toJson();
    }
    if (this.virtual != null) {
      data['virtual'] = this.virtual!.toJson();
    }
    data['favourite'] = this.favourite;
    data['is_blocked'] = this.isBlocked;
    return data;
  }
}

class Info {
  String? text;
  List<Params>? params;

  Info({this.text, this.params});

  Info.fromJson(Map<String, dynamic> json) {
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
  List<VirtualParams>? params;

  Virtual({this.label, this.params});

  Virtual.fromJson(Map<String, dynamic> json) {
    label = json['text'];
    if (json['params'] != null) {
      params = <VirtualParams>[];
      json['params'].forEach((v) {
        params!.add(VirtualParams.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['text'] = this.label;
    if (this.params != null) {
      data['params'] = this.params!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VirtualParams {
  String? label;
  dynamic value;

  VirtualParams({this.label, this.value});

  VirtualParams.fromJson(Map<String, dynamic> json) {
    label = json['text'];
    value = json['value'] is String?json['value']:json['value'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['text'] = this.label;
    data['value'] = this.value;
    return data;
  }
}
