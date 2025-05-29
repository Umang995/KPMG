class PhotoboothModel {
  Head? head;
  Body? body;

  PhotoboothModel({this.head, this.body});

  PhotoboothModel.fromJson(Map<String, dynamic> json) {
    head = json['head'] != null ? new Head.fromJson(json['head']) : null;
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.head != null) {
      data['head'] = this.head!.toJson();
    }
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class Head {
  bool? status;
  int? code;

  Head({this.status, this.code});

  Head.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    return data;
  }
}

class Body {
  bool? status;
  String? webview;

  Body({this.status, this.webview});

  Body.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    webview = json['webview'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['webview'] = this.webview;
    return data;
  }
}
