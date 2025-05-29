class StartNetworkingModel {
  Body? body;
  bool? status;
  int? code;

  StartNetworkingModel({this.status, this.code, this.body});

  StartNetworkingModel.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
    status = json['status'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class Body {
  List<UserAspireData>? representatives;
  bool? hasNextPage;

  Body({this.representatives, this.hasNextPage});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      representatives = <UserAspireData>[];
      json['users'].forEach((v) {
        representatives!.add(new UserAspireData.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (representatives != null) {
      data['users'] = representatives!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = hasNextPage;
    return data;
  }
}

class UserAspireData {
  String? id;
  String? name;
  String? shortName;
  String? company;
  String? position;
  String? avatar;
  String? category;
  String? description;
  String? linkedin;

  UserAspireData(
      {this.id,
      this.name,
      this.shortName,
      this.company,
      this.position,
      this.avatar,
      this.category,
      this.description,
      this.linkedin});

  UserAspireData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortName = json['short_name'];
    company = json['company'];
    position = json['position'];
    avatar = json['avatar'];
    category = json['category'];
    description = json['description'];
    linkedin = json['linkedin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['short_name'] = shortName;
    data['company'] = company;
    data['position'] = position;
    data['avatar'] = avatar;
    data['category'] = category;
    data['description'] = description;
    data['linkedin'] = linkedin;
    return data;
  }
}
