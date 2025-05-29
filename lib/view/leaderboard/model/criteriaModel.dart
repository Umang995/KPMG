class CriteriaModel {
  bool? status;
  int? code;
  String? message;
  List<Criteria>? criteria;

  CriteriaModel({this.status, this.code, this.message, this.criteria});

  CriteriaModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['body'] != null) {
      criteria = <Criteria>[];
      json['body'].forEach((v) {
        criteria!.add(new Criteria.fromJson(v));
      });
    }  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.criteria != null) {
      data['body'] = this.criteria!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Criteria {
  dynamic point;
  dynamic multiple;
  dynamic multiplier;
  String? name;

  Criteria({this.point, this.multiple, this.name, this.multiplier});

  Criteria.fromJson(Map<String, dynamic> json) {
    point = json['point'];
    multiple = json['multiple'];
    name = json['name'];
    multiplier = json['multiplier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['point'] = this.point;
    data['multiple'] = this.multiple;
    data['name'] = this.name;
    data['multiplier'] = this.multiplier;
    return data;
  }
}
