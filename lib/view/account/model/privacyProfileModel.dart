
import 'package:image_cropper/image_cropper.dart';

class PrivacyProfileModel {
  List<ProfileFieldData>? body;
  bool? status;
  int? code;
  String? message;

  PrivacyProfileModel({this.status, this.code, this.message,this.body});

  PrivacyProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['body'] != null) {
      body = <ProfileFieldData>[];
      json['body'].forEach((v) {
        body!.add(new ProfileFieldData.fromJson(v));
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

class ProfileFieldData {
  int? step;
  String? label;
  String? name;
  String? type;
  String? validationAs;
  bool? readonly = false;
  String? placeholder;
  dynamic value;
  String? poster;
  String? rules;
  String?text;
  List<Options>? options;
  CroppedFile? file;
  bool? isAiFormField;

  ProfileFieldData(
      {this.step,
        this.label,
        this.name,
        this.type,
        this.validationAs,
        this.readonly,
        this.placeholder,
        this.value,
        this.poster,
        this.rules,
        this.options,this.text,this.isAiFormField});

  ProfileFieldData.fromJson(Map<String, dynamic> json) {
    step = json['step'];
    label = json['label'];
    name = json['name'];
    type = json['type'];
    validationAs = json['validation_as'];
    readonly = json['readonly'];
    isAiFormField = json['aiFormField'];
    placeholder = json['placeholder'];
    if (json['value'] is List) {
      value = json['value'].cast<dynamic>();
    }
    else {
      value = json['value']??"";
    }
    poster = json['poster'];
    text = json['text'];
    rules = json['rules'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['step'] = step;
    data['label'] = label;
    data['name'] = name;
    data['type'] = type;
    data['validation_as'] = validationAs;
    data['readonly'] = readonly;
    data['placeholder'] = placeholder;
    data['value'] = value;
    data['aiFormField'] = isAiFormField;
    data['poster'] = poster;
    data['text'] = text;
    data['rules'] = rules;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  dynamic value;
  String? text;

  Options({this.value, this.text});

  Options.fromJson(Map<String, dynamic> json) {
    value = json['value'].toString();
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = value;
    data['text'] = text;
    return data;
  }
}
