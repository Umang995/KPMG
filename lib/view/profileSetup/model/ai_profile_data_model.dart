class AiProfileDataModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  AiProfileDataModel({this.status, this.code, this.message, this.body});

  AiProfileDataModel.fromJson(Map<String, dynamic> json) {
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
  String? description;
  String? avatar;
  dynamic interested;
  String? company;
  String? position;
  String? linkedin;
  String? insights;

  Body(
      {this.description,
        this.avatar,
        this.interested,
        this.company,
        this.position,
        this.linkedin,
        this.insights});

  Body.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    avatar = json['avatar'];
    if(json['interest']!=null){
      interested = json['interest'].cast<dynamic>();
    }
    else{
      interested = json['interest'];
    }
    company = json['company'];
    position = json['position'];
    linkedin = json['linkedin'];
    insights = json['insights'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['avatar'] = avatar;
    data['interest'] = interested;
    data['company'] = company;
    data['position'] = position;
    data['linkedin'] = linkedin;
    data['insights'] = insights;

    return data;
  }
}
