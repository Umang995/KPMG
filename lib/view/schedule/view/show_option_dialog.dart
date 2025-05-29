
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/textview/customTextView.dart';

class ShowOptionDialog extends StatelessWidget {
  const ShowOptionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              top: 100,
              left: 0,
              child:  Container(
                width: context.width * 0.80 - 20,
                decoration:  BoxDecoration(
                  color: colorSecondary,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, 0),
                      blurRadius: 2,
                      spreadRadius: 2,
                      color: Colors.black26,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 200,width: 200,
                      child: Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return InkWell(
                                    onTap: () {},
                                    child: ListTile(
                                        title: CustomTextView(
                                          text: "Auditorium ${index + 1}",
                                        )));
                              })),),
                     Divider(color: colorGray,),
                    ListTile(
                      title: Text("live".tr),
                      trailing: const Icon(Icons.radio_button_checked),
                    ),
                    ListTile(
                      title: Text("upcoming".tr),
                      trailing: const Icon(Icons.radio_button_checked),
                    ),
                    ListTile(
                      title: Text("on_demand".tr),
                      trailing: const Icon(Icons.radio_button_checked),
                    )
                  ],
                ),

              ),
            )
          ],
        ),
      ),
    );
  }


}
