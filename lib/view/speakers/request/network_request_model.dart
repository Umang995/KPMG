class NetworkRequestModel {
  int? page;
  String? role;
  int? favorite;
  RequestFilters? filters;

  NetworkRequestModel({this.page, this.role, this.filters, this.favorite});

  NetworkRequestModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    role = json['role'];
    favorite = json['favourite'];

    filters = json['filters'] != null
        ? new RequestFilters.fromJson(json['filters'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['role'] = this.role;
    data['favourite'] = this.favorite;
    if (this.filters != null) {
      data['filters'] = this.filters!.toJson();
    }
    return data;
  }
}

class RequestFilters {
  String? text;
  String? sort;
  bool? isBlocked;
  bool? notes;
  dynamic params;

  RequestFilters(
      {this.text, this.sort, this.isBlocked, this.notes, this.params});

  RequestFilters.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    sort = json['sort'];
    isBlocked = json['is_blocked'];
    params = json['params'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['sort'] = this.sort;
    data['is_blocked'] = this.isBlocked;
    //data['notes'] = this.notes;
    data['params'] = this.params;
    return data;
  }
}
