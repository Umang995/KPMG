
class ChatProfileModel {
  dynamic avtar;
  String? company;
  String? name;
  String? position;
  String? role;
  String? shortName;

  ChatProfileModel(this.avtar,this.company,this.name,this.position,this.role,this.shortName);

  ChatProfileModel.fromJson(Map<dynamic, dynamic> json):
        avtar = json['avatar'],
        company = json['company'],
        name = json['name'],
        position = json['position'],
        role = json['role'],
        shortName = json['short_name']
  ;
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'avatar': avtar,
    'company': company,
    'name': name,
    'position': position,
    'role': role,
    'short_name':shortName
  };
}
