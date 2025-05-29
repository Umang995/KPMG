class SessionPollStatus {
  Body? body;
  bool? status;
  int? code;
  String? message;


  SessionPollStatus({this.status, this.code, this.body,this.message});

  SessionPollStatus.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    code = json['code'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class Body {
  int? userStatus;
  dynamic message;

  Body({this.userStatus,this.message});

  Body.fromJson(Map<String, dynamic> json) {
    userStatus = json['user_status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_status'] = userStatus;
    data['message'] = message;
    return data;
  }
}
