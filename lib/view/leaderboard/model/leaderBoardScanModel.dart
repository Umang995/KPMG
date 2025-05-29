class LeaderBoardScanModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  LeaderBoardScanModel({
    this.status,
    this.code,
    this.message,
    this.body,
  });

  factory LeaderBoardScanModel.fromJson(Map<String, dynamic> json) => LeaderBoardScanModel(
    status: json["status"],
    code: json["code"],
    message: json["message"],
    body: json["body"] == null ? null : Body.fromJson(json["body"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "body": body?.toJson(),
  };
}

class Body {
  bool? status;
  String? message;
  String? action;
  String? leaderboardType;
  int? points;

  Body({
    this.status,
    this.message,
    this.action,
    this.leaderboardType,
    this.points,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    status: json["status"],
    message: json["message"],
    action: json["action"],
    leaderboardType: json["leaderboard_type"],
    points: json["points"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "action": action,
    "leaderboard_type": leaderboardType,
    "points": points,
  };
}
