class CommonDocumentRequest {
  String? itemId;
  String? itemType;
  int? favourite;
  bool? limitedMode;
  String? type;

  CommonDocumentRequest({this.itemId, this.itemType, this.favourite, this.limitedMode, this.type});

  CommonDocumentRequest.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    itemType = json['item_type'];
    favourite=json['favourite'];
    limitedMode=json['limited_mode'];
    type=json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this.itemId;
    data['item_type'] = this.itemType;
    data['favourite']=this.favourite;
    data['limited_mode']=this.limitedMode;
    data['type']=this.type;
    return data;
  }
}



