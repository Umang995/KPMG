class FaqModel {
  List<FaqData>? body;
  bool? status;
  int? code;
  String? message;
  FaqModel({this.body,this.status, this.code, this.message});

  FaqModel.fromJson(Map<String, dynamic> json) {
    if (json['body'] != null) {
      body = <FaqData>[];
      status = json['status'];
      code = json['code'];
      message = json['message'];
      json['body'].forEach((v) {
        body!.add(new FaqData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (body != null) {
      data['status'] = status;
      data['code'] = code;
      data['message'] = message;
      data['body'] = body!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class FaqData {
  String? id;
  String? title;
  String? description;
  String? status;

  FaqData({this.id, this.title, this.description, this.status});

  FaqData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['status'] = status;
    return data;
  }
}
