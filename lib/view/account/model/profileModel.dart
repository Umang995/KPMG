import 'createProfileModel.dart';

class ProfileModel {
  bool? status;
  int? code;
  String? message;
  ProfileBody? profileBody;

  ProfileModel({this.status, this.code, this.message, this.profileBody});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    profileBody =
        json['body'] != null ? new ProfileBody.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (profileBody != null) {
      data['body'] = profileBody!.toJson();
    }
    return data;
  }
}

class ProfileBody {
  String? id;
  String? name;
  String? firstName;
  String? lastName;
  String? shortName;
  String? company;
  String? position;
  String? avatar;
  String? role;
  String? timezone;
  String? status;
  int? isChat;
  int? isMeeting;
  int? isPublicProfile;
  int? muteNotification;
  String? website;
  String? interest;
  int? aiProfile;
  String? category;
  dynamic hasNote;
  dynamic isLoggedin;
  Info? info;
  Info? bio;
  Info? socialMedia;
  About? virtual;
  String? favourite;
  String? userNotes;
  String? speakerNotes;
  AIButton? aiButton;
  String? linkedin;

  ProfileBody(
      {this.id,
      this.name,
      this.firstName,
      this.lastName,
      this.shortName,
      this.company,
      this.position,
      this.avatar,
      this.role,
      this.timezone,
      this.status,
      this.isChat,
      this.isMeeting,
      this.isPublicProfile,
      this.muteNotification,
      this.website,
      this.interest,
      this.aiProfile,
      this.category,
      this.hasNote,
      this.isLoggedin,
      this.info,
      this.bio,
      this.socialMedia,
      this.virtual,
      this.favourite,
      this.userNotes,
      this.speakerNotes,
      this.aiButton,
      this.linkedin});

  ProfileBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    shortName = json['short_name'];
    company = json['company'];
    position = json['position'];
    avatar = json['avatar'];
    role = json['role'];
    timezone = json['timezone'];
    status = json['status'];
    isChat = json['is_chat'];
    isMeeting = json['is_meeting'];
    isPublicProfile = json['is_public_profile'];
    muteNotification = json['is_notification_mute'];
    website = json['website'];
    interest = json['interest'];
    aiProfile = json['ai_profile'];
    category = json['category'];
    hasNote = json['has_note'];
    isLoggedin = json['is_loggedin'];
    linkedin = json['linkedin'];

    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
    bio = json['bio'] != null ? new Info.fromJson(json['bio']) : null;
    socialMedia = json['social_media'] != null
        ? new Info.fromJson(json['social_media'])
        : null;
    virtual =
        json['virtual'] != null ? new About.fromJson(json['virtual']) : null;
    favourite = json['favourite'];

    aiButton = json['ai_button'] != null
        ? new AIButton.fromJson(json['ai_button'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['short_name'] = this.shortName;
    data['company'] = this.company;
    data['position'] = this.position;
    data['avatar'] = this.avatar;
    data['role'] = this.role;
    data['timezone'] = this.timezone;
    data['status'] = this.status;
    data['is_chat'] = this.isChat;
    data['is_meeting'] = this.isMeeting;
    data['is_public_profile'] = this.isPublicProfile;
    data['is_notification_mute'] = this.muteNotification;
    data['website'] = this.website;
    data['interest'] = this.interest;
    data['ai_profile'] = this.aiProfile;
    data['category'] = this.category;
    data['has_note'] = this.hasNote;
    data['is_loggedin'] = this.isLoggedin;
    if (info != null) {
      data['info'] = info!.toJson();
    }
    if (bio != null) {
      data['bio'] = bio!.toJson();
    }
    if (socialMedia != null) {
      data['social_media'] = socialMedia!.toJson();
    }
    if (virtual != null) {
      data['virtual'] = virtual!.toJson();
    }
    data['favourite'] = favourite;
    if (this.aiButton != null) {
      data['ai_button'] = this.aiButton!.toJson();
    }
    data['linkedin'] = this.linkedin;
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
    data['text'] = text;
    if (params != null) {
      data['params'] = params!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class About {
  String? label;
  List<Params>? params;

  About({this.label, this.params});

  About.fromJson(Map<String, dynamic> json) {
    label = json['text'];
    if (json['params'] != null) {
      params = <Params>[];
      json['params'].forEach((v) {
        params!.add(new Params.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = label;
    if (params != null) {
      data['params'] = params!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Params {
  String? label;
  dynamic value;

  Params({this.label, this.value});

  Params.fromJson(Map<String, dynamic> json) {
    label = json['text'];
    if (json['value'] is List) {
      value = json['value'].cast<String>();
    } else {
      value = json['value'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = label;
    data['value'] = value;
    return data;
  }
}
