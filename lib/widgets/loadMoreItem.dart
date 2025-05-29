import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:lottie/lottie.dart';
class LoadMoreLoading extends StatelessWidget {
  const LoadMoreLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return normalLoading();
  }

  Widget normalLoading(){
    return  Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoActivityIndicator(color: Colors.black,
              radius: 12.0),
          SizedBox(width: 10,),
          CustomTextView(text: "Loading...",fontWeight: FontWeight.normal,fontSize: 14,)
        ],
      ),
    );
  }
  Widget animatedLoading(){
    return  Lottie.asset('assets/animated/loading.json',height: 20);
  }

}
