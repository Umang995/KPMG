class PartnersModel {
  Body? body;
  bool? status;
  int? code;
  String? message;

  PartnersModel({this.status,this.code,this.message, this.body});

  PartnersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class Body {
  List<Sponsors>? sponsors;
  bool? hasNextPage;

  Body({this.sponsors, this.hasNextPage});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['sponsors'] != null) {
      sponsors = <Sponsors>[];
      json['sponsors'].forEach((v) {
        sponsors!.add(new Sponsors.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sponsors != null) {
      data['sponsors'] = sponsors!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = hasNextPage;
    return data;
  }
}

class Sponsors {
  String? label;
  List<Partner>? data;

  Sponsors({this.label, this.data});

  Sponsors.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    if (json['sponsors'] != null) {
      data = <Partner>[];
      json['sponsors'].forEach((v) {
        data!.add(new Partner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sponsors'] = label;
    if (this.data != null) {
      data['sponsors'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Partner {
  String? name;
  String? logo;
  dynamic banner;
  String? description;
  String? category;
  SocialMedia? socialMedia;


  Partner(
      {this.name, this.logo, this.banner, this.description, this.category,
        this.socialMedia});

  Partner.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    logo = json['logo'];
    banner = json['banner'];
    description = json['description'];
    category = json['category'];
    socialMedia = json['social_media'] != null
        ? new SocialMedia.fromJson(json['social_media'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['logo'] = logo;
    data['banner'] = banner;
    data['description'] = description;
    data['category'] = category;
    if (socialMedia != null) {
      data['social_media'] = socialMedia!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    if (params != null) {
      data['params'] = params!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['value'] = value;
    return data;
  }
}