class TimeslotModel {
  Body? body;
  bool? status;
  int? code;

  TimeslotModel({this.body,this.status, this.code});

  TimeslotModel.fromJson(Map<String, dynamic> json) {
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
  List<MeetingSlots>? meetingSlots;
  List<String>? appointments;
  String? allowedDate;

  Body({this.meetingSlots, this.appointments,this.allowedDate});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['meeting_slots'] != null) {
      meetingSlots = <MeetingSlots>[];
      json['meeting_slots'].forEach((v) {
        meetingSlots!.add(new MeetingSlots.fromJson(v));
      });
    }
    appointments = json['appointments'].cast<String>();
    allowedDate=json["allowed_date"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.meetingSlots != null) {
      data['meeting_slots'] =
          this.meetingSlots!.map((v) => v.toJson()).toList();
    }
    data['appointments'] = this.appointments;
    data['allowed_date']=this.allowedDate;
    return data;
  }
}

class MeetingSlots {
  String? startDatetime;
  String? endDatetime;
  int? duration;
  int? gap;

  MeetingSlots({this.startDatetime, this.endDatetime, this.duration,this.gap});

  MeetingSlots.fromJson(Map<String, dynamic> json) {
    startDatetime = json['start_datetime'];
    endDatetime = json['end_datetime'];
    duration = json['duration'];
    gap = json['gap'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_datetime'] = this.startDatetime;
    data['end_datetime'] = this.endDatetime;
    data['duration'] = this.duration;
    data['gap'] = this.gap;
    return data;
  }
}
