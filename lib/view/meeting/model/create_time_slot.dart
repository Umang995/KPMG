class CreatedSlots {
  String? time;
  String? dateTime;
  bool? status;

  CreatedSlots({this.time, this.dateTime, this.status});

  /*CreatedSlots.fromJson(Map<String, dynamic> json) {
    time = json['start_datetime'];
    dateTime = json['end_datetime'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_datetime'] = this.startDatetime;
    data['end_datetime'] = this.endDatetime;
    data['duration'] = this.duration;
    return data;
  }*/
}