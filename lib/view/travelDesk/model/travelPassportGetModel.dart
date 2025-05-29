class TravelPassportGetModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  TravelPassportGetModel({
    this.status,
    this.code,
    this.message,
    this.body,
  });

  factory TravelPassportGetModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? bodyJson = json["body"];
    return TravelPassportGetModel(
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
  dynamic passportInfo;
  dynamic message;
  dynamic isAdd;

  Body({
    this.passportInfo,
    this.message,
    this.isAdd,
  });

  factory Body.fromJson(Map<String, dynamic> json) {
    var passportInfoData = json["passport_info"];
    dynamic passportInfo;

    if (passportInfoData is Map<String, dynamic>) {
      // Check if all values in the map are null
      bool allValuesNull = passportInfoData.values.every((value) => value == null);
      if (!allValuesNull) {
        passportInfo = PassportInfo.fromJson(passportInfoData);
      } else {
        passportInfo = null; // Treat as if it's empty
      }
    } else if (passportInfoData is List && passportInfoData.isNotEmpty) {
      passportInfo = passportInfoData;
    }

    return Body(
      passportInfo: passportInfo,
      message: json["message"],
      isAdd: json["is_add"],
    );
  }



  Map<String, dynamic> toJson() => {
    "passport_info": passportInfo is PassportInfo
        ? (passportInfo as PassportInfo).toJson()
        : passportInfo,
    "message": message,
    "is_add": isAdd,
  };
}

class PassportInfo {
  String? frontFile;
  String? backFile;
  String? number;
  String? passportName;
  DateTime? validFrom;
  DateTime? validTill;

  PassportInfo({
    this.frontFile,
    this.backFile,
    this.number,
    this.passportName,
    this.validFrom,
    this.validTill,
  });

  factory PassportInfo.fromJson(Map<String, dynamic> json) => PassportInfo(
    frontFile: json["front_file"],
    backFile: json["back_file"],
    number: json["number"],
    passportName: json["passport_name"],
    validFrom: json["valid_from"] == null
        ? null
        : DateTime.tryParse(json["valid_from"]),
    validTill: json["valid_till"] == null
        ? null
        : DateTime.tryParse(json["valid_till"]),
  );

  Map<String, dynamic> toJson() => {
    "front_file": frontFile,
    "back_file": backFile,
    "number": number,
    "passport_name": passportName,
    "valid_from": validFrom != null
        ? "${validFrom!.year.toString().padLeft(4, '0')}-${validFrom!.month.toString().padLeft(2, '0')}-${validFrom!.day.toString().padLeft(2, '0')}"
        : null,
    "valid_till": validTill != null
        ? "${validTill!.year.toString().padLeft(4, '0')}-${validTill!.month.toString().padLeft(2, '0')}-${validTill!.day.toString().padLeft(2, '0')}"
        : null,
  };
}
