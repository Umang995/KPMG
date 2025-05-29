class PhotoListModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  PhotoListModel({this.status, this.code, this.message, this.body});

  PhotoListModel.fromJson(Map<String, dynamic> json) {
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
  bool? hasNextPage;
  dynamic actionUploadEnable;
  List<String>? gallery;
  int? total;

  Body({this.hasNextPage, this.gallery});

  Body.fromJson(Map<String, dynamic> json) {
    hasNextPage = json['hasNextPage'];
    total=json['total'];
    actionUploadEnable=json["is_upload"];
    gallery = json['gallery'].cast<String>();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hasNextPage'] = this.hasNextPage;
    data['is_upload'] = this.actionUploadEnable;
    data['total']=this.total;
    data['gallery'] = this.gallery;

    return data;
  }
}

// class Gallery {
//   int? id;
//   String? imageName;
//   String? eventName;
//   String? imageUrl;
//   String? faceId;
//   String? createdAt;
//   String? updatedAt;
//
//   Gallery(
//       {this.id,
//       this.imageName,
//       this.eventName,
//       this.imageUrl,
//       this.faceId,
//       this.createdAt,
//       this.updatedAt});
//
//   Gallery.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     imageName = json['image_name'];
//     eventName = json['event_name'];
//     imageUrl = json['image_url'];
//     faceId = json['face_id'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['image_name'] = this.imageName;
//     data['event_name'] = this.eventName;
//     data['image_url'] = this.imageUrl;
//     data['face_id'] = this.faceId;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }
