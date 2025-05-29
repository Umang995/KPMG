class BookmarkCommonModel {
  Body? body;
  int? code;
  bool? status;
  String? message;

  BookmarkCommonModel({this.body, this.code, this.status, this.message});

  factory BookmarkCommonModel.fromJson(Map<String, dynamic> json) {
    return BookmarkCommonModel(
      body: json['body'] != null ? Body.fromJson(json['body']) : null,
      code: json['code'],
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    data['code'] = this.code;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Body {
  String? id;
  String? message;
  bool? status;
  int? muteNotification;

  Body({this.id, this.message, this.status,this.muteNotification});

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      id: json['favourite'],
      message: json['message'],
      status: json['status'],
      muteNotification: json['is_notification_mute'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['favourite'] = this.id;
    data['message'] = this.message;
    data['status'] = this.status;
    data['is_notification_mute'] = this.muteNotification;
    return data;
  }
}
