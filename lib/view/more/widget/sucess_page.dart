import 'package:dreamcast/utils/image_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/view/dashboard/dashboard_page.dart';

class SucessPage extends StatelessWidget {
  String message;
  SucessPage({Key? key,required this.message}) : super(key: key);
  static const routeName = "/sucessPage";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(25),
        color: const Color(0xff5AAF28),
        child: Column(
          children: [
            const SizedBox(
              height: 150,
            ),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageConstant.sucess_icon),
                  fit: BoxFit.cover,
                ),
                borderRadius:
                const BorderRadius.all(Radius.circular(50.0)),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            CustomTextView(
              text: "congratulations".tr,
              textAlign: TextAlign.center,
              fontSize: 32,fontWeight: FontWeight.w700,color: Colors.white,
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextView(
              text: message,
              textAlign: TextAlign.center,
              fontSize: 18,color: Colors.white,
            ),
            const SizedBox(
              height: 60,
            ),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.transparent,
                  side: const BorderSide(color: Colors.white, width: 1),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                onPressed: (){
                  Future.delayed(Duration.zero, () async {
                    Get.offAndToNamed(DashboardPage.routeName);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100,vertical: 20),
                  child: CustomTextView(text: "ok".tr,color: Colors.white,fontSize: 22,),
                )
            )
          ],
        ),
      ),
    );
  }
}
