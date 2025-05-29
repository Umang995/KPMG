class SessionPollModel {
  String? action;
  List<PollResultData>? result;
  String? status;
  String? id;
  String? question;
  String? created;
  String? modified;
  List<String>? options;

  SessionPollModel(
      {this.action,
        this.result,
        this.status,
        this.id,
        this.question,
        this.created,
        this.modified,
        this.options});

  SessionPollModel.fromJson(Map<dynamic, dynamic> json) {
    action = json['action'];
    if (json['result'] != null) {
      result = <PollResultData>[];
      json['result'].forEach((v) {
        result!.add(new PollResultData.fromJson(v));
      });
    }
    status = json['status'];
    id = json['id'];
    question = json['question'];
    created = json['created'];
    modified = json['modified'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = this.action;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['id'] = this.id;
    data['question'] = this.question;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['options'] = this.options;
    return data;
  }
}

class PollResultData {
  String? opinion;
  dynamic percentage;
  dynamic total;

  PollResultData({this.opinion, this.percentage, this.total});

  PollResultData.fromJson(Map<dynamic, dynamic> json) {
    opinion = json['opinion'];
    percentage = json['percentage'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['opinion'] = this.opinion;
    data['percentage'] = this.percentage;
    data['total'] = this.total;
    return data;
  }
}
