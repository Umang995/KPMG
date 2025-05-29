class ProductExhibitorModel {
  ProductExhibitorData? body;
  bool? status;
  int? code;
  String? message;
  ProductExhibitorModel({this.status, this.code, this.message, this.body});

  ProductExhibitorModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? new ProductExhibitorData.fromJson(json['body']) : null;
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

class ProductExhibitorData {
  String? id;
  String? hallNumber;
  String? boothNumber;
  String? boothType;
  String? company;
  String? avatar;
  String? shortName;
  String? description;

  ProductExhibitorData(
      {this.id,
        this.hallNumber,
        this.boothNumber,
        this.boothType,
        this.company,
        this.avatar,
        this.shortName,
        this.description});

  ProductExhibitorData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hallNumber = json['hall_number'];
    boothNumber = json['booth_number'];
    boothType = json['booth_type'];
    company = json['company'];
    avatar = json['avatar'];
    shortName = json['short_name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hall_number'] = this.hallNumber;
    data['booth_number'] = this.boothNumber;
    data['booth_type'] = this.boothType;
    data['company'] = this.company;
    data['avatar'] = this.avatar;
    data['short_name'] = this.shortName;
    data['description'] = this.description;
    return data;
  }
}
