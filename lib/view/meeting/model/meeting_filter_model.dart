class MeetingFilterModel {
  Body? body;
  bool? status;
  int? code;
  MeetingFilterModel({this.status, this.code, this.body});

  MeetingFilterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class Body {
  List<MeetingFilters>? filters;
  int? page;
  MeetingFilters? date;

  Body({this.filters, this.page, this.date});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['filters'] != null) {
      filters = <MeetingFilters>[];
      json['filters'].forEach((v) {
        filters!.add(new MeetingFilters.fromJson(v));
      });
    }
    page = json['page'];
    date = json['date'] != null ? new MeetingFilters.fromJson(json['date']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (filters != null) {
      data['filters'] = filters!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    if (date != null) {
      data['date'] = date!.toJson();
    }
    return data;
  }
}

class MeetingFilters {
  String? name;
  String? label;
  String? placeholder;
  String? type;
  String? value;
  List<Options>? options;

  MeetingFilters(
      {this.name,
        this.label,
        this.placeholder,
        this.type,
        this.value,
        this.options});

  MeetingFilters.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    label = json['label'];
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
    data['name'] = name;
    data['label'] = label;
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
  String? id;
  String? name;

  Options({this.id, this.name});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['value'];
    name = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = id;
    data['text'] = name;
    return data;
  }
}
