class ServiceModel {
  bool? success;
  String? message;
  Results? results;

  ServiceModel({this.success, this.message, this.results});

  ServiceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    results =
    json['results'] != null ? new Results.fromJson(json['results']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.results != null) {
      data['results'] = this.results!.toJson();
    }
    return data;
  }
}

class Results {
  List<Services>? services;
 // List<Pets>? pets;

  Results({this.services, /*this.pets*/});

  Results.fromJson(Map<String, dynamic> json) {
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
   /* if (json['pets'] != null) {
      pets = <Pets>[];
      json['pets'].forEach((v) {
        pets!.add(new Pets.fromJson(v));
      });
    }*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
   /* if (this.pets != null) {
      data['pets'] = this.pets!.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}

class Services {
  String? sId;
  String? petTypeId;
  String? breedTypeId;
  String? name;
  String? image;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Services(
      {this.sId,
        this.petTypeId,
        this.breedTypeId,
        this.name,
        this.image,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Services.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    petTypeId = json['pet_type_id'];
    breedTypeId = json['breed_type_id'];
    name = json['name'];
    image = json['image'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['pet_type_id'] = this.petTypeId;
    data['breed_type_id'] = this.breedTypeId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Pets {
  String? image;
  String? sId;
  String? name;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Pets(
      {this.image,
        this.sId,
        this.name,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Pets.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    sId = json['_id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}