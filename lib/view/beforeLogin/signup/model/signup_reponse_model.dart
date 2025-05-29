class SignupResponseModel {
  Head? head;
  Body? body;

  SignupResponseModel({this.head, this.body});

  SignupResponseModel.fromJson(Map<String, dynamic> json) {
    head = json['head'] != null ? new Head.fromJson(json['head']) : null;
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.head != null) {
      data['head'] = this.head!.toJson();
    }
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class Head {
  bool? status;
  int? code;
  String? message;

  Head({this.status, this.code, this.message});

  Head.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}

class Body {
  String? title;
  String? firstName;
  String? lastName;
  String? department;
  String? email;
  String? mobile;
  String? alternativeMobile;
  String? countryCode;
  String? country;
  String? city;
  String? address;
  String? company;
  String? position;
  String? interestMainArea;
  String? avatar;
  String? govtId;
  String? message;
  String? i_agree;
  String? description;
  Data? data;


  Body(
      {this.title,
      this.firstName,
      this.lastName,
      this.department,
      this.email,
      this.mobile,
        this.alternativeMobile,
      this.countryCode,
      this.country,
      this.city,
      this.address,
      this.company,
      this.position,
      this.interestMainArea,
      this.avatar,
      this.govtId,
      this.message,this.i_agree,this.description,this.data});

  Body.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    department = json['department'];
    email = json['email'];
    mobile = json['mobile'];
    alternativeMobile=json['alternative_mobile'];
    countryCode = json['country_code'];
    country = json['country'];
    city = json['city'];
    address = json['address'];
    company = json['company'];
    position = json['position'];
    interestMainArea = json['interest_main_area'];
    avatar = json['avatar'];
    govtId = json['govt_id'];
    message = json['message'];
    i_agree = json['i_agree'];
    description=json['description'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['department'] = this.department;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['alternative_mobile']=this.alternativeMobile;
    data['country_code'] = this.countryCode;
    data['country'] = this.country;
    data['city'] = this.city;
    data['address'] = this.address;
    data['company'] = this.company;
    data['position'] = this.position;
    data['interest_main_area'] = this.interestMainArea;
    data['avatar'] = this.avatar;
    data['govt_id'] = this.govtId;
    data['message'] = this.message;
    data['i_agree'] = this.i_agree;
    data['description']=this.description;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? organizeMessage;
  Event? event;

  Data({this.organizeMessage, this.event});

  Data.fromJson(Map<String, dynamic> json) {
    organizeMessage = json['organize_message'];
    event = json['event'] != null ? new Event.fromJson(json['event']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['organize_message'] = this.organizeMessage;
    if (this.event != null) {
      data['event'] = this.event!.toJson();
    }
    return data;
  }
}

class Event {
  Datetime? datetime;
  Location? location;

  Event({this.datetime, this.location});

  Event.fromJson(Map<String, dynamic> json) {
    datetime = json['datetime'] != null
        ? new Datetime.fromJson(json['datetime'])
        : null;
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.datetime != null) {
      data['datetime'] = this.datetime!.toJson();
    }
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    return data;
  }
}

class Datetime {
  String? start;
  String? end;
  String? text;

  Datetime({this.start, this.end, this.text});

  Datetime.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start;
    data['end'] = this.end;
    data['text'] = this.text;
    return data;
  }
}

class Location {
  String? text;
  String? map;

  Location({this.text, this.map});

  Location.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    map = json['map'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['map'] = this.map;
    return data;
  }
}

