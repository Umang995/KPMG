class TravelSaveModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  TravelSaveModel({this.status, this.code, this.message, this.body});

  TravelSaveModel.fromJson(Map<String, dynamic> json) {
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
  bool? status;
  String? message;
  Missing? missing;


  Body({this.status, this.message,this.missing});

  Body.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    missing =
    json['missing'] != null ? new Missing.fromJson(json['missing']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.missing != null) {
      data['missing'] = this.missing!.toJson();
    }
    return data;
  }
}

class Missing {
  String? s6;

  Missing({this.s6});

  Missing.fromJson(Map<String, dynamic> json) {
    s6 = json['6'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['6'] = this.s6;
    return data;
  }
}
