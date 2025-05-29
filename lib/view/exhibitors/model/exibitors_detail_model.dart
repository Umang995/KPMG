import 'package:get/get.dart';

class ExhibitorsDetailsModel {
  ExhibitorsBody? body;
  bool? status;
  int? code;
  String? message;

  ExhibitorsDetailsModel({this.status, this.code, this.message, this.body});

  ExhibitorsDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? new ExhibitorsBody.fromJson(json['body']) : null;
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


class ExhibitorsBody {
  String? id;
  String? vendor;
  String? company;
  String? companyShortName;
  String? avatar;
  String? description;
  String? timezone;
  String? cover;
  AboutData? about;
  ContactData? contact;
  SocialMedia? socialMedia;
  VirtualData? virtual;
  String? favourite;
  String? country;
  String? state;
  String? city;
  String? boothNumber;
  String? hallNumber;
  List<String>? controls;
  var isLoading = false.obs;


  ExhibitorsBody(
      {this.id,
        this.vendor,
        this.company,
        this.companyShortName,
        this.avatar,
        this.description,
        this.timezone,
        this.cover,
        this.about,
        this.contact,
        this.socialMedia,
        this.virtual,
        this.favourite,this.country,this.state,this.city,this.boothNumber,this.hallNumber,this.controls});

  ExhibitorsBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendor = json['vendor'];
    company = json['company'];
    companyShortName = json['company_short_name'];
    avatar = json['avatar'];
    description = json['description'];
    timezone = json['timezone'];
    cover = json['cover'];
    about = json['about'] != null ? new AboutData.fromJson(json['about']) : null;
    contact =
    json['contact'] != null ? new ContactData.fromJson(json['contact']) : null;
    socialMedia = json['social_media'] != null
        ? new SocialMedia.fromJson(json['social_media'])
        : null;
    virtual =
    json['virtual'] != null ? new VirtualData.fromJson(json['virtual']) : null;
    favourite = json['favourite'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    boothNumber = json['booth_number'];
    hallNumber = json['hall_number'];
    controls = json['controls'] != null
        ? json['controls'].cast<String>()
        : controls = <String>[];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor'] = vendor;
    data['fascia_name'] = company;
    data['company_short_name'] = companyShortName;
    data['avatar'] = avatar;
    data['description'] = description;
    data['timezone'] = timezone;
    data['cover'] = cover;
    data['booth_number'] = boothNumber;
    data['hall_number'] = hallNumber;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    if (about != null) {
      data['about'] = about!.toJson();
    }
    if (contact != null) {
      data['contact'] = contact!.toJson();
    }
    if (socialMedia != null) {
      data['social_media'] = socialMedia!.toJson();
    }
    if (virtual != null) {
      data['virtual'] = virtual!.toJson();
    }
    data['favourite'] = favourite;
    data['controls'] = controls;
    return data;
  }
}

class AboutData {
  String? label;
  List<AboutParam>? params;

  AboutData({this.label, this.params});

  AboutData.fromJson(Map<String, dynamic> json) {
    label = json['text'];
    if (json['params'] != null) {
      params = <AboutParam>[];
      json['params'].forEach((v) {
        params!.add(new AboutParam.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = label;
    if (params != null) {
      data['params'] = params!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AboutParam {
  String? text;
  String? value;

  AboutParam({this.text, this.value});

  AboutParam.fromJson(Map<String, dynamic> json) {
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

class ContactData {
  String? text;
  List<ContactParams>? params;

  ContactData({this.text, this.params});

  ContactData.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    if (json['params'] != null) {
      params = <ContactParams>[];
      json['params'].forEach((v) {
        params!.add(new ContactParams.fromJson(v));
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

class ContactParams {
  String? field;
  String? text;
  String? value;

  ContactParams({this.field, this.text, this.value});

  ContactParams.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    text = json['text'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['field'] = field;
    data['text'] = text;
    data['value'] = value;
    return data;
  }
}

class VirtualData {
  String? label;
  List<VirtualParams>? params;

  VirtualData({this.label, this.params});

  VirtualData.fromJson(Map<String, dynamic> json) {
    label = json['text'];
    if (json['params'] != null) {
      params = <VirtualParams>[];
      json['params'].forEach((v) {
        params!.add(new VirtualParams.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = label;
    if (params != null) {
      data['params'] = params!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VirtualParams {
  String? label;
  List<String>? value;

  VirtualParams({this.label, this.value});

  VirtualParams.fromJson(Map<String, dynamic> json) {
    label = json['text'];
    value = json['value'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = label;
    data['value'] = value;
    return data;
  }
}

class SocialMedia {
  String? text;
  List<ContactParams>? params;

  SocialMedia({this.text, this.params});

  SocialMedia.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    if (json['params'] != null) {
      params = <ContactParams>[];
      json['params'].forEach((v) {
        params!.add(new ContactParams.fromJson(v));
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
