
class TravelHotelGetModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  TravelHotelGetModel({
    this.status,
    this.code,
    this.message,
    this.body,
  });

  factory TravelHotelGetModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? bodyJson = json["body"];
   return TravelHotelGetModel(
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
  String? id;
  String? bookingId;
  String? name;
  String? locationUrl;
  String? checkinDate;
  String? checkoutDate;
  String? roomNumber;
  String? bookedFor;
  String? personCount;
  String? address;
  String? hotelPdf;

  Body({
    this.id,
    this.bookingId,
    this.name,
    this.locationUrl,
    this.checkinDate,
    this.checkoutDate,
    this.roomNumber,
    this.bookedFor,
    this.personCount,
    this.address,
    this.hotelPdf,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    id: json["id"],
    bookingId: json["booking_id"],
    name: json["name"],
    locationUrl: json["location_url"],
    checkinDate: json["checkin_date"],
    checkoutDate: json["checkout_date"],
    roomNumber: json["room_number"],
    bookedFor: json["booked_for"],
    personCount: json["person_count"],
    address: json["address"],
    hotelPdf: json["hotel_pdf"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "booking_id": bookingId,
    "name": name,
    "location_url": locationUrl,
    "checkin_date": checkinDate,
    "checkout_date": checkoutDate,
    "room_number": roomNumber,
    "booked_for": bookedFor,
    "person_count": personCount,
    "address": address,
    "hotel_pdf": hotelPdf,
  };
}

// class TravelHotelGetModel {
//   bool? status;
//   int? code;
//   String? message;
//   Body? body;
//
//   TravelHotelGetModel({this.status, this.code, this.message, this.body});
//
//   TravelHotelGetModel.fromJson(Map<String, dynamic> json) {
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
//   HotelInfo? hotelInfo;
//   Message? message;
//
//   Body({this.hotelInfo, this.message});
//
//   Body.fromJson(Map<String, dynamic> json) {
//     hotelInfo = json['hotel_info'] != null ? new HotelInfo.fromJson(json['hotel_info']) : null;
//     message = json['message'] != null ? new Message.fromJson(json['message']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.hotelInfo != null) {
//       data['hotel_info'] = this.hotelInfo!.toJson();
//     }
//     if (this.message != null) {
//       data['message'] = this.message!.toJson();
//     }
//     return data;
//   }
// }
//
// class HotelInfo {
//   dynamic bookingId;
//   dynamic name;
//   dynamic locationUrl;
//   dynamic checkinDate;
//   dynamic checkoutDate;
//   dynamic roomNumber;
//   dynamic bookedFor;
//   dynamic personCount;
//   dynamic address;
//   dynamic hotelPdf;
//
//   HotelInfo({this.bookingId, this.name, this.locationUrl, this.checkinDate, this.checkoutDate, this.roomNumber, this.bookedFor, this.personCount, this.address, this.hotelPdf});
//
//   HotelInfo.fromJson(Map<String, dynamic> json) {
//     bookingId = json['booking_id'];
//     name = json['name'];
//     locationUrl = json['location_url'];
//     checkinDate = json['checkin_date'];
//     checkoutDate = json['checkout_date'];
//     roomNumber = json['room_number'];
//     bookedFor = json['booked_for'];
//     personCount = json['person_count'];
//     address = json['address'];
//     hotelPdf = json['hotel_pdf'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['booking_id'] = this.bookingId;
//     data['name'] = this.name;
//     data['location_url'] = this.locationUrl;
//     data['checkin_date'] = this.checkinDate;
//     data['checkout_date'] = this.checkoutDate;
//     data['room_number'] = this.roomNumber;
//     data['booked_for'] = this.bookedFor;
//     data['person_count'] = this.personCount;
//     data['address'] = this.address;
//     data['hotel_pdf'] = this.hotelPdf;
//     return data;
//   }
// }
//
// class Message {
//   String? title;
//   String? body;
//   String? icon;
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