class TravelFlightGetModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  TravelFlightGetModel({
    this.status,
    this.code,
    this.message,
    this.body,
  });

  factory TravelFlightGetModel.fromJson(Map<String, dynamic> json) => TravelFlightGetModel(
    status: json["status"],
    code: json["code"],
    message: json["message"],
    body: json["body"] == null ? null : Body.fromJson(json["body"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "body": body?.toJson(),
  };
}

class Body {
  FlightInfo? flightInfo;
  dynamic message;
  dynamic isAdd;

  Body({
    this.flightInfo,
    this.message,
    this.isAdd,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    flightInfo: json["flight_info"] == null ? null : FlightInfo.fromJson(json["flight_info"]),
    message: json["message"],
    isAdd: json["is_add"],
  );

  Map<String, dynamic> toJson() => {
    "flight_info": flightInfo?.toJson(),
    "message": message,
    "is_add": isAdd,
  };
}

class FlightInfo {
  dynamic arrival; // Can be String or Arrival
  dynamic departure; // Can be String or Arrival

  FlightInfo({
    this.arrival,
    this.departure,
  });

  factory FlightInfo.fromJson(Map<String, dynamic> json) => FlightInfo(
    arrival: json["arrival"] is String
        ? json["arrival"]
        : (json["arrival"] == null ? null : Arrival.fromJson(json["arrival"])),
    departure: json["departure"] is String
        ? json["departure"]
        : (json["departure"] == null ? null : Arrival.fromJson(json["departure"])),
  );

  Map<String, dynamic> toJson() => {
    "arrival": arrival is String ? arrival : (arrival as Arrival?)?.toJson(),
    "departure": departure is String ? departure : (departure as Arrival?)?.toJson(),
  };
}

class Arrival {
  String? id;
  String? flightName;
  List<String>? flightFrom;
  List<String>? flightTo;
  String? flightDateTime;
  String? pnrNumber;
  String? ticketPdf;
  String? terminalFrom;
  String? terminalTo;

  Arrival({
    this.id,
    this.flightName,
    this.flightFrom,
    this.flightTo,
    this.flightDateTime,
    this.pnrNumber,
    this.ticketPdf,
    this.terminalFrom,
    this.terminalTo,
  });

  factory Arrival.fromJson(Map<String, dynamic> json) => Arrival(
    id: json["id"],
    flightName: json["flight_name"],
    flightFrom: json["flight_from"] == null ? [] : List<String>.from(json["flight_from"]!.map((x) => x)),
    flightTo: json["flight_to"] == null ? [] : List<String>.from(json["flight_to"]!.map((x) => x)),
    flightDateTime: json["flight_date_time"],
    pnrNumber: json["pnr_number"],
    ticketPdf: json["ticket_pdf"],
    terminalFrom: json["terminal_from"],
    terminalTo: json["terminal_to"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "flight_name": flightName,
    "flight_from": flightFrom == null ? [] : List<dynamic>.from(flightFrom!.map((x) => x)),
    "flight_to": flightTo == null ? [] : List<dynamic>.from(flightTo!.map((x) => x)),
    "flight_date_time": flightDateTime,
    "pnr_number": pnrNumber,
    "ticket_pdf": ticketPdf,
    "terminal_from": terminalFrom,
    "terminal_to": terminalTo,
  };
}
