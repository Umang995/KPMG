import 'package:dreamcast/view/exhibitors/view/bootListBody.dart';
import 'package:flutter/material.dart';

import '../exhibitors/model/exibitorsModel.dart';

class BootViewSkeleton extends StatelessWidget {
  const BootViewSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 9 / 10,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => BootListBody(
        isApiLoading: true,
        exhibitor: Exhibitors(
            avatar: "",
            boothNumber: "UKG",
            fasciaName: "UKG",
            hallNumber: "40 41",
            companyShortName: "UKG"),
      ),
    );
  }
}
