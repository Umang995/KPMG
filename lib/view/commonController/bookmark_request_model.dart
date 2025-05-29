class BookmarkRequestModel {
  String? itemId;
  String? itemType;

  BookmarkRequestModel({this.itemId, this.itemType});

  BookmarkRequestModel.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    itemType = json['item_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = itemId;
    data['item_type'] = itemType;
    return data;
  }
}