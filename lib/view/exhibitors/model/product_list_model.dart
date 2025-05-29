class ProductListModel {
  Body? body;
  bool? status;
  int? code;
  ProductListModel({this.status, this.code, this.body});

  ProductListModel.fromJson(Map<String, dynamic> json) {
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
  List<Products>? products;
  bool? hasNextPage;
  Request? request;

  Body({this.products, this.hasNextPage, this.request});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
    request =
    json['request'] != null ? new Request.fromJson(json['request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = hasNextPage;
    if (request != null) {
      data['request'] = request!.toJson();
    }
    return data;
  }
}

class Products {
  String? id;
  String? vendor;
  String? name;
  String? avatar;
  Exhibitor? exhibitor;
  dynamic favourite;

  Products(
      {this.id,
        this.vendor,
        this.name,
        this.avatar,
        this.exhibitor,
        this.favourite});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendor = json['vendor'];
    name = json['name'];
    avatar = json['avatar'];
    exhibitor = json['exhibitor.json'] != null
        ? new Exhibitor.fromJson(json['exhibitor.json'])
        : null;
    favourite = json['favourite'];
    /*favourite = json['favourite'] != null
        ? new Favourite.fromJson(json['favourite'])
        : null;*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['vendor'] = vendor;
    data['name'] = name;
    data['avatar'] = avatar;
    data['favourite'] = favourite;
    if (exhibitor != null) {
      data['exhibitor.json'] = exhibitor!.toJson();
    }
   /* if (this.favourite != null) {
      data['favourite'] = this.favourite!.toJson();
    }*/
    return data;
  }
}

class Exhibitor {
  String? id;
  String? name;

  Exhibitor({this.id, this.name});

  Exhibitor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Favourite {
  String? id;

  Favourite({this.id});

  Favourite.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    return data;
  }
}

class Request {
  String? search;
  dynamic page;
  String? sort;

  Request({this.search, this.page, this.sort});

  Request.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    page = json['page'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search'] = search;
    data['page'] = page;
    data['sort'] = sort;
    return data;
  }
}
