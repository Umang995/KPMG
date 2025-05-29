import '../../partners/model/partnersModel.dart';

class HomePageModel {
  bool? status;
  int? code;
  String? message;
  HomeConfigBody? homeConfigBody;

  HomePageModel({this.status, this.code, this.message, this.homeConfigBody});

  HomePageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    homeConfigBody =
        json['body'] != null ? HomeConfigBody.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.homeConfigBody != null) {
      data['body'] = this.homeConfigBody!.toJson();
    }
    return data;
  }
}

class HomeConfigBody {
  String? name;
  String? deepLink;
  List<Banners>? banners;
  List<Partner>? sponsors;
  List<SocialLinks>? socialLinks;
  String? description;
  String? heroBanner;
  Organizers? organizers;
  Location? location;
  Datetime? datetime;
  SocialWall? socialWall;
  Welcome? welcomeContent;
  CountdownBanner? countdownBanner;
  HomeConfigBody(
      {this.name,
      this.banners,
      this.sponsors,
      this.socialLinks,
      this.description,
      this.organizers,
      this.countdownBanner,
      this.welcomeContent,
      this.heroBanner,this.deepLink,this.location,this.datetime,this.socialWall});

  HomeConfigBody.fromJson(Map<String, dynamic> json) {
    organizers = json['organizers'] != null
        ? new Organizers.fromJson(json['organizers'])
        : null;
    datetime = json['datetime'] != null
        ? new Datetime.fromJson(json['datetime'])
        : null;
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    socialWall = json['social_wall'] != null
        ? new SocialWall.fromJson(json['social_wall'])
        : null;

    name = json['name'];
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(new Banners.fromJson(v));
      });
    }
    if (json['sponsors'] != null) {
      sponsors = <Partner>[];
      json['sponsors'].forEach((v) {
        sponsors!.add(new Partner.fromJson(v));
      });
    }
    if (json['social_media_links'] != null) {
      socialLinks = <SocialLinks>[];
      json['social_media_links'].forEach((v) {
        socialLinks!.add(new SocialLinks.fromJson(v));
      });
    }
    welcomeContent =
        json['welcome'] != null ? new Welcome.fromJson(json['welcome']) : null;
    countdownBanner = json['countdown_banner'] != null
        ? new CountdownBanner.fromJson(json['countdown_banner'])
        : null;
    description = json['description'];
    heroBanner = json['hero_banner'];
    deepLink = json['deeplink'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['social_wall'] = this.socialWall;
    data['organizers'] = this.organizers;
    data['location'] = this.location;
    data['datetime'] = this.datetime;

    if (this.welcomeContent != null) {
      data['welcome'] = this.welcomeContent!.toJson();
    }
    if (this.countdownBanner != null) {
      data['countdown_banner'] = this.countdownBanner!.toJson();
    }
    if (this.banners != null) {
      data['banners'] = this.banners!.map((v) => v.toJson()).toList();
    }
    if (this.sponsors != null) {
      data['sponsors'] = this.sponsors!.map((v) => v.toJson()).toList();
    }
    if (this.socialLinks != null) {
      data['social_media_links'] =
          this.socialLinks!.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    data['hero_banner'] = this.heroBanner;
    data['deeplink'] = this.deepLink;
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

class Banners {
  String? name;
  String? thumbnail;

  Banners({this.name, this.thumbnail});

  Banners.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    thumbnail = json['media'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['media'] = this.thumbnail;
    return data;
  }
}

class SocialLinks {
  String? label;
  String? type;
  bool? status;
  String? url;

  SocialLinks({this.label, this.type, this.status, this.url});

  SocialLinks.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    type = json['type'];
    status = json['status'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['type'] = this.type;
    data['status'] = this.status;
    data['url'] = this.url;
    return data;
  }
}

class Welcome {
  String? title;
  String? description;
  String? text;
  String? mediaType;
  String? mediaVideo;
  String? media;

  Welcome(
      {this.title,
      this.description,
      this.text,
      this.mediaType,
      this.mediaVideo,
      this.media});

  Welcome.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    text = json['text'];
    mediaType = json['media_type'];
    mediaVideo = json['media_video'];
    media = json['media'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['text'] = this.text;
    data['media_type'] = this.mediaType;
    data['media_video'] = this.mediaVideo;
    data['media'] = this.media;
    return data;
  }
}

class Organizers {
  HelpDeskChat? helpDeskChat;
  EventFeed? eventFeed;

  Organizers({this.helpDeskChat, this.eventFeed});

  Organizers.fromJson(Map<String, dynamic> json) {
    helpDeskChat = json['help_desk_chat'] != null
        ? new HelpDeskChat.fromJson(json['help_desk_chat'])
        : null;
    eventFeed = json['event_feed'] != null
        ? new EventFeed.fromJson(json['event_feed'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.helpDeskChat != null) {
      data['help_desk_chat'] = this.helpDeskChat!.toJson();
    }
    if (this.eventFeed != null) {
      data['event_feed'] = this.eventFeed!.toJson();
    }
    return data;
  }
}

class HelpDeskChat {
  String? id;
  String? vendor;
  String? role;
  String? shortName;
  String? name;
  String? avatar;

  HelpDeskChat(
      {this.id,
      this.vendor,
      this.role,
      this.shortName,
      this.name,
      this.avatar});

  HelpDeskChat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendor = json['vendor'];
    role = json['role'];
    shortName = json['short_name'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['vendor'] = vendor;
    data['role'] = role;
    data['short_name'] = shortName;
    data['name'] = name;
    data['avatar'] = avatar;
    return data;
  }
}

class EventFeed {
  String? id;
  String? vendor;
  String? role;
  String? shortName;
  String? name;
  String? avatar;

  EventFeed(
      {this.id,
      this.vendor,
      this.role,
      this.shortName,
      this.name,
      this.avatar});

  EventFeed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendor = json['vendor'];
    role = json['role'];
    shortName = json['short_name'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['vendor'] = vendor;
    data['role'] = role;
    data['short_name'] = shortName;
    data['name'] = name;
    data['avatar'] = avatar;
    return data;
  }
}

class Location {
  String? text;
  String? map;
  String? shortText;
  String? image;
  String? title;
  String? url;

  Location(
      {this.text, this.map, this.shortText, this.image, this.title, this.url});

  Location.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    shortText = json['short_text'];
    map = json['map'];
    image = json['image'];
    title = json['title'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['short_text'] = this.shortText;
    data['map'] = this.map;
    data['image'] = this.image;
    data['title'] = this.title;
    data['url'] = this.url;
    return data;
  }
}

class SocialWall {
  String? url;
  String? hashtag;
  String? title;

  SocialWall({this.url, this.hashtag, this.title});

  SocialWall.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    hashtag = json['hashtag'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['hashtag'] = this.hashtag;
    data['title'] = this.title;
    return data;
  }
}

class CountdownBanner {
  Live? live;
  Live? end;

  CountdownBanner({this.live, this.end});

  CountdownBanner.fromJson(Map<String, dynamic> json) {
    live = json['live'] != null ? new Live.fromJson(json['live']) : null;
    end = json['end'] != null ? new Live.fromJson(json['end']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.live != null) {
      data['live'] = this.live!.toJson();
    }
    if (this.end != null) {
      data['end'] = this.end!.toJson();
    }
    return data;
  }
}

class Live {
  String? title;
  String? description;
  String? image;

  Live({this.title, this.description, this.image});

  Live.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    return data;
  }
}
