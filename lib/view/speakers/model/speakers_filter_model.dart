class SpeakersFilterModel {
  SpeakerFilterData? body;
  bool? status;
  int? code;
  SpeakersFilterModel({this.status, this.code, this.body});

  SpeakersFilterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    body = json['body'] != null ? SpeakerFilterData.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class SpeakerFilterData {
  List<Filters>? filters=[];
  int? page;
  Filters? sort;
  Search? search;
  Notes? notes;
  Notes? isBlocked;

  SpeakerFilterData({this.filters, this.page, this.sort,this.search});

  SpeakerFilterData.fromJson(Map<String, dynamic> json) {
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
    notes = json['note'] != null ? new Notes.fromJson(json['note']) : null;
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
      data['note'] = this.notes!.toJson();
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
        options!.add(Options.fromJson(v));
      });
    }
    label = json['label'];
    placeholder = json['placeholder'];
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    data['label'] = label;
    data['placeholder'] = placeholder;
    data['type'] = type;
    data['value'] = value;
    return data;
  }
}

class Options {
  String? name;
  String? id;
  bool apply=false;

  Options({this.name, this.id});

  Options.fromJson(Map<String, dynamic> json) {
    name = json['text'];
    id = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['text'] = name;
    data['value'] = id;
    return data;
  }
}

class Sort {
  String? label;
  String? name;
  String? placeholder;
  String? type;
  String? value;
  List<Options>? options;

  Sort(
      {this.label,
        this.name,
        this.placeholder,
        this.type,
        this.value,
        this.options});

  Sort.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['label'] = label;
    data['name'] = name;
    data['placeholder'] = placeholder;
    data['type'] = type;
    data['value'] = value;
    return data;
  }
}
