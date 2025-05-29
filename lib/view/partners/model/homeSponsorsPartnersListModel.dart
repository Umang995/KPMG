import 'package:dreamcast/view/partners/model/AllSponsorsPartnersListModel.dart';

class HomeSponsorsPartnerListModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  HomeSponsorsPartnerListModel(
      {this.status, this.code, this.message, this.body});

  HomeSponsorsPartnerListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
  List<Items>? items;
  bool? hasNextPage;

  Body({this.items, this.hasNextPage});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = this.hasNextPage;
    return data;
  }
}


