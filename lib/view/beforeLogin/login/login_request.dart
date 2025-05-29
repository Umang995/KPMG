class LoginRequestModel {
  String? loginType;
  String? uuid;
  String? fcm_token;

  LoginRequestModel({this.loginType,this.uuid, this.fcm_token});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['fcm_token'] = fcm_token;

    return data;
  }
}