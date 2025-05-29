

class TravelVisaGetModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  TravelVisaGetModel({
    this.status,
    this.code,
    this.message,
    this.body,
  });


  factory TravelVisaGetModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? bodyJson = json["body"];
    return TravelVisaGetModel(
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
  String? visaFile;
  dynamic message;
  dynamic isAdd;

  Body({
    this.visaFile,
    this.message,
    this.isAdd,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    visaFile: json["visa_file"],
    message: json["message"],
    isAdd: json["is_add"],
  );

  Map<String, dynamic> toJson() => {
    "visa_file": visaFile,
    "message": message,
    "is_add": isAdd,
  };
}
