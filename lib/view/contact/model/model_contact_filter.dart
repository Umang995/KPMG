class FilterContactModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  FilterContactModel({this.status, this.code, this.message, this.body});

  FilterContactModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class Body {
  List<ContactFilterData>? params;
  int? page;
  Search? search;

  Body({this.params, this.page, this.search});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['params'] != null) {
      params = <ContactFilterData>[];
      json['params'].forEach((v) {
        params!.add(new ContactFilterData.fromJson(v));
      });
    }
    page = json['page'];
    search =
    json['search'] != null ? new Search.fromJson(json['search']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (params != null) {
      data['params'] = params!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    if (search != null) {
      data['search'] = search!.toJson();
    }
    return data;
  }
}

class ContactFilterData {
  String? label;
  String? name;
  String? placeholder;
  String? type;
  String? selectedItem;
  List<Options>? options;

  ContactFilterData(
      {this.label,
        this.name,
        this.placeholder,
        this.type,
        this.selectedItem,
        this.options});

  ContactFilterData.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    name = json['name'];
    placeholder = json['placeholder'];
    type = json['type'];
    selectedItem = json['value'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = label;
    data['name'] = name;
    data['placeholder'] = placeholder;
    data['type'] = type;
    data['value'] = selectedItem;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
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
    data['text'] = text;
    data['value'] = value;
    return data;
  }
}

class Search {
  String? label;
  String? name;
  String? placeholder;
  String? type;
  String? value;

  Search({this.label, this.name, this.placeholder, this.type, this.value});

  Search.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    name = json['name'];
    placeholder = json['placeholder'];
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = label;
    data['name'] = name;
    data['placeholder'] = placeholder;
    data['type'] = type;
    data['value'] = value;
    return data;
  }
}
