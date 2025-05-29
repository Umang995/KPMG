class TipsDataModel {
  bool? status;
  int? code;
  String? message;
  TipsBody? body;

  TipsDataModel({this.status, this.code, this.message, this.body});

  TipsDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? new TipsBody.fromJson(json['body']) : null;
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

class TipsBody {
  DoData? doData;
  DoData? donotData;

  TipsBody({this.doData, this.donotData});

  TipsBody.fromJson(Map<String, dynamic> json) {
    doData =
    json['do'] != null ? new DoData.fromJson(json['do']) : null;
    donotData = json['donot'] != null
        ? new DoData.fromJson(json['donot'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.doData != null) {
      data['do'] = this.doData!.toJson();
    }
    if (this.donotData != null) {
      data['donot'] = this.donotData!.toJson();
    }
    return data;
  }
}

class DoData {
  String? label;
  dynamic options;

  DoData({this.label, this.options});

  DoData.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    options = json['options'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['options'] = this.options;
    return data;
  }
}
