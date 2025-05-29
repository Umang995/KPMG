import 'dart:developer';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/guide/view/info_faq_dashboard.dart';
import 'package:dreamcast/view/home/model/config_detail_model.dart';
import 'package:dreamcast/view/menu/controller/menuController.dart';
import 'package:dreamcast/view/menu/model/menu_data_model.dart';
import 'package:dreamcast/view/photobooth/view/photoBooth.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:skeletonizer/skeletonizer.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/image_constant.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/button/custom_menu_button.dart';
import '../../../widgets/event_feed_widget.dart';
import '../../../widgets/home_menu_item.dart';
import '../../../widgets/home_widget/event_info_header.dart';
import '../../../widgets/home_widget/event_live_header.dart';
import '../../../widgets/home_widget/home_banner_widget.dart';
import '../../../widgets/home_widget/home_explore_more.dart';
import '../../../widgets/home_widget/home_feedback_widget.dart';
import '../../../widgets/home_widget/home_location_widget.dart';
import '../../../widgets/home_widget/home_partner_list.dart';
import '../../../widgets/home_widget/home_welcome_banner.dart';
import '../../../widgets/lunchpad_ai_widget.dart';
import '../../../widgets/textview/customTextView.dart';
import '../../../widgets/button/custom_outlined_button.dart';
import '../../../widgets/lunchpad_menu_label.dart';
import '../../../widgets/resource_center_widget.dart';
import '../../../widgets/social_wall_widget.dart';
import '../../account/controller/account_controller.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../bestForYou/view/aiMatch_dashboard_page.dart';
import '../../breifcase/controller/common_document_controller.dart';
import '../../breifcase/view/resourceCenter.dart';
import '../../chat/view/chatDashboard.dart';
import '../../dashboard/dashboard_controller.dart';
import '../../exhibitors/controller/exhibitorsController.dart';
import '../../exhibitors/view/bootListPage.dart';
import '../../globalSearch/page/global_search_page.dart';
import '../../leaderboard/view/leaderboard__dashboard_page.dart';
import '../../polls/view/pollsPage.dart';
import '../../quiz/view/feedback_page.dart';
import '../../speakers/view/speaker_list_page.dart';
import '../../partners/controller/partnersController.dart';
import '../../partners/model/partnersModel.dart';
import '../../partners/view/partnersDetailPage.dart';
import '../../schedule/view/today_session_page.dart';
import '../controller/for_you_controller.dart';
import '../controller/home_controller.dart';

class HomePage extends GetView<HomeController> {
  HomePage({Key? key}) : super(key: key);
  final DashboardController _dashboardController = Get.find();
  final AuthenticationManager authenticationManager = Get.find();

  final partnerController = Get.put(SponsorPartnersController());

  late Size size;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };

  CommonDocumentController resourceCenterController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            GetX<HomeController>(builder: (controller) {
              return Stack(
                children: [
                  RefreshIndicator(
                    key: _refreshIndicatorKey,
                    color: colorLightGray,
                    backgroundColor: colorPrimary,
                    strokeWidth: 1.0,
                    triggerMode: RefreshIndicatorTriggerMode.anywhere,
                    onRefresh: () async {
                      return Future.delayed(
                        const Duration(seconds: 1),
                        () {
                          controller.getHomeApi(isRefresh: true);
                          if (Get.isRegistered<ForYouController>()) {
                            ForYouController controller = Get.find();
                            controller.initApiCall();
                          }
                        },
                      );
                    },
                    child: SizedBox(
                      height: context.height,
                      width: context.width,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.zero,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Stack(
                          children: [
                            const Align(
                              alignment: Alignment.topCenter,
                              child: HomeWelcomeBanner(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, right: 12.0, bottom: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    height: 140,
                                  ),
                                  controller.eventStatus.value == 1
                                      ? LiveEventWidget(
                                          eventStatus:
                                              controller.eventStatus.value)
                                      : PreEventWidget(
                                          eventStatus:
                                              controller.eventStatus.value),
                                  const SizedBox(
                                    height: 35,
                                  ),
                                  userInfoWidget(),
                                  HomeHeaderMenuWidget(),
                                  HomeBannerWidget(),
                                  (controller.isFirstLoading.value == true ||
                                              controller.loading.value ==
                                                  true) ||
                                          controller.menuFeatureHome.isEmpty
                                      ? const SizedBox()
                                      : homeFeaturesMenu(
                                          context, controller.menuFeatureHome),
                                  controller.recommendedForYouList.isNotEmpty
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 35.0),
                                          child: LaunchpadMenuLabel(
                                            title: "recommended_for_you".tr,
                                            trailing: "view_all".tr,
                                            index: 1,
                                            trailingIcon: "",
                                          ),
                                        )
                                      : const SizedBox(),
                                  LaunchpadAIWidget(),
                                  const HomePartnerList(),
                                  if (resourceCenterController
                                      .launchpadResCenterList.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 40.0),
                                      child: LaunchpadMenuLabel(
                                        title: "resource_center".tr,
                                        trailing: resourceCenterController
                                                    .isMoreData.value ==
                                                true
                                            ? "view_all".tr
                                            : "",
                                        index: 3,
                                        trailingIcon: "",
                                      ),
                                    ),
                                  const ResourceCenterWidget(isFromHome: true),
                                  EventFeedWidget(),
                                  if (controller.configDetailBody.value
                                              .socialWall?.url !=
                                          null &&
                                      controller.configDetailBody.value
                                          .socialWall!.url!.isNotEmpty)
                                    buildSocialWall(context),
                                  const HomeLocationWidget(),
                                  buildSocialLink(context),
                                  HomeFeedbackWidget(),
                                  const SizedBox(height: 30),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: controller.loading.value || controller.isHubLoading()
                        ? const Loading()
                        : const SizedBox(),
                  )
                ],
              );
            })
          ],
        ));
  }

  Widget userInfoWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomTextView(
          text: "Hi, ${PrefUtils.getName() ?? ""}",
          textAlign: TextAlign.start,
          maxLines: 1,
          softWrap: true,
          color: colorSecondary,
          fontWeight: FontWeight.w600,
          fontSize: 22,
        ),
        const SizedBox(
          width: 6,
        ),
      ],
    );
  }

  Widget homeFeaturesMenu(
    BuildContext context,
    List<MenuData> itemList,
  ) {
    return Skeletonizer(
        enabled: controller.loading.value,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 35),
            LaunchpadMenuLabel(
              title: "features".tr,
              trailing: " ",
              index: 6,
              trailingIcon: "",
            ),
            GridView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              itemCount: itemList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                MenuData data = itemList[index];
                return GestureDetector(
                  child: CommonMenuButton(
                    color: colorLightGray,
                    borderRadius: 10,
                    onTap: () {
                      HubController hubController = Get.find();
                      hubController.commonMenuRouting(menuData: data);
                    },
                    widget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12.0.adaptSize),
                          child: SvgPicture.network(
                            data.icon ?? "",
                            height: 45.adaptSize,
                            colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.secondary,
                                BlendMode
                                    .srcIn /*colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.onSurface,
                                BlendMode.srcIn*/
                                ),
                            placeholderBuilder: (content) {
                              return const CircularProgressIndicator(
                                strokeWidth: 1,
                              );
                            },
                          ),
                        ),
                        CustomTextView(
                            text: data.label ?? "",
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            softWrap: true,
                            color: colorSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ],
                    ),
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 0.8,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                _dashboardController.changeTabIndex(2);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextView(
                    text: "explore_more".tr,
                    fontSize: 18,
                    color: colorSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: SvgPicture.asset(ImageConstant.icExploreMore,
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onSurface,
                            BlendMode.srcIn)),
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget buildSocialWall(BuildContext context) {
    return Column(
      children: [
        if ((controller.configDetailBody.value.socialWall?.hashtag ?? "")
            .isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 35.0),
            child: LaunchpadMenuLabel(
              title:
                  controller.configDetailBody.value.socialWall?.hashtag ?? "",
              trailing: "",
              index: 4,
              trailingIcon: ImageConstant.icFullscreen,
            ),
          ),
        Container(
            // padding: EdgeInsets.symmetric(),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: SizedBox(
              height: 369.h,
              child: SocialWallWidget(),
            )),
      ],
    );
  }

  Widget buildEventFeed(BuildContext context) {
    return controller.feedDataList.isNotEmpty
        ? EventFeedWidget()
        : const SizedBox();
  }

  Widget buildSocialLink(BuildContext context) {
    var socialItem = controller.configDetailBody.value.socialLinks ?? [];
    return socialItem.isNotEmpty
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 35),
              LaunchpadMenuLabel(
                title: "social_media".tr,
                trailing: " ",
                index: 8,
                trailingIcon: "",
              ),
              Container(
                decoration: BoxDecoration(
                    color: colorLightGray,
                    borderRadius: BorderRadius.circular(15.adaptSize)),
                padding: EdgeInsets.symmetric(
                    vertical: 18.adaptSize, horizontal: 20.adaptSize),
                child: Align(
                  alignment: Alignment.center,
                  child: Wrap(
                    spacing: 10,
                    children: <Widget>[
                      for (var item in socialItem)
                        Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: SizedBox(
                              height: 32,
                              width: 32,
                              child: InkWell(
                                  onTap: () {
                                    print("Link: ${item.url}");
                                    UiHelper.inAppBrowserView(
                                        Uri.parse(item.url.toString()));
                                  },
                                  child: SvgPicture.asset(
                                    UiHelper.getSocialIcon(
                                        item.type.toString().toLowerCase()),
                                  )),
                            )),
                    ],
                  ),
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}
