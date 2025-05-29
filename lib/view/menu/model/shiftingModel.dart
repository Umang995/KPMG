class ShiftingDetailModel {
  Head? head;
  List<Body>? body;

  ShiftingDetailModel({this.head, this.body});

  ShiftingDetailModel.fromJson(Map<String, dynamic> json) {
    head = json['head'] != null ? new Head.fromJson(json['head']) : null;
    if (json['body'] != null) {
      body = <Body>[];
      json['body'].forEach((v) {
        body!.add(new Body.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (head != null) {
      data['head'] = head!.toJson();
    }
    if (body != null) {
      data['body'] = body!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Head {
  bool? status;
  int? code;
  String? message;

  Head({this.status, this.code, this.message});

  Head.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}

class Body {
  String? status;
  String? webview;
  String isInterested="0";

  Body({this.status, this.webview,required this.isInterested});

  Body.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    webview = json['webview'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['webview'] = webview;
    return data;
  }
}
