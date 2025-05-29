class MoreButtonModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  MoreButtonModel({this.status, this.code, this.message, this.body});

  MoreButtonModel.fromJson(Map<String, dynamic> json) {
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
  String? id;
  String? label;
  String? icon;
  String? slug;
  String? widgetType;
  String? url;

  Body({this.id, this.label, this.icon, this.slug, this.widgetType, this.url});

  Body.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    icon = json['icon'];
    slug = json['slug'];
    widgetType = json['widget_type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    data['icon'] = this.icon;
    data['slug'] = this.slug;
    data['widget_type'] = this.widgetType;
    data['url'] = this.url;
    return data;
  }
}
