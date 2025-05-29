
class BookmarkProductModel {
  Body? body;
  bool? status;
  int? code;

  BookmarkProductModel({this.status, this.code, this.body});

  BookmarkProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class Body {
  List<BookmarksProduct>? bookmarks;
  bool? hasNextPage;
  Request? request;

  Body({this.bookmarks, this.hasNextPage, this.request});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['favourites'] != null) {
      bookmarks = <BookmarksProduct>[];
      json['favourites'].forEach((v) {
        bookmarks!.add(new BookmarksProduct.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
    request =
    json['request'] != null ? new Request.fromJson(json['request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bookmarks != null) {
      data['favourites'] = bookmarks!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = hasNextPage;
    if (request != null) {
      data['request'] = request!.toJson();
    }
    return data;
  }
}

class BookmarksProduct {
  String? id;
  Product? product;

  BookmarksProduct({this.id, this.product});

  BookmarksProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class Product {
  String? id;
  String? name;
  String? avatar;

  Product({this.id, this.name, this.avatar});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['avatar'] = avatar;
    return data;
  }
}

class Request {
  dynamic page;
  String? sort;

  Request({this.page, this.sort});

  Request.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['sort'] = sort;
    return data;
  }
}
