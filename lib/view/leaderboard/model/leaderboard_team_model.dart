class LeaderboardTeamModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  LeaderboardTeamModel({this.status, this.code, this.message, this.body});

  LeaderboardTeamModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
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

class Body {
  List<LeaderboardUsers>? users;
  List<LeaderboardUsers>? top3;

  Body({this.users, this.top3});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = <LeaderboardUsers>[];
      json['users'].forEach((v) {
        users!.add(new LeaderboardUsers.fromJson(v));
      });
    }
    if (json['top3'] != null) {
      top3 = <LeaderboardUsers>[];
      json['top3'].forEach((v) {
        top3!.add(new LeaderboardUsers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    if (this.top3 != null) {
      data['top3'] = this.top3!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeaderboardUsers {
  String? id;
  String? name;
  String? company;
  String? position;
  String? avatar;
  String? shortName;
  String? totalPoints;
  String? lastActivity;
  String? rank;

  LeaderboardUsers(
      {this.id,
      this.name,
      this.company,
      this.position,
      this.avatar,
      this.shortName,
      this.totalPoints,
      this.lastActivity,
      this.rank});

  LeaderboardUsers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    company = json['company'];
    position = json['position'];
    avatar = json['avatar'];
    shortName = json['short_name'];
    totalPoints = json['total_points'];
    lastActivity = json['last_activity'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['company'] = this.company;
    data['position'] = this.position;
    data['avatar'] = this.avatar;
    data['short_name'] = this.shortName;
    data['total_points'] = this.totalPoints;
    data['last_activity'] = this.lastActivity;
    data['rank'] = this.rank;
    return data;
  }
}
