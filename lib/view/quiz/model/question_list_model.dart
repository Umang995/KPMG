class QuestionListModel {
  bool? status;
  int? code;
  String? message;
  List<FeedbackQuestion>? body;

  QuestionListModel({this.status, this.code, this.message, this.body});

  QuestionListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['body'] != null) {
      body = <FeedbackQuestion>[];
      json['body'].forEach((v) {
        body!.add(new FeedbackQuestion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (body != null) {
      data['body'] = body!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeedbackQuestion {
  String? name;
  String? label;
  List<FeedbackOptions>? options;
  String? type;
  int? step;
  String? placeholder;
  dynamic value;
  String? rules;
  String? validationAs;

  FeedbackQuestion(
      {this.name,
        this.label,
        this.options,
        this.type,
        this.step,
        this.placeholder,
        this.value,
        this.rules,
        this.validationAs});

  FeedbackQuestion.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    label = json['label'];
    if (json['options'] != null) {
      options = <FeedbackOptions>[];
      json['options'].forEach((v) {
        options!.add(new FeedbackOptions.fromJson(v));
      });
    }
    type = json['type'];
    step = json['step'];
    placeholder = json['placeholder'];
    value = json['value'];
    rules = json['rules'];
    validationAs = json['validation_as'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['label'] = label;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    data['type'] = type;
    data['step'] = step;
    data['placeholder'] = placeholder;
    data['value'] = value;
    data['rules'] = rules;
    data['validation_as'] = validationAs;
    return data;
  }
}

class FeedbackOptions {
  dynamic value;
  String? text;
  bool isTrue=false;

  FeedbackOptions({this.value, this.text});

  FeedbackOptions.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = value;
    data['text'] = text;
    return data;
  }
}
