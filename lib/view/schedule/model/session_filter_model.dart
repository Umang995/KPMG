class SessionFilterModel {
  SessionFilterBody? body;
  bool? status;
  int? code;
  String? message;
  SessionFilterModel({this.status, this.code, this.message, this.body});

  SessionFilterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null
        ? SessionFilterBody.fromJson(json['body'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class SessionFilterBody {
  List<Params>? params;
  Params? sort;
  Text? text;

  SessionFilterBody({this.params, this.sort, this.text});

  SessionFilterBody.fromJson(Map<String, dynamic> json) {
    if (json['params'] != null) {
      params = <Params>[];
      json['params'].forEach((v) {
        params!.add(Params.fromJson(v));
      });
    }
    sort = json['sort'] != null ? Params.fromJson(json['sort']) : null;
    text = json['text'] != null ? Text.fromJson(json['text']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (params != null) {
      data['params'] = params!.map((v) => v.toJson()).toList();
    }
    if (sort != null) {
      data['sort'] = sort!.toJson();
    }
    if (text != null) {
      data['text'] = text!.toJson();
    }
    return data;
  }
}

class Params {
  String? label;
  String? name;
  String? placeholder;
  String? type;
  dynamic value;
  bool apply=false;
  List<Options>? options;

  Params(
      {this.label,
      this.name,
      this.placeholder,
      this.type,
      this.value,
      this.options});

  Params.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    name = json['name'];
    placeholder = json['placeholder'];
    type = json['type'];
    value = json['value'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['label'] = label;
    data['name'] = name;
    data['placeholder'] = placeholder;
    data['type'] = type;
    data['value'] = value;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  String? text;
  String? value;
  bool apply=false;

  Options({this.text, this.value});

  Options.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['text'] = text;
    data['value'] = value;
    return data;
  }
}

class Text {
  String? label;
  String? name;
  String? placeholder;
  String? type;
  String? value;

  Text({this.label, this.name, this.placeholder, this.type, this.value});

  Text.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    name = json['name'];
    placeholder = json['placeholder'];
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['label'] = label;
    data['name'] = name;
    data['placeholder'] = placeholder;
    data['type'] = type;
    data['value'] = value;
    return data;
  }
}
