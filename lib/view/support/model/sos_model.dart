class SOSDataModel {
  bool? status;
  int? code;
  String? message;
  List<SosData>? body;

  SOSDataModel({this.status, this.code, this.message, this.body});

  SOSDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['body'] != null) {
      body = <SosData>[];
      json['body'].forEach((v) {
        body!.add(new SosData.fromJson(v));
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

class SosData {
  String? label;
  List<Items>? items;

  SosData({this.label, this.items});

  SosData.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? shortName;
  String? mobile;
  String? email;
  String? avatar;

  Items({this.name, this.mobile, this.email, this.avatar});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    shortName = json['short_name'];
    mobile = json['mobile'];
    email = json['email'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['short_name'] = this.shortName;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    return data;
  }
}

