class NearByAttrectionModel {
  bool? status;
  int? code;
  String? message;
  List<NearByData>? nearByData;

  NearByAttrectionModel(
      {this.status, this.code, this.message, this.nearByData});

  NearByAttrectionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['body'] != null) {
      nearByData = <NearByData>[];
      json['body'].forEach((v) {
        nearByData!.add(new NearByData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.nearByData != null) {
      data['body'] = this.nearByData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NearByData {
  String? title;
  String? description;
  String? location;
  String? latitude;
  String? longitude;
  String? media;
  String? locationUrl;

  NearByData(
      {this.title,
      this.description,
      this.location,
      this.latitude,
      this.longitude,
      this.media,
      this.locationUrl});

  NearByData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    location = json['location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    media = json['media'];
    locationUrl = json['location_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['location'] = this.location;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['media'] = this.media;
    data['location_url'] = this.locationUrl;
    return data;
  }
}
