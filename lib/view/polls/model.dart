class PollListModel {
  String? question;
  String? endDatetime;
  String? itemId;
  String? created;
  String? itemType;
  List<String>? options;
  String? modified;
  String? id;
  int? status;
  dynamic result;


  PollListModel(
      {this.question,
        this.endDatetime,
        this.itemId,
        this.created,
        this.itemType,
        this.options,
        this.modified,
        this.id,
        this.status,this.result});

  PollListModel.fromJson(Map<dynamic, dynamic> json) {
    question = json['question'];
    endDatetime = json['end_datetime'];
    itemId = json['item_id'];
    created = json['created'];
    itemType = json['item_type'];
    options = json['options'].cast<String>();
    modified = json['modified'];
    id = json['id'];
    status = json['status'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question;
    data['end_datetime'] = endDatetime;
    data['item_id'] = itemId;
    data['created'] = created;
    data['item_type'] = itemType;
    data['options'] = options;
    data['modified'] = modified;
    data['id'] = id;
    data['status'] = status;
    data['result'] = result;
    return data;
  }
}


/*class PollListModel {
  String? answer;
  String? status;
  String? datetime;
  String? id;
  String? question;
  String? duration;
  List<String>? options;
  dynamic result;


  PollListModel(
      {this.answer,
        this.status,
        this.datetime,
        this.id,
        this.question,
        this.duration,
        this.options,this.result});

  PollListModel.fromJson(Map<dynamic, dynamic> json) {
    answer = json['answer'];
    status = json['status'];
    datetime = json['datetime'];
    id = json['id'];
    question = json['question'];
    duration = json['duration'];
    result = json['result'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer'] = this.answer;
    data['status'] = this.status;
    data['datetime'] = this.datetime;
    data['id'] = this.id;
    data['question'] = this.question;
    data['duration'] = this.duration;
    data['options'] = this.options;
    data['result'] = this.result;
    return data;
  }
}*/
