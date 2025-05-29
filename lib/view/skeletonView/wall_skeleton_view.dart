import 'package:dreamcast/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class WallSkeletonView extends StatelessWidget {
  const WallSkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context,
          index) => Container(
        color: white,
            child: Column(
                  children: [
                    const ListTile(
            leading: Icon(Icons.circle),
            title: Text(""),
            subtitle: Text(""),
                    ),
                    Text("inspiring_words".tr),
                    const SizedBox(height: 30,),
                    const Text("# hello")
                  ],
                ),
          ),);
  }
}
