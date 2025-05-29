import 'package:get/get.dart';

class ExhibitorsDocumentModel {
  List<Documents>? body;
  bool? status;
  int? code;
  ExhibitorsDocumentModel({this.status, this.code, this.body});

  ExhibitorsDocumentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['body'] != null) {
      body = <Documents>[];
      json['body'].forEach((v) {
        body!.add(new Documents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.body != null) {
      data['body'] = this.body!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Documents {
  var isFavLoading=false.obs;
  String? id;
  String? label;
  String? description;
  String? bookmark;
  String? thumbnail;
  String? video;
  String? mediaType;
  String? media;

  Documents(
      {this.id,
        this.label,
        this.description,
        this.bookmark,
        this.thumbnail,
        this.video,
        this.mediaType,this.media});

  Documents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['name'];
    description = json['description'];
    bookmark = json['favourite'];
    thumbnail = json['thumbnail'];
    video = json['video'];
    mediaType = json['media_type'];
    media = json['media'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.label;
    data['description'] = this.description;
    data['favourite'] = this.bookmark;
    data['thumbnail'] = this.thumbnail;
    data['video'] = this.video;
    data['media_type'] = this.mediaType;
    data['media'] = this.media;
    return data;
  }
}
