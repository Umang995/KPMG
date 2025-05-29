import 'package:dreamcast/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/toolbarTitle.dart';
import '../controller/pagesController.dart';

class PagesView extends GetView<PagesController> {
  String title;
  String slug;
  PagesView({Key? key,required this.title,required this.slug}) : super(key: key);

  static const routeName = "/PagesView";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: ToolbarTitle(
            title: title,
            color: Colors.black,
          ),
          shape: const Border(
              bottom: BorderSide(
                  color: borderColor, width: 0)),
          elevation: 0,
          backgroundColor: white,
          iconTheme:  IconThemeData(color: colorSecondary),
        ),
        body: GetX<PagesController>(builder: (controller){
          return Stack(
            children: [
              _buildEventDetail(),
              controller.loading.value?const Loading():const SizedBox()
            ],
          );
        },));
  }
  _buildEventDetail(){
    return SingleChildScrollView(
      child: HtmlWidget(controller.pagesBody.value.page?.fullDescription??""),
    );
  }

}
