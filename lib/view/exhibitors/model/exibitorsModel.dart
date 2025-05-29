import 'package:get/get.dart';

class ExhibitorsModel {
  Body? body;
  bool? hasNextPage;
  bool? status;
  int? code;
  ExhibitorsModel({this.status, this.code, this.body, this.hasNextPage});

  ExhibitorsModel.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
    status = json['status'];
    code = json['code'];
    hasNextPage = json['hasNextPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    data['hasNextPage'] = this.hasNextPage;
    return data;
  }
}

class Body {
  List<Exhibitors>? exhibitors;
  bool? hasNextPage;
  Request? request;

  Body({this.exhibitors, this.hasNextPage, this.request});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['exhibitors'] != null) {
      exhibitors = <Exhibitors>[];
      json['exhibitors'].forEach((v) {
        exhibitors!.add(new Exhibitors.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
    request =
        json['request'] != null ? new Request.fromJson(json['request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.exhibitors != null) {
      data['exhibitors'] = this.exhibitors!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = this.hasNextPage;
    if (this.request != null) {
      data['request'] = this.request!.toJson();
    }
    return data;
  }
}

class Exhibitors {
  var isFavLoading = false.obs;
  String? id;
  String? vendor;
  String? hallNumber;
  String? boothNumber;
  String? fasciaName;
  String? companyShortName;
  String? avatar;
  String? cover;
  String? city;
  String? state;
  String? country;
  String? timezone;
  String? favourite;

  Exhibitors(
      {this.id,
      this.vendor,
      this.hallNumber,
      this.boothNumber,
      this.fasciaName,
      this.companyShortName,
      this.avatar,
      this.cover,
      this.city,
      this.state,
      this.country,
      this.timezone,
      this.favourite});

  // Override equality operator
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Exhibitors && other.id == id);

  // Override hashCode
  @override
  int get hashCode => id.hashCode /*^ name.hashCode*/;

  Exhibitors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendor = json['vendor'];
    hallNumber = json['hall_number'];
    boothNumber = json['booth_number'];
    fasciaName = json['company'];
    companyShortName = json['company_short_name'];
    avatar = json['avatar'];
    cover = json['cover'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    timezone = json['timezone'];
    favourite = json['favourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor'] = this.vendor;
    data['hall_number'] = this.hallNumber;
    data['booth_number'] = this.boothNumber;
    data['fascia_name'] = this.fasciaName;
    data['company_short_name'] = this.companyShortName;
    data['avatar'] = this.avatar;
    data['cover'] = this.cover;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['timezone'] = this.timezone;
    data['favourite'] = this.favourite;
    return data;
  }
}

class Request {
  String? search;
  dynamic page;
  String? sort;

  Request({this.search, this.page, this.sort});

  Request.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    page = json['page'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search'] = this.search;
    data['page'] = this.page;
    data['sort'] = this.sort;
    return data;
  }
}
