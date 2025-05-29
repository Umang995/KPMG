class LoginResponseModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  LoginResponseModel({this.status, this.code, this.message, this.body});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
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

class Body {
  int? status;
  bool? isExhibitor;
  int? hasProfileUpdate;
  String? id;
  String? name;
  String? shortName;
  String? company;
  String? position;
  dynamic avatar;
  String? role;
  String? vendor;
  String? timezone;
  String? parentId;
  String? mobile;
  String? token;
  dynamic accessToken;
  String? email;
  int? isChat;
  int? isMeeting;
  dynamic exhibitorType;

  Body(
      {this.status,
      this.isExhibitor,
      this.hasProfileUpdate,
      this.id,
      this.name,
      this.shortName,
      this.company,
      this.position,
      this.avatar,
      this.role,
      this.vendor,
      this.timezone,
      this.parentId,
      this.mobile,
      this.token,
      this.accessToken,
      this.email,
      this.isChat,
      this.isMeeting,
      this.exhibitorType});

  Body.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    isExhibitor = json['is_exhibitor'];
    hasProfileUpdate = json['has_profile_update'];
    id = json['id'];
    name = json['name'];
    shortName = json['short_name'];
    company = json['company'];
    position = json['position'];
    avatar = json['avatar'];
    role = json['role'];
    vendor = json['vendor'];
    timezone = json['timezone'];
    parentId = json['parent_id'];
    mobile = json['mobile'];
    token = json['token'];
    email = json['email'];
    accessToken = json['access_token'];
    isChat = json['is_chat'];
    isMeeting = json['is_meeting'];
    exhibitorType = json['exhibitor_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['is_exhibitor'] = this.isExhibitor;
    data['has_profile_update'] = this.hasProfileUpdate;
    data['id'] = this.id;
    data['name'] = this.name;
    data['short_name'] = this.shortName;
    data['company'] = this.company;
    data['position'] = this.position;
    data['avatar'] = this.avatar;
    data['role'] = this.role;
    data['vendor'] = this.vendor;
    data['timezone'] = this.timezone;
    data['parent_id'] = this.parentId;
    data['mobile'] = this.mobile;
    data['token'] = this.token;
    data['email'] = this.email;
    data['access_token'] = this.accessToken;
    data['is_chat'] = this.isChat;
    data['is_meeting'] = this.isMeeting;
    data['exhibitor_type'] = this.exhibitorType;
    return data;
  }
}
