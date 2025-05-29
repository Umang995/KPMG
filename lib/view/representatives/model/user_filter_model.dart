class RepresentativeFilterModel {
  UserBodyFilter? body;
  bool? status;
  int? code;
  String? message;

  RepresentativeFilterModel({this.status, this.code, this.message, this.body});

  RepresentativeFilterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? new UserBodyFilter.fromJson(json['body']) : null;
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

class UserBodyFilter {
  List<Filters>? filters=[];
  int? page;
  Filters? sort;
  Search? search;
  Notes? notes;
  Notes? isBlocked;

  UserBodyFilter({this.filters, this.page, this.sort,this.search});

  UserBodyFilter.fromJson(Map<String, dynamic> json) {
    if (json['params'] != null) {
      filters = <Filters>[];
      json['params'].forEach((v) {
        filters!.add(Filters.fromJson(v));
      });
    }
    page = json['page'];
    sort = json['sort'] != null ? new Filters.fromJson(json['sort']) : null;
    search =
    json['search'] != null ? new Search.fromJson(json['search']) : null;
    notes = json['notes'] != null ? new Notes.fromJson(json['notes']) : null;
    isBlocked = json['is_blocked'] != null
        ? new Notes.fromJson(json['is_blocked'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.filters != null) {
      data['params'] = this.filters!.map((v) => v.toJson()).toList();
    }
    data['page'] = this.page;
    if (this.sort != null) {
      data['sort'] = this.sort!.toJson();
    }
    if (this.search != null) {
      data['search'] = this.search!.toJson();
    }
    if (this.notes != null) {
      data['notes'] = this.notes!.toJson();
    }
    if (this.isBlocked != null) {
      data['is_blocked'] = this.isBlocked!.toJson();
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
  bool apply=false;
  dynamic value;

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
    value = json['value'];
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
    data['value'] = this.value;
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
    data['label'] = this.label;
    data['name'] = this.name;
    data['placeholder'] = this.placeholder;
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}

class Notes {
  String? label;
  String? name;
  String? placeholder;
  String? type;
  bool? value;
  bool apply=false;

  Notes({this.label, this.name, this.placeholder, this.type, this.value});

  Notes.fromJson(Map<String, dynamic> json) {
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
