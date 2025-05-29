class MenuDataModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  MenuDataModel({this.status, this.code, this.message, this.body});

  MenuDataModel.fromJson(Map<String, dynamic> json) {
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
  List<MenuData>? appFooter;

  List<MenuData>? homeFeature;
  List<MenuData>? homeProfile;
  List<MenuData>? userProfile;
  List<MenuData>? lunchFooter;

  List<MenuData>? hubTop;
  List<MenuData>? hubMain;

  Body(
      {this.appFooter,
      this.homeFeature,
      this.hubTop,
      this.hubMain,
      this.homeProfile,
      this.userProfile,
      this.lunchFooter});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['app_footer'] != null) {
      appFooter = <MenuData>[];
      json['app_footer'].forEach((v) {
        appFooter!.add(new MenuData.fromJson(v));
      });
    }
    if (json['home_feature'] != null) {
      homeFeature = <MenuData>[];
      json['home_feature'].forEach((v) {
        homeFeature!.add(new MenuData.fromJson(v));
      });
    }
    if (json['home_profile'] != null) {
      homeProfile = <MenuData>[];
      json['home_profile'].forEach((v) {
        homeProfile!.add(new MenuData.fromJson(v));
      });
    }

    if (json['user_profile'] != null) {
      userProfile = <MenuData>[];
      json['user_profile'].forEach((v) {
        userProfile!.add(new MenuData.fromJson(v));
      });
    }

    if (json['hub_top'] != null) {
      hubTop = <MenuData>[];
      json['hub_top'].forEach((v) {
        hubTop!.add(new MenuData.fromJson(v));
      });
    }
    if (json['hub_main'] != null) {
      hubMain = <MenuData>[];
      json['hub_main'].forEach((v) {
        hubMain!.add(new MenuData.fromJson(v));
      });
    }
    if (json['home_footer'] != null) {
      lunchFooter = <MenuData>[];
      json['home_footer'].forEach((v) {
        lunchFooter!.add(new MenuData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appFooter != null) {
      data['app_footer'] = this.appFooter!.map((v) => v.toJson()).toList();
    }
    if (this.homeFeature != null) {
      data['home_feature'] = this.homeFeature!.map((v) => v.toJson()).toList();
    }
    if (this.homeProfile != null) {
      data['home_profile'] = this.homeProfile!.map((v) => v.toJson()).toList();
    }
    if (this.userProfile != null) {
      data['user_profile'] = this.userProfile!.map((v) => v.toJson()).toList();
    }
    if (this.hubTop != null) {
      data['hub_top'] = this.hubTop!.map((v) => v.toJson()).toList();
    }
    if (this.hubMain != null) {
      data['hub_main'] = this.hubMain!.map((v) => v.toJson()).toList();
    }
    if (this.lunchFooter != null) {
      data['home_footer'] = this.lunchFooter!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MenuData {
  String? label;
  String? icon;
  String? slug;
  String? pageId;
  String? role;
  String? url;
  String? widget;
  String? id;

  MenuData(
      {this.label,
      this.icon,
      this.slug,
      this.pageId,
      this.role,
      this.url,
      this.widget,
      this.id});

  MenuData.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    icon = json['icon'];
    slug = json['slug'];
    url = json['url'];
    widget = json['widget'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['icon'] = this.icon;
    data['slug'] = this.slug;
    data['url'] = this.url;
    data['widget'] = this.widget;
    data['id'] = this.id;
    return data;
  }
}
