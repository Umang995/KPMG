class TimezoneModel {
  bool? status;
  int? code;
  List<TimezoneBody>? body;

  TimezoneModel({this.status, this.code, this.body});

  TimezoneModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['body'] != null) {
      body = <TimezoneBody>[];
      json['body'].forEach((v) {
        body!.add(TimezoneBody.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    if (body != null) {
      data['body'] = body!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimezoneBody {
  String? value;
  String? text;
  Offset? offset;
  String? location;
  String? shortend;

  TimezoneBody({this.value, this.text, this.offset, this.location, this.shortend});

  TimezoneBody.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    text = json['text'];
    offset =
    json['offset'] != null ? new Offset.fromJson(json['offset']) : null;
    location = json['location'];
    shortend = json['shortend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['text'] = this.text;
    if (this.offset != null) {
      data['offset'] = this.offset!.toJson();
    }
    data['location'] = this.location;
    data['shortend'] = this.shortend;
    return data;
  }
}

class Offset {
  String? text;
  int? value;

  Offset({this.text, this.value});

  Offset.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['value'] = this.value;
    return data;
  }
}

/*
class TimezoneBody {
  String? id;
  String? name;
  String? offset;

  TimezoneBody({this.id, this.name});

  TimezoneBody.fromJson(Map<String, dynamic> json) {
    id = json['value'];
    name = json['text'];
    offset = json['offset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = id;
    data['text'] = name;
    data['text'] = offset;
    return data;
  }
}
*/
