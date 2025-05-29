import 'package:flutter/material.dart';

class ListVideoSkeleton extends StatelessWidget {
  const ListVideoSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => const SizedBox(),
    );
  }
}
