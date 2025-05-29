class SaveQuestionModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  SaveQuestionModel({this.status, this.code, this.message, this.body});

  SaveQuestionModel.fromJson(Map<String, dynamic> json) {
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
  String? itemId;
  String? itemType;
  String? message;
  String? created;
  int? status;
  String? id;

  Body(
      {this.itemId,
        this.itemType,
        this.message,
        this.created,
        this.status,
        this.id});

  Body.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    itemType = json['item_type'];
    message = json['message'];
    created = json['created'];
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this.itemId;
    data['item_type'] = this.itemType;
    data['message'] = this.message;
    data['created'] = this.created;
    data['status'] = this.status;
    data['id'] = this.id;
    return data;
  }
}
