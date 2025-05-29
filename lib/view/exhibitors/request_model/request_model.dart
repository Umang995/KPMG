class BootRequestModel {
  int? page;
  int? favourite;
  dynamic featured;
  RequestFilters? filters;

  BootRequestModel({this.page, this.favourite,this.featured, this.filters});

  BootRequestModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    favourite = json['favourite'];
    featured = json['featured'];
    filters = json['filters'] != null
        ? new RequestFilters.fromJson(json['filters'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['favourite'] = this.favourite;
    data['featured'] = this.featured;
    if (this.filters != null) {
      data['filters'] = this.filters!.toJson();
    }
    return data;
  }
}

class RequestFilters {
  String? sort;
  String? text;
  bool? notes;
  dynamic params;

  RequestFilters(
      {this.sort, this.text,this.notes, this.params});

  RequestFilters.fromJson(Map<String, dynamic> json) {
    sort = json['sort'];
    text = json['text'];
    notes = json['notes'];
    params = json['params'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sort'] = this.sort;
    data['text'] = this.text;
    data['notes'] = this.notes;
    data['params'] = this.params;
    return data;
  }
}

class RequestParams {
  Map<String, dynamic> additionalParams =
      {}; // Holds extra dynamic JSON-like data

  RequestParams();

  RequestParams.fromJson(Map<String, dynamic> json) {
    additionalParams = Map<String, dynamic>.from(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result.addAll(additionalParams); // Merge additional parameters directly
    return result;
  }

  // Add or update a key-value pair dynamically
  void addAdditionalParam(String key, dynamic value) {
    additionalParams[key] = value;
  }

  // Remove a dynamic key
  void removeAdditionalParam(String key) {
    additionalParams.remove(key);
  }

  // Clear all dynamic additional parameters
  void clearAdditionalParams() {
    additionalParams.clear();
  }
}
