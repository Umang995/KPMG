class MeetingModel {
  Body? body;
  bool? status;
  int? code;
  MeetingModel({this.status, this.code, this.body});

  MeetingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
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

class Body {
  List<Meetings>? meetings;
  bool? hasNextPage;

  Body({
    this.meetings,
    this.hasNextPage,
  });

  Body.fromJson(Map<String, dynamic> json) {
    if (json['meetings'] != null) {
      meetings = <Meetings>[];
      json['meetings'].forEach((v) {
        meetings!.add(new Meetings.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.meetings != null) {
      data['meetings'] = this.meetings!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = this.hasNextPage;

    return data;
  }
}

class Meetings {
  String? id;
  dynamic message;
  String? location;
  int? status;
  String? rescheduledBy;
  int? joinVideoCallStatus;
  dynamic wbUrl;
  dynamic actionCreated;
  String? startDatetime;
  String? endDatetime;
  String? notificationStatus;
  String? notificationAcceptStatus;
  String? notificationPendingStatus;
  String? notificationDeclineStatus;
  dynamic completionStatus;
  dynamic completionMessage;
  String? iam;
  User? user;

  Meetings({
    this.id,
    this.message,
    this.location,
    this.status,
    this.rescheduledBy,
    this.joinVideoCallStatus,
    this.wbUrl,
    this.actionCreated,
    this.startDatetime,
    this.endDatetime,
    this.notificationStatus,
    this.notificationAcceptStatus,
    this.notificationPendingStatus,
    this.notificationDeclineStatus,
    this.completionStatus,
    this.completionMessage,
    this.iam,
    this.user,
  });

  Meetings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    location = json['location'];
    status = json['status'];
    rescheduledBy = json['rescheduled_by'];
    joinVideoCallStatus = json['join_video_call_status'];
    wbUrl = json['wb_url'];
    actionCreated = json['action_created'];
    startDatetime = json['start_datetime'];
    endDatetime = json['end_datetime'];
    notificationStatus = json['notification_status'];
    notificationAcceptStatus = json['notification_accept_status'];
    notificationPendingStatus = json['notification_pending_status'];
    notificationDeclineStatus = json['notification_decline_status'];
    completionStatus=json['completion_status'];
    completionMessage=json['completion_message'];
    iam = json['iam'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['location'] = this.location;
    data['status'] = this.status;
    data['rescheduled_by'] = this.rescheduledBy;
    data['join_video_call_status'] = this.joinVideoCallStatus;
    data['wb_url'] = this.wbUrl;
    data['action_created'] = this.actionCreated;
    data['start_datetime'] = this.startDatetime;
    data['end_datetime'] = this.endDatetime;
    data['notification_status'] = this.notificationStatus;
    data['notification_accept_status'] = this.notificationAcceptStatus;
    data['notification_pending_status'] = this.notificationPendingStatus;
    data['notification_decline_status'] = this.notificationDeclineStatus;
    data['completion_status']=this.completionStatus;
    data['completion_message']=this.completionMessage;
    data['iam'] = this.iam;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? shortName;
  String? company;
  String? position;
  String? avatar;
  String? role;
  String? timezone;
  String? parentId;
  String? status;

  User(
      {this.id,
      this.name,
      this.shortName,
      this.company,
      this.position,
      this.avatar,
      this.role,
      this.timezone,
      this.parentId,
      this.status,
      });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortName = json['short_name'];
    company = json['company'];
    position = json['position'];
    avatar = json['avatar'];
    role = json['role'];
    timezone = json['timezone'];
    parentId = json['parent_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['short_name'] = this.shortName;
    data['company'] = this.company;
    data['position'] = this.position;
    data['avatar'] = this.avatar;
    data['role'] = this.role;
    data['timezone'] = this.timezone;
    data['parent_id'] = this.parentId;
    data['status'] = this.status;
    return data;
  }
}
