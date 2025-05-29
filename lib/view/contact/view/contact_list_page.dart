import 'dart:io' show Directory, File, Platform;
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/contact_list_widget.dart';
import '../../../widgets/loadMoreItem.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../skeletonView/userBodySkeleton.dart';
import '../controller/contact_controller.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../representatives/controller/user_detail_controller.dart';
import '../model/contact_list_model.dart';

class MyContactListPage extends GetView<ContactController> {
  static const routeName = "/ContactListPage";
  MyContactListPage({super.key});

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  var showPopup = false.obs;

  @override
  final controller = Get.put(ContactController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: true
          ? null
          : CustomAppBar(
              height: 72.v,
              leadingWidth: 45.h,
              leading: AppbarLeadingImage(
                imagePath: ImageConstant.imgArrowLeft,
                margin: EdgeInsets.only(
                  left: 7.h,
                  top: 3,
                  // bottom: 12.v,
                ),
                onTap: () {
                  Get.back();
                },
              ),
              title: ToolbarTitle(title: "myContact".tr),
            ),
      body: GetX<ContactController>(builder: (controller) {
        return Container(
          width: context.width,
          height: context.height,
          padding: EdgeInsets.all(14.h),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _headerButton(context),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: RefreshIndicator(
                    color: colorLightGray,
                    backgroundColor: colorPrimary,
                    strokeWidth: 1.0,
                    key: _refreshIndicatorKey,
                    onRefresh: () {
                      return Future.delayed(
                        const Duration(seconds: 1),
                        () {
                          controller.getContactList(requestBody: {
                            "page": "1",
                            "filters": {
                              "search": "",
                              "sort": "ASC",
                              "type": controller
                                      .filterContactBody.value.selectedItem ??
                                  ""
                            }
                          });
                        },
                      );
                    },
                    child: buildListView(context),
                  )),
                  // when the _loadMore function is running
                  controller.isLoadMoreRunning.value
                      ? const LoadMoreLoading()
                      : const SizedBox()
                ],
              ),
              showPopup.value
                  ? Positioned(
                      top: 35.v,
                      left: 0,
                      child: buildFilterPopup(context),
                    )
                  : const SizedBox(),
              _progressEmptyWidget()
            ],
          ),
        );
      }),
    );
  }

  Widget _headerButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              showPopup(!showPopup.value);
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 170.adaptSize),
              child: Container(
                //width: context.width,
                padding: EdgeInsets.only(
                    left: 11.adaptSize,
                    right: 11.adaptSize,
                    top: 7.adaptSize,
                    bottom: 7.adaptSize),
                decoration: BoxDecoration(
                    border: Border.all(color: borderColor, width: 1),
                    color: white,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(ImageConstant.ic_sort,
                        width: 11,
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onSurface,
                            BlendMode.srcIn)),
                    const SizedBox(
                      width: 6,
                    ),
                    Flexible(
                        child: CustomTextView(
                      text: (controller.filterContactBody.value.options !=
                                  null &&
                              controller
                                  .filterContactBody.value.options!.isNotEmpty)
                          ? controller
                              .filterContactBody
                              .value
                              .options![controller.selectedFilterIndex.value]
                              .text
                              .toString()
                          : "Loading..",
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ))
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              if (controller.contactList.isEmpty) {
                return;
              }
              var result =
                  await controller.exportContact(context: context) as bool;
              if (result) {
                controller.generateCsvFile();
              }
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100.adaptSize),
              child: Container(
                width: context.width,
                padding: EdgeInsets.only(
                    left: 11.adaptSize,
                    right: 11.adaptSize,
                    top: 7.adaptSize,
                    bottom: 7.adaptSize),
                decoration: BoxDecoration(
                    border: Border.all(color: borderColor, width: 1),
                    color: white,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      ImageConstant.export_icon,
                      width: 11,
                      color: colorSecondary,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    CustomTextView(
                      text: "Export",
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: colorSecondary,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isLoading.value
          ? const Loading()
          : !controller.isFirstLoadRunning.value &&
                  controller.contactList.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  Widget buildListView(BuildContext context) {
    return Skeletonizer(
      enabled: controller.isFirstLoadRunning.value,
      child: controller.isFirstLoadRunning.value
          ? const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: UserListSkeleton(),
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: controller.scrollController,
              itemCount: controller.contactList.length,
              itemBuilder: (context, index) =>
                  buildChildMenuBody(controller.contactList[index]),
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 20.v,
                  color: borderColor,
                );
              },
            ),
    );
  }

  Widget buildChildMenuBody(Contacts? representatives) {
    return ContactListBody(
      representatives: representatives,
      press: () async {
        final UserDetailController controller =
            Get.isRegistered<UserDetailController>()
                ? Get.find()
                : Get.put(UserDetailController());
        controller.getUserDetailApi(representatives?.id, representatives?.role);
      },
    );
  }

  //contact filter popup
  Widget buildFilterPopup(BuildContext? context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 170.adaptSize),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: borderColor, width: 1)),
        elevation: 6,
        child: Padding(
          padding: EdgeInsets.zero,
          child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              scrollDirection: Axis.vertical,
              itemCount:
                  controller.filterContactBody.value.options?.length ?? 0,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var data = controller.filterContactBody.value.options?[index];
                return InkWell(
                  onTap: () {
                    showPopup(false);
                    controller.selectedFilterIndex(index);
                    controller.filterContactBody.value.selectedItem =
                        data?.value ?? "";
                    controller.getContactList(
                      requestBody: {
                        "page": "1",
                        "filters": {
                          "search": "",
                          "sort": "ASC",
                          "type": data?.value ?? ""
                        }
                      },
                    );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                    child: CustomTextView(
                      text: data?.text ?? "",
                      fontWeight: FontWeight.w600,
                      color: controller.filterContactBody.value.selectedItem ==
                              data?.value
                          ? colorSecondary
                          : colorGray,
                      fontSize: 15,
                      textAlign: TextAlign.start,
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
