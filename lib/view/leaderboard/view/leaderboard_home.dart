import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_colors.dart';
import '../../dashboard/showLoadingPage.dart';
import '../controller/leaderboard_controller.dart';
import '../model/leaderboard_team_model.dart';
import '../widget/user_child_widget.dart';

class LeaderboardHome extends StatefulWidget {
  const LeaderboardHome({Key? key}) : super(key: key);

  @override
  State<LeaderboardHome> createState() => _LeaderboardHomeState();
}

class _LeaderboardHomeState extends State<LeaderboardHome> {
  final LeaderboardController controller = Get.find();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GetX<LeaderboardController>(builder: (controller) {
        return Stack(
          alignment: Alignment.center,
          children: [
            NestedScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              //controller: controller.nestedScrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: buildTopRankWidget(),
                  ),
                ];
              },
              body: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  color: Colors.white,
                  backgroundColor: colorPrimary,
                  strokeWidth: 2.0,
                  triggerMode: RefreshIndicatorTriggerMode.anywhere,
                  onRefresh: () async {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        controller.getRankApi(isRefresh: true);
                      },
                    );
                  },
                  child: buildListView(context)),
            ),
            _progressEmptyWidget(),
          ],
        );
      }),
    );
  }

  ///no data found widget
  Widget _progressEmptyWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      child: !controller.isFirstLoadRunning.value && controller.topThree.isEmpty
          ? ShowLoadingPage(
              refreshIndicatorKey: _refreshIndicatorKey,
            )
          : const SizedBox(),
    );
  }

  buildTopRankWidget() {
    List<LeaderboardUsers> topRankList = controller.topThree ?? [];
    return controller.topThree.isNotEmpty
        ? CarouselSlider.builder(
            itemCount: topRankList.length,
            options: CarouselOptions(
                autoPlay: false,
                reverse: true,
                //aspectRatio: 16 / 10,
                initialPage: 0,
                enlargeCenterPage: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 0.35,
                scrollPhysics: const NeverScrollableScrollPhysics(),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
                enableInfiniteScroll: true),
            itemBuilder: (BuildContext context, int index, int realIndex) {
              return FittedBox(
                child: Container(
                    height: 220,
                    width: 146,
                    decoration: BoxDecoration(
                        color: topRankList[index].rank == "1"
                            ? colorPrimary
                            : colorLightGray,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        topRankList[index].rank == "1"
                            ? const SizedBox(
                                height: 10,
                              )
                            : const SizedBox(),
                        topRankList[index].rank == "1"
                            ? SvgPicture.asset(
                                "assets/svg/crown_icon.svg",
                                height: 35,
                              )
                            : Container(
                                margin: const EdgeInsets.all(2),
                                width: context.width,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                child: Center(
                                  child: AutoCustomTextView(
                                    text: '#${topRankList[index].rank}',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: colorSecondary,
                                    maxLines: 1,
                                  ),
                                )),
                        SizedBox(
                          height: topRankList[index].rank == "1" ? 15 : 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 21, right: 21, bottom: 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              avtarTopBuild(
                                  size: 100.adaptSize,
                                  shortName: topRankList[index].shortName ?? "",
                                  url: topRankList[index].avatar ?? ""),
                              const SizedBox(
                                height: 9,
                              ),
                              Flexible(
                                  child: AutoCustomTextView(
                                text: '${topRankList[index].name}',
                                textAlign: TextAlign.center,
                                //fontSize: 16,
                                color: topRankList[index].rank == "1"
                                    ? white
                                    : colorSecondary,
                                maxLines: 1,
                              )),
                              const SizedBox(
                                height: 5,
                              ),
                              AutoCustomTextView(
                                text: '${topRankList[index].totalPoints}',
                                textAlign: TextAlign.center,
                                fontSize:
                                    topRankList[index].rank == "1" ? 24 : 20,
                                fontWeight: FontWeight.bold,
                                color: topRankList[index].rank == "1"
                                    ? white
                                    : colorPrimary,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              );
            },
          )
        : const SizedBox();
  }

  Widget buildListView(BuildContext context) {
    return Skeletonizer(
        enabled: controller.isFirstLoadRunning.value,
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          separatorBuilder: (BuildContext context, int index) {
            return (index == 0 &&
                    controller.team.length > controller.teamsLength)
                ? const SizedBox(
                    height: 3,
                  )
                : const Divider(
                    height: 3,
                    color: borderColor,
                  );
          },
          itemCount:
              controller.isFirstLoadRunning.value ? 5 : controller.team.length,
          itemBuilder: (context, index) {
            if (controller.isFirstLoadRunning.value) {
              return UserChildWidget(
                  index: index,
                  showSelf: false,
                  users: LeaderboardUsers(
                      name: "Hello this is dummy text \n Hello ",
                      rank: "1",
                      totalPoints: "10"));
            }
            LeaderboardUsers users = controller.team[index];
            return UserChildWidget(
              index: index,
              users: users,
              showSelf: controller.team.length > controller.teamsLength
                  ? true
                  : false,
            );
          },
        ));
  }

  Widget avtarTopBuild({url, shortName, size}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: colorSecondary),
      child: url?.toString().isNotEmpty ?? false
          ? CachedNetworkImage(
              imageUrl: url,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Center(
                child: CustomTextView(
                  text: shortName ?? "",
                  fontSize: 18,
                  color: white,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : Center(
              child: CustomTextView(
                text: shortName ?? "",
                fontSize: 18,
                color: white,
                textAlign: TextAlign.center,
              ),
            ),
    );
  }
}
