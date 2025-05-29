class GalleryModel {
  Body? body;
  bool? status;
  int? code;
  GalleryModel({this.status, this.code, this.body});
  GalleryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class Body {
  List<VideoGalleryDetail>? mediaData;
  bool? hasNextPage;

  Body({
    this.mediaData,
    this.hasNextPage,
  });

  Body.fromJson(Map<String, dynamic> json) {
    if (json['galleries'] != null) {
      mediaData = <VideoGalleryDetail>[];
      json['galleries'].forEach((v) {
        mediaData!.add(new VideoGalleryDetail.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (mediaData != null) {
      data['galleries'] = mediaData!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = hasNextPage;
    return data;
  }
}

class VideoGalleryDetail {
  String? id;
  String? title;
  MediaFile? mediaFile;
  String? mediaLink;
  String? description;
  Item? item;
  String? favourite;
  bool? hasNextPage;

  VideoGalleryDetail({
    this.id,
    this.title,
    this.mediaFile,
    this.mediaLink,
    this.description,
    this.item,
    this.favourite,
    this.hasNextPage,
  });

  factory VideoGalleryDetail.fromJson(Map<String, dynamic> json) =>
      VideoGalleryDetail(
        id: json["id"],
        title: json["title"],
        mediaFile: json["media_file"] == null
            ? null
            : MediaFile.fromJson(json["media_file"]),
        mediaLink: json["media_link"],
        description: json["description"],
        item: json["item"] == null ? null : Item.fromJson(json["item"]),
        favourite: json["favourite"],
        hasNextPage: json["hasNextPage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "media_file": mediaFile?.toJson(),
        "media_link": mediaLink,
        "description": description,
        "item": item?.toJson(),
        "favourite": favourite,
        "hasNextPage": hasNextPage,
      };
}

class Item {
  String? id;
  String? type;

  Item({
    this.id,
    this.type,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
      };
}

class MediaFile {
  String? type;
  String? url;
  String? thumbnail;

  MediaFile({
    this.type,
    this.url,
    this.thumbnail,
  });

  factory MediaFile.fromJson(Map<String, dynamic> json) => MediaFile(
        type: json["type"],
        url: json["url"],
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "url": url,
        "thumbnail": thumbnail,
      };
}
