

class GetAirportsModel {
  bool? status;
  int? code;
  String? message;
  List<AirportsDetails>? body;

  GetAirportsModel({
    this.status,
    this.code,
    this.message,
    this.body,
  });

  factory GetAirportsModel.fromJson(Map<String, dynamic> json) => GetAirportsModel(
    status: json["status"],
    code: json["code"],
    message: json["message"],
    body: json["body"] == null ? [] : List<AirportsDetails>.from(json["body"]!.map((x) => AirportsDetails.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "body": body == null ? [] : List<dynamic>.from(body!.map((x) => x.toJson())),
  };
}

class AirportsDetails {
  String? id;
  String? name;
  String? city;
  String? code;

  AirportsDetails({
    this.id,
    this.name,
    this.city,
    this.code,
  });

  factory AirportsDetails.fromJson(Map<String, dynamic> json) => AirportsDetails(
    id: json["id"],
    name: json["name"],
    city: json["city"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "city": city,
    "code": code,
  };
}
