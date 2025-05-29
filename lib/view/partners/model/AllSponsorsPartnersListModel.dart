class AllSponsorsPartnerListModel {
  bool? status;
  int? code;
  String? message;
  List<PartnerData>? body;

  AllSponsorsPartnerListModel(
      {this.status, this.code, this.message, this.body});

  AllSponsorsPartnerListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['body'] != null) {
      body = <PartnerData>[];
      json['body'].forEach((v) {
        body!.add(new PartnerData.fromJson(v));
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

class PartnerData {
  String? label;
  List<Items>? items;

  PartnerData({this.label, this.items});

  PartnerData.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? id;
  String? name;
  String? avatar;
  String? website;
  String? description;
  String? label;
  SocialMedia? socialMedia;

  Items(
      {this.id,
        this.name,
        this.avatar,
        this.website,
        this.description,
        this.label,
        this.socialMedia});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
    website = json['website'];
    description = json['description'];
    label = json['label'];
    socialMedia = json['social_media'] != null
        ? new SocialMedia.fromJson(json['social_media'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['website'] = this.website;
    data['description'] = this.description;
    data['label'] = this.label;
    if (this.socialMedia != null) {
      data['social_media'] = this.socialMedia!.toJson();
    }
    return data;
  }
}

class SocialMedia {
  String? text;
  List<Params>? params;

  SocialMedia({this.text, this.params});

  SocialMedia.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    if (json['params'] != null) {
      params = <Params>[];
      json['params'].forEach((v) {
        params!.add(new Params.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    if (this.params != null) {
      data['params'] = this.params!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Params {
  String? text;
  String? value;

  Params({this.text, this.value});

  Params.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['value'] = this.value;
    return data;
  }
}
