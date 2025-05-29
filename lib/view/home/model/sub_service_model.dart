class SubServiceModel {
  bool? success;
  String? message;
  Results? results;

  SubServiceModel({this.success, this.message, this.results});

  SubServiceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    results =
    json['results'] != null ? new Results.fromJson(json['results']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = success;
    data['message'] = message;
    if (results != null) {
      data['results'] = results!.toJson();
    }
    return data;
  }
}

class Results {
  List<Data>? data;
  int? count;
  int? totalDocs;
  int? limit;
  int? page;
  int? totalPages;
  int? pagingCounter;
  bool? hasPrevPage;
  bool? hasNextPage;
  int? prevPage;
  int? nextPage;

  Results(
      {this.data,
        this.count,
        this.totalDocs,
        this.limit,
        this.page,
        this.totalPages,
        this.pagingCounter,
        this.hasPrevPage,
        this.hasNextPage,
        this.prevPage,
        this.nextPage});

  Results.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    count = json['count'];
    totalDocs = json['totalDocs'];
    limit = json['limit'];
    page = json['page'];
    totalPages = json['totalPages'];
    pagingCounter = json['pagingCounter'];
    hasPrevPage = json['hasPrevPage'];
    hasNextPage = json['hasNextPage'];
    prevPage = json['prevPage'];
    nextPage = json['nextPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    data['totalDocs'] = totalDocs;
    data['limit'] = limit;
    data['page'] = page;
    data['totalPages'] = totalPages;
    data['pagingCounter'] = pagingCounter;
    data['hasPrevPage'] = hasPrevPage;
    data['hasNextPage'] = hasNextPage;
    data['prevPage'] = prevPage;
    data['nextPage'] = nextPage;
    return data;
  }
}

class Data {
  String? sId;
  String? petTypeId;
  String? petName;
  int? petStatus;
  String? petImage;
  String? serviceName;
  int? serviceStatus;
  String? serviceImage;
  String? createdAt;
  String? updatedAt;
  List<SubserviceData>? subserviceData;

  Data(
      {this.sId,
        this.petTypeId,
        this.petName,
        this.petStatus,
        this.petImage,
        this.serviceName,
        this.serviceStatus,
        this.serviceImage,
        this.createdAt,
        this.updatedAt,
        this.subserviceData});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    petTypeId = json['pet_type_id'];
    petName = json['pet_name'];
    petStatus = json['pet_status'];
    petImage = json['pet_image'];
    serviceName = json['service_name'];
    serviceStatus = json['service_status'];
    serviceImage = json['service_image'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['subserviceData'] != null) {
      subserviceData = <SubserviceData>[];
      json['subserviceData'].forEach((v) {
        subserviceData!.add(new SubserviceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = sId;
    data['pet_type_id'] = petTypeId;
    data['pet_name'] = petName;
    data['pet_status'] = petStatus;
    data['pet_image'] = petImage;
    data['service_name'] = serviceName;
    data['service_status'] = serviceStatus;
    data['service_image'] = serviceImage;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (subserviceData != null) {
      data['subserviceData'] =
          subserviceData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubserviceData {
  bool isSelected=false;
  String name="";
  int? status;
  String? createdAt;
  dynamic price;
  dynamic time;
  String? subServiceId;

  SubserviceData(
      {required this.name,
        this.status,
        this.createdAt,
        this.price,
        this.time,
        this.subServiceId});

  SubserviceData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    status = json['status'];
    createdAt = json['createdAt'];
    price = json['price'];
    time = json['time'];
    subServiceId = json['sub_service_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['price'] = price;
    data['time'] = time;
    data['sub_service_id'] = subServiceId;
    return data;
  }
}