class VenueMgtModel {
  Head? head;
  VenueMgtBody? body;

  VenueMgtModel({this.head, this.body});

  VenueMgtModel.fromJson(Map<String, dynamic> json) {
    head = json['head'] != null ? new Head.fromJson(json['head']) : null;
    body = json['body'] != null ? new VenueMgtBody.fromJson(json['body']) : null;
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
  String? message;

  Head({this.status, this.code, this.message});

  Head.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}

class VenueMgtBody {
  List<Guides>? guides;
  String? mapLocation;
  String? locationText;
  String? locationImage;


  VenueMgtBody({this.guides, this.mapLocation, this.locationText,this.locationImage});

  VenueMgtBody.fromJson(Map<String, dynamic> json) {
    if (json['guides'] != null) {
      guides = <Guides>[];
      json['guides'].forEach((v) {
        guides!.add(new Guides.fromJson(v));
      });
    }
    mapLocation = json['map_location'];
    locationText = json['location_text'];
    locationImage = json['location_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.guides != null) {
      data['guides'] = this.guides!.map((v) => v.toJson()).toList();
    }
    data['map_location'] = this.mapLocation;
    data['location_text'] = this.locationText;
    data['location_image'] = this.locationImage;
    return data;
  }
}

class Guides {
  String? label;
  String? media;
  String? type;
  String? thumbnail;

  Guides({this.label, this.media, this.type,this.thumbnail});

  Guides.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    media = json['media'];
    type = json['type'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['media'] = this.media;
    data['type'] = this.type;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}
