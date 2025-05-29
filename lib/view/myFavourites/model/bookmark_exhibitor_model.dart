import 'package:get/get.dart';

class BookmarkExhibitorModel {
  Body? body;
  bool? status;
  int? code;

  BookmarkExhibitorModel({this.status, this.code, this.body});

  BookmarkExhibitorModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
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
  List<ExhibitorsBookmarks>? bookmarks;
  bool? hasNextPage;

  Body({this.bookmarks, this.hasNextPage});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['favourites'] != null) {
      bookmarks = <ExhibitorsBookmarks>[];
      json['favourites'].forEach((v) {
        bookmarks!.add(new ExhibitorsBookmarks.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bookmarks != null) {
      data['favourites'] = bookmarks!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = hasNextPage;
    return data;
  }
}

class ExhibitorsBookmarks {
  String? id;
  User? user;

  ExhibitorsBookmarks({this.id, this.user});

  ExhibitorsBookmarks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
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

  User(
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

  User.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor'] = vendor;
    data['hall_number'] = hallNumber;
    data['booth_number'] = boothNumber;
    data['company'] = fasciaName;
    data['company_short_name'] = companyShortName;
    data['avatar'] = avatar;
    data['cover'] = cover;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['timezone'] = timezone;
    data['favourite'] = favourite;
    return data;
  }
}
