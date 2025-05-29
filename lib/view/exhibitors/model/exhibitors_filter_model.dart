class ExhibitorsFilterModel {
  bool? status;
  int? code;
  String? message;
  ExhibitorFilterData? body;

  ExhibitorsFilterModel({this.status, this.code, this.message, this.body});

  ExhibitorsFilterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? new ExhibitorFilterData.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class ExhibitorFilterData {
  List<Filters>? filters;
  RadioFilterData? text;
  RadioFilterData? notes;
  Filters? sort;



  ExhibitorFilterData({this.filters,this.text,this.notes,this.sort,});

  ExhibitorFilterData.fromJson(Map<String, dynamic> json) {
    if (json['params'] != null) {
      filters = <Filters>[];
      json['params'].forEach((v) {
        filters!.add(new Filters.fromJson(v));
      });
    }
    sort = json['sort'] != null ? new Filters.fromJson(json['sort']) : null;
    text = json['text'] != null ? new RadioFilterData.fromJson(json['text']) : null;
    notes = json['notes'] != null ? new RadioFilterData.fromJson(json['notes']) : null;

  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.filters != null) {
      data['params'] = this.filters!.map((v) => v.toJson()).toList();
    }
    if (this.text != null) {
      data['search'] = this.text!.toJson();
    }
    if (this.sort != null) {
      data['sort'] = this.sort!.toJson();
    }
    return data;
  }
}

class Filters {
  String? name;
  List<Options>? options;
  String? label;
  String? placeholder;
  String? type;
  dynamic value;
  bool apply=false;

  Filters(
      {this.name,
      this.options,
      this.label,
      this.placeholder,
      this.type,
      this.value});

  Filters.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
    label = json['label'];
    placeholder = json['placeholder'];
    type = json['type'];
    if (json['type'] is String) {
      value = json['value'];
    } else {
      value = json['value'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    data['label'] = this.label;
    data['placeholder'] = this.placeholder;
    data['type'] = this.type;
    if (data['type'] is String) {
      data['value'] = this.value;
    } else {
      data['value'] = this.value;
    }
    return data;
  }
}

class Options {
  String? id;
  String? name;
  bool apply=false;

  Options({this.id, this.name});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['value'];
    name = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.id;
    data['text'] = this.name;
    return data;
  }
}

class RadioFilterData {
  String? label;
  String? name;
  String? placeholder;
  String? type;
  dynamic value;
  bool apply=false;
  RadioFilterData({this.label, this.name, this.placeholder, this.type, this.value});

  RadioFilterData.fromJson(Map<String, dynamic> json) {
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
