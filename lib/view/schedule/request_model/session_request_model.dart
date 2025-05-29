class SessionRequestModel {
  int? page;
  int? favourite;
  int? booking;

  RequestFilters? filters;

  SessionRequestModel({this.page, this.filters, this.favourite, this.booking});

  SessionRequestModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    favourite = json['favourite'];
    booking = json['my_bookings'];

    filters = json['filters'] != null
        ? new RequestFilters.fromJson(json['filters'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['favourite'] = this.favourite;
    data['my_bookings'] = this.booking;
    data['page'] = this.page;
    if (this.filters != null) {
      data['filters'] = this.filters!.toJson();
    }
    return data;
  }
}

class RequestFilters {
  String? sort;
  String? text;
  RequestParams? params;

  RequestFilters({this.sort, this.text, this.params});

  RequestFilters.fromJson(Map<String, dynamic> json) {
    sort = json['sort'];
    text = json['text'];
    params = json['params'] != null
        ? new RequestParams.fromJson(json['params'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sort'] = this.sort;
    data['text'] = this.text;
    if (this.params != null) {
      data['params'] = this.params!.toJson();
    }
    return data;
  }
}

class RequestParams {
  String? date;
  int? status;
  Map<String, dynamic> additionalParams =
      {}; // Holds extra dynamic JSON-like data

  RequestParams({this.date, this.status});

  RequestParams.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    status = json['status'];
    additionalParams = Map<String, dynamic>.from(json)
      ..remove('date')
      ..remove('status');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    if (date != null) result['date'] = date;
    if (status != null) result['status'] = status;
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
