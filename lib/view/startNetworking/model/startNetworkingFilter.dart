class StartNetFilterModel {
  Head? head;
  StartNetworkingFilterBody? body;

  StartNetFilterModel({this.head, this.body});

  StartNetFilterModel.fromJson(Map<String, dynamic> json) {
    head = json['head'] != null ? new Head.fromJson(json['head']) : null;
    body = json['body'] != null ? new StartNetworkingFilterBody.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.head != null) {
      data['head'] = this.head!.toJson();
    }
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class Head {
  bool? status;
  int? code;
  String? message;

  Head({this.status, this.code, this.message});

  Head.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}

class StartNetworkingFilterBody {
  List<Params>? params;
  Params? sort;
  Text? text;

  StartNetworkingFilterBody({this.params, this.sort, this.text});

  StartNetworkingFilterBody.fromJson(Map<String, dynamic> json) {
    if (json['params'] != null) {
      params = <Params>[];
      json['params'].forEach((v) {
        params!.add(new Params.fromJson(v));
      });
    }
    sort = json['sort'] != null ? new Params.fromJson(json['sort']) : null;
    text = json['text'] != null ? new Text.fromJson(json['text']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.params != null) {
      data['params'] = this.params!.map((v) => v.toJson()).toList();
    }
    if (this.sort != null) {
      data['sort'] = this.sort!.toJson();
    }
    if (this.text != null) {
      data['text'] = this.text!.toJson();
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
        options!.add(new Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['name'] = this.name;
    data['placeholder'] = this.placeholder;
    data['type'] = this.type;
    data['value'] = this.value;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  String? text;
  String? value;

  Options({this.text, this.value});

  Options.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['name'] = this.name;
    data['placeholder'] = this.placeholder;
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}
