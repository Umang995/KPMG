class AskQuestionModel {
  bool? status;
  int? code;
  String? message;
  List<AskQuestion>? data;

  AskQuestionModel({this.status, this.code, this.message, this.data});

  AskQuestionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['body'] != null) {
      data = <AskQuestion>[];
      json['body'].forEach((v) {
        data!.add(new AskQuestion.fromJson(v));
      });
    }  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['body'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AskQuestion {
  String? id;
  String? auditoriumSessionId;
  String? userId;
  dynamic publishDate;
  bool? archive;
  String? created;
  String? value;
  String? question;
  dynamic publishStatus;
  String? name;
  String? shortName;
  String? avatar;
  int? vote;
  String? isVoted;
  String? auditoriumId;

  AskQuestion(
      {this.id,
      this.auditoriumSessionId,
      this.userId,
      this.publishDate,
      this.archive,
      this.created,
      this.value,
      this.question,
      this.publishStatus,
      this.name,
      this.shortName,
      this.avatar,
      this.vote,
      this.isVoted,
      this.auditoriumId});

  AskQuestion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    auditoriumSessionId = json['auditorium_session_id'];
    userId = json['user_id'];
    publishDate = json['publish_date'];
    archive = json['archive'];
    created = json['created'];
    value = json['value'];
    question = json['question'];
    publishStatus = json['publish_status'];
    name = json['name'];
    shortName = json['short_name'];
    avatar = json['avatar'];
    vote = json['vote'];
    isVoted = json['is_voted'];
    auditoriumId = json['auditorium_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['auditorium_session_id'] = this.auditoriumSessionId;
    data['user_id'] = this.userId;
    data['publish_date'] = this.publishDate;
    data['archive'] = this.archive;
    data['created'] = this.created;
    data['value'] = this.value;
    data['question'] = this.question;
    data['publish_status'] = this.publishStatus;
    data['name'] = this.name;
    data['short_name'] = this.shortName;
    data['avatar'] = this.avatar;
    data['vote'] = this.vote;
    data['is_voted'] = this.isVoted;
    data['auditorium_id'] = this.auditoriumId;
    return data;
  }
}
