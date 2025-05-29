class NotesModel {
  bool? status;
  int? code;
  String? message;
  NotesData? body;

  NotesModel({this.status, this.code, this.message, this.body});

  NotesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? new NotesData.fromJson(json['body']) : null;
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

class NotesData {
  int? totalNotes;
  int? user;
  int? speaker;
  int? exhibitor;

  NotesData({this.totalNotes, this.user, this.speaker,this.exhibitor});

  NotesData.fromJson(Map<String, dynamic> json) {
    totalNotes = json['total_notes'];
    user = json['user'];
    speaker = json['speaker'];
    exhibitor = json['exhibitor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_notes'] = this.totalNotes;
    data['user'] = this.user;
    data['speaker'] = this.speaker;
    data['exhibitor'] = this.exhibitor;
    return data;
  }
}
