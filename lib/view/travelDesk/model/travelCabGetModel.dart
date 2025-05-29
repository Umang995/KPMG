
class TravelCabGetModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  TravelCabGetModel({
    this.status,
    this.code,
    this.message,
    this.body,
  });

  factory TravelCabGetModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? bodyJson = json["body"];
    return TravelCabGetModel(
      status: json["status"],
      code: json["code"],
      message: json["message"],
      body: bodyJson != null && bodyJson.isNotEmpty
          ? Body.fromJson(bodyJson)
          : null,
    );
  }



  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "body": body?.toJson(),
  };
}

class Body {
  String? pickupName;
  String? pickupCabNumber;
  String? pickupNumber;
  String? dropoffName;
  String? dropoffCabNumber;
  String? dropoffNumber;

  Body({
    this.pickupName,
    this.pickupCabNumber,
    this.pickupNumber,
    this.dropoffName,
    this.dropoffCabNumber,
    this.dropoffNumber,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    pickupName: json["pickup_name"],
    pickupCabNumber: json["pickup_cab_number"],
    pickupNumber: json["pickup_number"],
    dropoffName: json["dropoff_name"],
    dropoffCabNumber: json["dropoff_cab_number"],
    dropoffNumber: json["dropoff_number"],
  );

  Map<String, dynamic> toJson() => {
    "pickup_name": pickupName,
    "pickup_cab_number": pickupCabNumber,
    "pickup_number": pickupNumber,
    "dropoff_name": dropoffName,
    "dropoff_cab_number": dropoffCabNumber,
    "dropoff_number": dropoffNumber,
  };
}




// class TravelCabGetModel {
//   bool? status;
//   int? code;
//   String? message;
//   Body? body;
//
//   TravelCabGetModel({this.status, this.code, this.message, this.body});
//
//   TravelCabGetModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     code = json['code'];
//     message = json['message'];
//     body = json['body'] != null ? new Body.fromJson(json['body']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['code'] = this.code;
//     data['message'] = this.message;
//     if (this.body != null) {
//       data['body'] = this.body!.toJson();
//     }
//     return data;
//   }
// }
//
// class Body {
//   CabInfo? cabInfo;
//   Message? message;
//
//   Body({this.cabInfo, this.message});
//
//   Body.fromJson(Map<String, dynamic> json) {
//     cabInfo = json['cab_info'] != null ? new CabInfo.fromJson(json['cab_info']) : null;
//     message = json['message'] != null ? new Message.fromJson(json['message']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.cabInfo != null) {
//       data['cab_info'] = this.cabInfo!.toJson();
//     }
//     if (this.message != null) {
//       data['message'] = this.message!.toJson();
//     }
//     return data;
//   }
// }
//
// class CabInfo {
//   dynamic pickupName;
//   dynamic pickupCabNumber;
//   dynamic pickupNumber;
//   dynamic pickup_residence_pickup;
//   dynamic dropoffName;
//   dynamic dropoffCabNumber;
//   dynamic dropoffNumber;
//   dynamic dropoff_residence_pickup;
//
//   CabInfo({this.pickupName, this.pickupCabNumber, this.pickupNumber, this.dropoffName, this.dropoffCabNumber, this.dropoffNumber});
//
//   CabInfo.fromJson(Map<String, dynamic> json) {
//     pickupName = json['pickup_name'];
//     pickupCabNumber = json['pickup_cab_number'];
//     pickupNumber = json['pickup_number'];
//     pickup_residence_pickup = json['pickup_residence'];
//     dropoffName = json['dropoff_name'];
//     dropoffCabNumber = json['dropoff_cab_number'];
//     dropoffNumber = json['dropoff_number'];
//     dropoff_residence_pickup = json['dropoff_residence'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['pickup_name'] = this.pickupName;
//     data['pickup_cab_number'] = this.pickupCabNumber;
//     data['pickup_number'] = this.pickupNumber;
//     data['pickup_residence'] = this.pickup_residence_pickup;
//     data['dropoff_name'] = this.dropoffName;
//     data['dropoff_cab_number'] = this.dropoffCabNumber;
//     data['dropoff_number'] = this.dropoffNumber;
//     data['dropoff_residence'] = this.dropoff_residence_pickup;
//     return data;
//   }
// }
//
// class Message {
//   dynamic title;
//   dynamic body;
//   dynamic icon;
//
//   Message({this.title, this.body, this.icon});
//
//   Message.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     body = json['body'];
//     icon = json['icon'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['title'] = this.title;
//     data['body'] = this.body;
//     data['icon'] = this.icon;
//     return data;
//   }
// }