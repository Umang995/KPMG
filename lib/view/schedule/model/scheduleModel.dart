import 'package:get/get.dart';

import '../../speakers/model/speakersModel.dart';

class ScheduleModel {
  Body? body;
  bool? status;
  int? code;
  ScheduleModel({this.status, this.code, this.body});
  ScheduleModel.fromJson(Map<String, dynamic> json) {
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
  List<SessionsData>? sessions;
  bool? hasNextPage;
  Request? request;

  Body({
    this.sessions,
    this.hasNextPage,
    this.request,
  });

  Body.fromJson(Map<String, dynamic> json) {
    if (json['webinars'] != null) {
      sessions = <SessionsData>[];
      json['webinars'].forEach((v) {
        sessions!.add(new SessionsData.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
    request =
        json['request'] != null ? new Request.fromJson(json['request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (sessions != null) {
      data['webinars'] = sessions!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = hasNextPage;
    if (request != null) {
      data['request'] = request!.toJson();
    }
    return data;
  }
}

class SessionsData {
  var isLoading = false.obs;
  String? id;
  String? label;
  String? startDatetime;
  String? endDatetime;
  String? description;
  String? shortDescription;
  String? embed;
  String? embedPlayer;
  String? thumbnail;
  Status? status;
  List<SpeakersData>? speakers = [];
  String? bookmark;
  Auditorium? auditorium;
  List<Banners>? sessionBanner;
  dynamic keywords;
  dynamic isOnlineStream;

  String? isBooking; //auto_approval, admin_assign,admin_approval ,null also
  dynamic isSeatBooked; //default is null, in other case it is 0 or 1
  dynamic
      isRevoke; //default is false, in other case it is true=>you can revoke the seat
  int? availableSeats;
  dynamic?
      canBook; //default is false, in other case it is true=>you can book the seat

  SessionsData(
      {this.id,
      this.label,
      this.startDatetime,
      this.endDatetime,
      this.description,
      this.shortDescription,
      this.embed,
      this.embedPlayer,
      this.thumbnail,
      this.status,
      this.speakers,
      this.bookmark,
      this.auditorium,
      this.sessionBanner,
      this.keywords,
      this.isOnlineStream});

  SessionsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['name'];
    startDatetime = json['start_datetime'];
    endDatetime = json['end_datetime'];
    description = json['description'];
    shortDescription = json['short_description'];
    embed = json['embed'];
    embedPlayer = json['embed_player'];
    thumbnail = json['thumbnail'];
    isOnlineStream = json['is_online_stream'];
    isBooking = json['booking_type']; //kya insme booking h kya
    isSeatBooked = json['is_seat_book']; //mane isme seat book ker rehkhi h kya
    availableSeats = json['available_seats']; //mane kitni seats available h
    isRevoke = json['is_revoke']; //mane kya isme revoke h
    canBook = json['can_book']; //kya me book ker sakta hu

    if (json['status'] != null && json['status'] is int) {
      status = json['status'];
    } else {
      status =
          json['status'] != null ? new Status.fromJson(json['status']) : null;
    }

    if (json['keywords'] != null && json['keywords'] is List) {
      keywords = json['keywords'].cast<String>();
    } else {
      keywords = json['keywords'];
    }
    auditorium = json['auditorium'] != null
        ? new Auditorium.fromJson(json['auditorium'])
        : null;
    if (json['speakers'] != null) {
      speakers = <SpeakersData>[];
      json['speakers'].forEach((v) {
        speakers!.add(new SpeakersData.fromJson(v));
      });
    }
    bookmark = json['favourite'];
    if (json['banners'] != null) {
      sessionBanner = <Banners>[];
      json['banners'].forEach((v) {
        sessionBanner!.add(new Banners.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = label;
    data['start_datetime'] = startDatetime;
    data['end_datetime'] = endDatetime;
    data['description'] = description;
    data['short_description'] = shortDescription;
    data['favourite'] = bookmark;
    data['embed'] = embed;
    data['embed_player'] = embedPlayer;
    data['thumbnail'] = thumbnail;
    data['keywords'] = keywords;
    data['is_online_stream'] = isOnlineStream;

    data['booking_type'] = isBooking; //kya insme booking h kya
    data['is_seat_book'] = isSeatBooked; //mane isme seat book ker rehkhi h kya
    data['available_seats'] = availableSeats; //mane kitni seats available h
    data['is_revoke'] = isRevoke; //mane kya isme revoke h
    data['can_book'] = canBook; //kya me book ker sakta hu

    if (speakers != null) {
      data['speakers'] = speakers!.map((v) => v.toJson()).toList();
    }
    if (status != null) {
      data['status'] = status!.toJson();
    }
    if (sessionBanner != null) {
      data['banners'] = sessionBanner!.map((v) => v.toJson()).toList();
    }
    if (this.auditorium != null) {
      data['auditorium'] = this.auditorium!.toJson();
    }
    return data;
  }
}

class Status {
  String? color;
  String? text;
  int? value;

  Status({this.color, this.text, this.value});

  Status.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    text = json['text'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['color'] = color;
    data['text'] = text;
    data['value'] = value;
    return data;
  }
}

class Moderate {
  String? id;
  String? name;
  String? shortName;
  String? company;
  String? position;
  String? avatar;
  String? role;
  String? timezone;
  String? accessType;

  Moderate(
      {this.id,
      this.name,
      this.shortName,
      this.company,
      this.position,
      this.avatar,
      this.role,
      this.timezone,
      this.accessType});

  Moderate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortName = json['short_name'];
    company = json['company'];
    position = json['position'];
    avatar = json['avatar'];
    role = json['role'];
    timezone = json['timezone'];
    accessType = json['access_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['short_name'] = shortName;
    data['company'] = company;
    data['position'] = position;
    data['avatar'] = avatar;
    data['role'] = role;
    data['timezone'] = timezone;
    data['access_type'] = accessType;
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

class Auditorium {
  String? value;
  String? text;
  String? thumbnail;
  List<String>? controls;
  List<Emoticons>? emoticons;
  List<Ratings>? ratings;

  Auditorium({this.value, this.text, this.thumbnail, this.emoticons});

  Auditorium.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    text = json['text'];
    thumbnail = json['thumbnail'];
    controls = json['controls'] != null
        ? json['controls'].cast<String>()
        : controls = <String>[];

    if (json['emoticons'] != null) {
      emoticons = <Emoticons>[];
      json['emoticons'].forEach((v) {
        emoticons!.add(new Emoticons.fromJson(v));
      });
    }
    if (json['ratings'] != null) {
      ratings = <Ratings>[];
      json['ratings'].forEach((v) {
        ratings!.add(new Ratings.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = value;
    data['text'] = text;
    data['thumbnail'] = thumbnail;
    data['controls'] = controls;
    if (this.emoticons != null) {
      data['emoticons'] = this.emoticons!.map((v) => v.toJson()).toList();
    }
    if (this.ratings != null) {
      data['ratings'] = this.ratings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Emoticons {
  String? text;
  dynamic value;

  Emoticons({this.text, this.value});

  Emoticons.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['value'] = this.value;
    return data;
  }
}

class Ratings {
  String? reaction;
  int? value;

  Ratings({this.reaction, this.value});

  Ratings.fromJson(Map<String, dynamic> json) {
    reaction = json['reaction'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reaction'] = this.reaction;
    data['value'] = this.value;
    return data;
  }
}

class Banners {
  String? image;

  Banners({this.image});

  Banners.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = image;
    return data;
  }
}
