import 'dart:ui';

class HomeMenuItem {
  String? title;
  String? iconUrl;
  HomeMenuItem.createItem({required this.title, required this.iconUrl});
}
class HomeMenuNewItem {
  String? title;
  String? value;
  String? iconUrl;
  Color? color;
  int id;
  HomeMenuNewItem.createItem(
      {required this.title,
        this.value,
        required this.iconUrl,
        required this.color,required this.id});
}