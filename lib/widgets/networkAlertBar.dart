import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkAlertBar extends StatelessWidget {
  const NetworkAlertBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Container(
        width: context.width,
        height: context.height,
        color: Colors.red,
        child:  Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Icon(
                Icons.error,
              ),
              SizedBox(
                width: 10,
              ),
              CustomTextView(
                text:"No Internet connection!!",
                  fontSize: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}