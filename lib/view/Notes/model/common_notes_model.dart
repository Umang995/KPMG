import 'package:get/get.dart';

class CommonNotesModel {
  bool? status;
  int? code;
  String? message;
  List<NotesDataModel>? body;

  CommonNotesModel({this.status, this.code, this.message, this.body});

  CommonNotesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['body'] != null) {
      body = <NotesDataModel>[];
      json['body'].forEach((v) {
        body!.add(new NotesDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.body != null) {
      data['body'] = this.body!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotesDataModel {
  String? id;
  String? text;
  Item? item;
  var showPopup = false.obs;

  NotesDataModel({this.id, this.text, this.item});

  NotesDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    item = json['item'] != null ? new Item.fromJson(json['item']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    if (this.item != null) {
      data['item'] = this.item!.toJson();
    }

    return data;
  }
}

class Item {
  String? id;
  String? type;
  String? name;
  String? shortName;
  String? avatar;

  Item({this.id, this.type,this.name, this.avatar,this.shortName});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    avatar = json['avatar'];
    shortName = json['shortName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['shortName']= this.shortName;

    return data;
  }
}
