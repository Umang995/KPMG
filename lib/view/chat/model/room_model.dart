class RoomModel {
  DateTime? dateTime;
  String? roomId;
  String? iam;
  String? text;
  int? status;
  dynamic unread = 0;

  RoomModel(this.dateTime, this.roomId, this.iam, this.text, this.unread,
      this.status);

  RoomModel.fromJson(Map<dynamic, dynamic> json)
      : dateTime = DateTime.parse(
            json['datetime'] ?? DateTime.now().toString()),
        roomId = json['id'],
        iam = json['iam'],
        text = json['text'],
        status = json['status'],
        unread = json['count'];

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'datetime': dateTime,
        'id': roomId,
        'iam': iam,
        'text': text,
        "status": status,
        'count': unread,
      };

}
