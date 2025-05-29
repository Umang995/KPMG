class NotificationModel {
  dynamic body;
  Data? data;
  String? title;
  String? datetime;
  dynamic read;
  String? key;
  bool? showDate;

  NotificationModel(
      {this.body,
      this.data,
      this.title,
      this.datetime,
      this.read,
      this.key,
      this.showDate});

  NotificationModel.fromJson(Map<dynamic, dynamic> json) {
    body = json['body'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    title = json['title'];
    datetime = json['datetime'];
    read = json['read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body'] = this.body;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['title'] = this.title;
    data['datetime'] = this.datetime;
    data['read'] = this.read;

    return data;
  }
}

class Data {
  String? id;
  String? page;

  Data({this.id, this.page});

  Data.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['page'] = this.page;
    return data;
  }
}
