

class AddEditNotesModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  AddEditNotesModel({
    this.status,
    this.code,
    this.message,
    this.body,
  });

  factory AddEditNotesModel.fromJson(Map<String, dynamic> json) => AddEditNotesModel(
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
  String? id;
  String? text;

  Body({
    this.id,
    this.text,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    id: json["id"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
  };
}
