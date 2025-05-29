import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../routes/my_constant.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/textview/customTextView.dart';
import '../model/leaderboard_team_model.dart';

class UserChildWidget extends StatelessWidget {
  int index;
  LeaderboardUsers users;
  bool showSelf = false;
  UserChildWidget(
      {super.key,
      required this.index,
      required this.users,
      required this.showSelf});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: (index == 0 && showSelf)
              ? colorLightGray
              : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(index == 0 ? 10 : 0)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      child: AutoSizeText(
                        '#${users.rank ?? ""}',
                        maxFontSize: 20,
                        minFontSize: 8,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: colorSecondary,
                            fontFamily: MyConstant.currentFont),
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    avtarBuild(
                        shortName: users.shortName ?? "",
                        url: users.avatar ?? ""),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextView(
                        text:
                            (index == 0 && showSelf) ? "You" : users.name ?? "",
                        textAlign: TextAlign.start,
                        fontWeight: (index == 0 && showSelf)
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: (index == 0 && showSelf)
                            ? colorPrimary
                            : colorSecondary,
                        fontSize: 18,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    CustomTextView(
                      color: (index == 0 && showSelf)
                          ? colorPrimary
                          : colorSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      text: users.totalPoints ?? "",
                    ),
                    // const CustomTextView(text: "Points"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget avtarBuild({url, shortName}) {
    return url.isNotEmpty
        ? FittedBox(
            fit: BoxFit
                .cover, // the picture will acquire all of the parent space.
            child: SizedBox(
                height: 45,
                width: 45,
                child: CircleAvatar(backgroundImage: NetworkImage(url))),
          )
        : Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorSecondary,
            ),
            child: Center(
                child: CustomTextView(
              text: shortName,
              color: white,
              textAlign: TextAlign.center,
            )),
          );
  }
}
