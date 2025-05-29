class ExhibitorTeamListModel {
  Body? body;
  bool? status;
  int? code;
  String? message;

  ExhibitorTeamListModel({this.status, this.code, this.message, this.body});

  ExhibitorTeamListModel.fromJson(Map<String, dynamic> json) {
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
  dynamic itemCount;
  List<ExhibitorTeamData>? representatives;
  bool? hasNextPage;

  Body({this.representatives, this.hasNextPage, this.itemCount});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['representatives'] != null) {
      representatives = <ExhibitorTeamData>[];
      json['representatives'].forEach((v) {
        representatives!.add(new ExhibitorTeamData.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
    itemCount = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.representatives != null) {
      data['representatives'] =
          this.representatives!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = this.hasNextPage;
    data['count'] = this.itemCount;
    return data;
  }
}

class ExhibitorTeamData {
  String? id;
  String? name;
  String? shortName;
  String? company;
  String? position;
  String? avatar;
  String? role;
  String? vendor;
  String? timezone;
  bool? hasNextPage;

  ExhibitorTeamData(
      {this.id,
      this.name,
      this.shortName,
      this.company,
      this.position,
      this.avatar,
      this.role,
      this.vendor,
      this.timezone});

  ExhibitorTeamData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortName = json['short_name'];
    company = json['company'];
    position = json['position'];
    avatar = json['avatar'];
    role = json['role'];
    vendor = json['vendor'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['short_name'] = this.shortName;
    data['company'] = this.company;
    data['position'] = this.position;
    data['avatar'] = this.avatar;
    data['role'] = this.role;
    data['vendor'] = this.vendor;
    data['timezone'] = this.timezone;
    return data;
  }
}
