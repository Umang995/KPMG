
class ProductFilterModel {
  ProductFilter? body;
  bool? status;
  int? code;

  ProductFilterModel({this.body,this.status, this.code});

  ProductFilterModel.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? new ProductFilter.fromJson(json['body']) : null;
    status = json['status'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class ProductFilter {
  List<Filters>? filters;
  int? page;
  Sort? sort;
  Search? search;

  ProductFilter({this.filters, this.page, this.sort, this.search});

  ProductFilter.fromJson(Map<String, dynamic> json) {
    if (json['params'] != null) {
      filters = <Filters>[];
      json['params'].forEach((v) {
        filters!.add(new Filters.fromJson(v));
      });
    }
    page = json['page'];
    sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
    search =
    json['text'] != null ? new Search.fromJson(json['text']) : null;
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
      data['text'] = this.search!.toJson();
    }
    return data;
  }
}

class Filters {
  String? name;
  bool isExpend=false;
  List<Options>? options;
  String? label;
  String? placeholder;
  String? type;
  List<Options>? value;

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
    if (json['value'] != null) {
      value = <Options>[];
      json['value'].forEach((v) {
        value!.add(new Options.fromJson(v));
      });
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
    if (this.value != null) {
      data['value'] = this.value!.map((v) => v.toJson()).toList();
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
    data['value'] = this.id;
    data['text'] = this.name;
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
