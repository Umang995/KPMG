class ProfileUpdateModel {
  Body? body;
  bool? status;
  int? code;
  String? message;
  ProfileUpdateModel({this.status, this.code,this.message});

  ProfileUpdateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
  dynamic status;
  String? message;
  String? company;
  String? mobile;
  String? website;
  String? email;
  int? isChat;
  int? isMeeting;
  int? isPublic;
  String? avatar;

  Body({this.status, this.message,
  this.company,this.mobile,this.website,this.email,
  this.isChat,this.isMeeting,this.isPublic,this.avatar});

  Body.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    company = json['company'];
    mobile = json['mobile'];
    website = json['website'];
    email = json['email'];
    isChat = json['is_chat'];
    isMeeting = json['is_meeting'];
    isPublic = json['is_public_profile'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['company'] = company;
    data['mobile'] = mobile;
    data['website'] = website;
    data['email'] = email;
    data['is_chat'] = isChat;
    data['is_meeting'] = isMeeting;
    data['is_public_profile'] = isPublic;
    data['avatar'] = avatar;
    return data;
  }
}
