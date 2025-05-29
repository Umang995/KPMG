import 'package:get/get.dart';

class CommonDocumentModel {
  bool? status;
  int? code;
  String? message;
  List<DocumentData>? body;

  CommonDocumentModel({this.status, this.code, this.message, this.body});

  CommonDocumentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['body'] != null) {
      body = <DocumentData>[];
      json['body'].forEach((v) {
        body!.add(new DocumentData.fromJson(v));
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

class ParentCommonDocumentModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  ParentCommonDocumentModel({this.status, this.code, this.message, this.body});

  ParentCommonDocumentModel.fromJson(Map<String, dynamic> json) {
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
  List<DocumentData>? items;
  bool? hasNextPage;

  Body({this.items, this.hasNextPage});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <DocumentData>[];
      json['items'].forEach((v) {
        items!.add(new DocumentData.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = this.hasNextPage;
    return data;
  }
}

class DocumentData {
  String? id;
  String? name;
  String? description;
  Media? media;
  ItemData? itemData;

  String? favourite;
  var isFavLoading = false.obs;

  DocumentData(
      {this.id,
      this.name,
      this.media,
      this.itemData,
      this.favourite,
      this.description});

  DocumentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['title'];
    media = json['media_file'] != null
        ? new Media.fromJson(json['media_file'])
        : null;
    itemData =
        json['item'] != null ? new ItemData.fromJson(json['item']) : null;

    favourite = json['favourite'];
    description = json["description"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.name;
    if (this.media != null) {
      data['media_file'] = this.media!.toJson();
    }
    if (this.itemData != null) {
      data['item'] = this.itemData!.toJson();
    }
    data['favourite'] = this.favourite;
    data['description'] = this.description;
    return data;
  }
}

class Media {
  String? type;
  String? url;
  String? thumbnail;

  Media({this.type, this.url, this.thumbnail});

  Media.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['url'] = this.url;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}

class ItemData {
  String? type;
  String? id;

  ItemData({this.type, this.id});

  ItemData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    return data;
  }
}
