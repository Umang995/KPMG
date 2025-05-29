class IFrameModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  IFrameModel({this.status, this.code, this.message, this.body});

  IFrameModel.fromJson(Map<String, dynamic> json) {
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
  bool? status;
  MessageData? messageData;
  String? webview;

  Body({this.status, this.messageData, this.webview});

  Body.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messageData = json['message'] != null
        ? new MessageData.fromJson(json['message'])
        : null;
    webview = json['webview'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.messageData != null) {
      data['message'] = this.messageData!.toJson();
    }
    data['webview'] = this.webview;
    return data;
  }
}

class MessageData {
  String? title;
  String? body;

  MessageData({this.title, this.body});

  MessageData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}
