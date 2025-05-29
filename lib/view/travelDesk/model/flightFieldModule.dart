class FlightFieldModel {
  bool? status;
  int? code;
  String? message;
  List<FlightFields>? body;

  FlightFieldModel({
    this.status,
    this.code,
    this.message,
    this.body,
  });

  factory FlightFieldModel.fromJson(Map<String, dynamic> json) =>
      FlightFieldModel(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        body: json["body"] == null
            ? []
            : List<FlightFields>.from(
                json["body"]!.map((x) => FlightFields.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "body": body == null
            ? []
            : List<FlightFields>.from(body!.map((x) => x.toJson())),
      };
}

class FlightFields {
  String? name;
  dynamic size;
  int? step;
  String? type;
  String? bodyClass;
  String? label;
  String? rules;
  dynamic value;
  String? accept;
  List<Options>? options;
  bool? readonly;
  dynamic cropWidth;
  dynamic cropHeight;
  dynamic aspectRatio;
  dynamic errorLabel;
  dynamic placeholder;
  dynamic displayOrder;
  bool? aiFormField;
  String? poster;

  FlightFields({
    this.name,
    this.size,
    this.step,
    this.type,
    this.bodyClass,
    this.label,
    this.rules,
    this.value,
    this.accept,
    this.options,
    this.readonly,
    this.cropWidth,
    this.cropHeight,
    this.aspectRatio,
    this.errorLabel,
    this.placeholder,
    this.displayOrder,
    this.aiFormField,
    this.poster,
  });

  factory FlightFields.fromJson(Map<String, dynamic> json) => FlightFields(
        name: json["name"],
        size: json["size"],
        step: json["step"],
        type: json["type"],
        bodyClass: json["class"],
        label: json["label"],
        rules: json["rules"],
        value: json["value"],
        options: json["options"] == null
            ? []
            : List<Options>.from(json["options"]!.map((x) => x)),
        readonly: json["readonly"],
        cropWidth: json["cropWidth"],
        cropHeight: json["cropHeight"],
        aspectRatio: json["aspectRatio"],
        errorLabel: json["error_label"],
        placeholder: json["placeholder"],
        displayOrder: json["display_order"],
        aiFormField: json["aiFormField"],
        poster: json["poster"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "size": size,
        "step": step,
        "type": type,
        "class": bodyClass,
        "label": label,
        "rules": rules,
        "value": value,
        "options":
            options == null ? [] : List<Options>.from(options!.map((x) => x)),
        "readonly": readonly,
        "cropWidth": cropWidth,
        "cropHeight": cropHeight,
        "aspectRatio": aspectRatio,
        "error_label": errorLabel,
        "placeholder": placeholder,
        "display_order": displayOrder,
        "aiFormField": aiFormField,
        "poster": poster,
      };
}

class Options {
  dynamic value;
  String? text;
  bool isTrue = false;

  Options({this.value, this.text});

  Options.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = value;
    data['text'] = text;
    return data;
  }
}
