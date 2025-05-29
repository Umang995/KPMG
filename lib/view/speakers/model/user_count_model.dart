class UserCountModel {
  UserCountModel({
     this.status,
     this.code,
     this.message,
     this.body,
  });
  bool? status;
  int? code;
  String? message;
  Body? body;
  UserCountModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = Body.fromJson(json['body']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['code'] = code;
    _data['message'] = message;
    _data['body'] = body!.toJson();
    return _data;
  }
}

class Body {
  Body({
     this.total,
  });
  int ?total;
  
  Body.fromJson(Map<String, dynamic> json){
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['total'] = total;
    return _data;
  }
}