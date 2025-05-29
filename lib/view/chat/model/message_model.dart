
class ChatModel {
  String? userId;
  String? message;
  DateTime? dateTime;


  ChatModel(this.userId, this.message,this.dateTime);

  ChatModel.fromJson(Map<dynamic, dynamic> json)
      : userId = json['user_id'] as String,
        message = json['text'] as String,
        dateTime = DateTime.parse(json['datetime'] as String);


  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'user_id': userId,
    'text': message,
    'datetime': dateTime.toString(),
  };
}

class GroupChatModel {
  String? userId;
  String? message;
  String? type;
  String? name;
  String? avtar;
  String? shortName;
  DateTime? dateTime;


  GroupChatModel(this.userId, this.message,this.type,this.dateTime,this.name,this.shortName,this.avtar);

  GroupChatModel.fromJson(Map<dynamic, dynamic> json)
      : userId = json['user_id'] as String,
        message = json['text'] as String,
        type = json['type'] as String,
        name = json['name'] as String,
        avtar = json['avatar'] as String,
        shortName = json['short_name'] as String,
        dateTime = DateTime.parse(json['datetime'] as String);


  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'user_id': userId,
    'text': message,
    'type': type,
    'name': name,
    'avatar': avtar,
    'short_name': shortName,
    'datetime': dateTime.toString(),
  };
}
