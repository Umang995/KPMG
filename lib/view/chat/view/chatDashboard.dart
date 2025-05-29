import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/chat/controller/roomController.dart';
import 'package:dreamcast/view/chat/view/room_tab2_page.dart';
import 'package:dreamcast/view/chat/view/room_tab3_page.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/toolbarTitle.dart';
import 'room_tab1_page.dart';

class ChatDashboardPage extends GetView<RoomController> {
  bool? isFromDashboard;
  var _isPopupMenuOpen = false.obs; // Make it reactive
  var selectedFilter = "".obs;

  ChatDashboardPage({Key? key, this.isFromDashboard}) : super(key: key);
  static const routeName = "/chat_list_Page";

  @override
  final controller = Get.put(RoomController());
  final DashboardController dashboardController = Get.find();

  GlobalKey _buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
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
          title: ToolbarTitle(title: "chat_list".tr),
        ),
        body: GetX<RoomController>(
          builder: (controller) {
            return Column(
              children: [
                SizedBox(
                  height: 20.v,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.adaptSize,
                    vertical: 0,
                  ),
                  child: _headerButton(context),
                ),
                Expanded(
                  child: IndexedStack(
                    index: controller.dashboardController.chatTabIndex.value,
                    children: [
                      RoomTab1Widget(tabIndex: 1),
                      RoomTab2Widget(tabIndex: 0),
                      RoomTab3Widget(chatRequestStatus: 0),
                    ],
                  ),
                )
              ],
            );
          },
        ));
  }

  Widget _headerButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomTextView(
          text:
              "Total ${controller.dashboardController.chatTabIndex.value == 0 ? controller.activeChatItemCount.value : controller.dashboardController.chatTabIndex.value == 1 ? controller.requestedChatItemCount.value : controller.sentChatItemCount.value} Found",
          textAlign: TextAlign.start,
          fontWeight: FontWeight.w600,
          fontSize: 22.adaptSize,
          color: colorGray,
        ),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          key: _buttonKey, // Assign the key to the button
          onTap: () {
            _showPopupMenu(context);
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 155.adaptSize),
            child: Container(
              padding: EdgeInsets.only(
                  left: 11.adaptSize,
                  right: 11.adaptSize,
                  top: 7.adaptSize,
                  bottom: 7.adaptSize),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1),
                color: _isPopupMenuOpen.value
                    ? colorLightGray
                    : white, // Use the reactive value
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    ImageConstant.ic_sort,
                    width: 11.adaptSize,colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onSurface,
                      BlendMode.srcIn)
                  ),
                  SizedBox(
                    width: 7.adaptSize,
                  ),
                  Flexible(
                      child: CustomTextView(
                    text: controller.tabList[
                    controller.dashboardController.chatTabIndex.value],
                    fontWeight: FontWeight.w500,
                    fontSize: 15.fSize,maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ))
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showPopupMenu(BuildContext context) async {
    _isPopupMenuOpen.value = true; // Set to true when popup is open
    // Check if the button's context is available
    final BuildContext? buttonContext = _buttonKey.currentContext;
    if (buttonContext == null) {
      return; // Exit if context is not available
    }
    // Get the button's position and size
    final RenderBox button = buttonContext.findRenderObject() as RenderBox;
    final Offset buttonOffset =
        button.localToGlobal(Offset.zero); // Get button's global position
    final double buttonHeight = button.size.height;

    await showMenu<int>(
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 0.5, color: borderColor),
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: white,
      context: context,
      position: RelativeRect.fromLTRB(
        buttonOffset.dx, // Use button's x position
        buttonOffset.dy +
            buttonHeight +
            6, // Use button's y position + height for top
        buttonOffset.dx + button.size.width, // Right offset
        0, // Bottom offset
      ),
      items: menuItems,
      elevation: 8.0,
      constraints: BoxConstraints(
        minWidth: 160.adaptSize,
        maxWidth: 160.adaptSize,

      ),
    ).then(
      (value) {
        _isPopupMenuOpen.value = false; // Set to false when popup is closed
        // Handle the menu item selection if necessary
        if (value != null) {
          controller.dashboardController.chatTabIndex.value =
              value; // Update the selected item
          getDataByIndexPage(value);
          // Do something with the selected value
          print('Selected menu item: $value');
        }
      },
    );
  }

  List<PopupMenuEntry<int>> get menuItems {
    return [
      PopupMenuItem<int>(
        value: 0,
        height: 0,
        padding: EdgeInsets.symmetric(
            horizontal: 12.adaptSize, vertical: 5.adaptSize),
        child: Obx(
          () => CustomTextView(
            text: controller.tabList[0],
            fontSize: 15.fSize,
            textAlign: TextAlign.start,
            fontWeight: controller.dashboardController.chatTabIndex.value == 0
                ? FontWeight.w600
                : FontWeight.normal, // Apply bold to selected item
          ),
        ),
      ),
      PopupMenuItem<int>(
        value: 1,
        height: 0,
        padding: EdgeInsets.symmetric(
            horizontal: 12.adaptSize, vertical: 5.adaptSize),
        child: Obx(
          () => CustomTextView(
            text: controller.tabList[1],
            fontSize: 15.fSize,
            textAlign: TextAlign.start,
            fontWeight: controller.dashboardController.chatTabIndex.value == 1
                ? FontWeight.w600
                : FontWeight.normal, // Apply bold to selected item
          ),
        ),
      ),
      PopupMenuItem<int>(
        value: 2,
        height: 0,
        padding: EdgeInsets.symmetric(
            horizontal: 12.adaptSize, vertical: 5.adaptSize),
        child: Obx(
          () => CustomTextView(
            text: controller.tabList[2],
            fontSize: 15.fSize,
            textAlign: TextAlign.start,
            fontWeight: controller.dashboardController.chatTabIndex.value == 2
                ? FontWeight.w600
                : FontWeight.normal, // Apply bold to selected item
          ),
        ),
      ),
    ];
  }

  void getDataByIndexPage(int index) {
    controller.dashboardController.chatTabIndex(index);
    switch (index) {
      case 0:
        controller.getActiveChatList();
        break;
      case 1:
        controller.getReceivedChatList();
        break;
      case 2:
        controller.getSentChatList();
        break;
    }
    // Trigger UI update
    controller.update();
  }

  ///currently us not used for radio Widget
/*Widget _buildChatFilterDialog() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            width: 155.adaptSize,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Container(
                        width: context.width,
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: indicatorColor, width: 1),
                            color: _isPopupMenuOpen.value
                                ? colorSecondary
                                : Colors.white, // Use the reactive value
                            borderRadius: const BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset("assets/svg/ic_sort.svg"),
                            const SizedBox(
                              width: 7,
                            ),
                            Expanded(child: CustomTextView(
                              text:
                              selectedFilter.value.isNotEmpty
                                  ? selectedFilter.value
                                  : "search here",
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              maxLines: 2,
                            ),),
                          ],
                        )),
                    items: ["Active Chats","Request Received","Requested Chats"]
                        .map((String option) => DropdownMenuItem<String>(
                      value: option,
                      child: SizedBox(
                        child: Container(
                          padding: const EdgeInsets.only(left: 12.0,top: 0,bottom: 0),
                          child: CustomTextView(
                            text: option,
                            fontSize: 14,
                            textAlign: TextAlign.start,
                            fontWeight: selectedFilter.value == option?FontWeight.w500:FontWeight.normal,
                            color: colorPrimary,
                          ),
                        ),
                      ),
                    ))
                        .toList(),
                    //value: ,
                    onChanged: (String? option) {
                      _isPopupMenuOpen(false);
                      if (selectedFilter.value == option) {
                        selectedFilter.value = "";
                      } else {
                        selectedFilter.value = option??"";
                      }
                      setState(() {});
                    },
                    buttonStyleData: const ButtonStyleData(
                      height: 50,
                      width: double.infinity,
                    ),
                    iconStyleData: const IconStyleData(
                      icon: SizedBox.shrink(), // Hide the icon
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 220,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: white,
                      ),
                      offset: const Offset(0, 0),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.zero,
                        height: 30
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }*/
}
