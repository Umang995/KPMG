import 'package:dreamcast/widgets/userListBody.dart';
import 'package:flutter/material.dart';

import '../representatives/model/user_model.dart';

class UserListSkeleton extends StatelessWidget {
  const UserListSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => UserListWidget(
      representatives: Representatives(
        avatar: "",
        bookmark: "",
        name: "Sample user name",
        company: "Dreamcast",
        position: "Android developer",
      ),
      isFromBookmark: false,
      isApiLoading: true,
      press: () async {
      },
    ));
  }
}
