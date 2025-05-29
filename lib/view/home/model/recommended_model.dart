class RecommendedModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  RecommendedModel({this.status, this.code, this.message, this.body});

  RecommendedModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
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
  List<RecommendedData>? items;
  Body({this.items});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <RecommendedData>[];
      json['items'].forEach((v) {
        items!.add(new RecommendedData.fromJson(v));
      });
    }
    else if (json['speakers'] != null) {
      items = <RecommendedData>[];
      json['speakers'].forEach((v) {
        items!.add(new RecommendedData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['speakers'] = items!.map((v) => v.toJson()).toList();
    }
    else if (items != null) {
      data['speakers'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecommendedData {
  String? id;
  String? name;
  String? company;
  String? position;
  String? avatar;
  String? type;
  String? role;
  String? startDatetime;
  String? endDatetime;
  RecommendedData(
      {this.id,
        this.name,
        this.company,
        this.position,
        this.avatar,
        this.type,this.role,this.startDatetime,this.endDatetime});

  RecommendedData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    company = json['company'];
    position = json['position'];
    avatar = json['avatar'];
    type = json['type'];
    role= json['role'];
    startDatetime = json['start_datetime'];
    endDatetime = json['end_datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['company'] = company;
    data['position'] = position;
    data['avatar'] = avatar;
    data['type'] = type;
    data['role'] = role;
    data['start_datetime'] = startDatetime;
    data['end_datetime'] = endDatetime;
    return data;
  }
}
