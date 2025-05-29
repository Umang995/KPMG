import 'package:flutter/material.dart';
import '../../widgets/investorListBody.dart';
import '../startNetworking/model/startNetworkingModel.dart';

class InvestorListSkeleton extends StatelessWidget {
  const InvestorListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => InvestorListBody(
      representatives: UserAspireData(
        avatar: "",
        name: "Sample user name",
        company: "Dreamcast",
        position: "Android developer",
      ),
    ));
  }
}
