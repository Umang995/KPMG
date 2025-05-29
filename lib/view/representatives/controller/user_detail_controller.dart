import 'dart:convert';

import 'package:dreamcast/model/common_model.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/view/Notes/controller/my_notes_controller.dart';
import 'package:dreamcast/view/breifcase/controller/common_document_controller.dart';
import 'package:dreamcast/view/myFavourites/controller/favourite_user_controller.dart';
import 'package:dreamcast/widgets/dialog/custom_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/dialog_constant.dart';
import '../../../widgets/dialog/custom_animated_dialog_widget.dart';
import '../../Notes/model/common_notes_model.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../commonController/bookmark_request_model.dart';
import '../../commonController/controller/common_chat_meeting_controller.dart';
import '../../myFavourites/model/BookmarkIdsModel.dart';
import '../model/user_detail_model.dart';
import '../view/userDetailsPage.dart';
import 'networkingController.dart';

class UserDetailController extends GetxController {
  final AuthenticationManager _authenticationManager = Get.find();
  AuthenticationManager get authenticationManager => _authenticationManager;

  final CommonDocumentController _documentController = Get.find();

  final commonChatMeetingController = Get.put(CommonChatMeetingController());

  final TextEditingController notesEdtController = TextEditingController();
  var isLoading = false.obs;
  var isNotesLoading = false.obs;

  var isBookmarkLoaded = false.obs;

  var isChatLoading = false.obs;

  var selectedIndex = 0.obs;
  var allowedDate = "";
  var isBlocked = false.obs;

  final textController = TextEditingController().obs;

  ScrollController scrollController = ScrollController();
  //used for match the ids to user ids
  var bookMarkIdsList = <dynamic>[].obs;
  var recommendedIdsList = <dynamic>[].obs;

  var userIdsList = <dynamic>[];

  var userDetailBody = UserDetailBody().obs;

  var role = MyConstant.attendee;

  var selectedSort = "ASC".obs;

  var notesData = NotesDataModel().obs;
  var isEditNotes = false.obs;
  var pageTitle = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getBookmarkAndRecommendedByIds() async {
    if (!authenticationManager.isLogin()) {
      return;
    }
    getBookmarkIds();
    getRecommendedIds();
    Future.delayed(const Duration(seconds: 3), () {
      isBookmarkLoaded(false);
    });
  }

  ///get bookmark Ids
  Future<void> getBookmarkIds() async {
    isBookmarkLoaded(true);
    bookMarkIdsList.value = await _documentController.getCommonBookmarkIds(
        items: userIdsList, itemType: MyConstant.networking);
    isBookmarkLoaded(false);
    print("@@@ bookmark finish ai");
  }

  clearDefaultList() {
    bookMarkIdsList.clear();
    recommendedIdsList.clear();
  }

  Future<void> getRecommendedIds() async {
    try {
      if (userIdsList.isEmpty) {
        return;
      }

      final model = BookmarkIdsModel.fromJson(json.decode(
        await apiService.dynamicPostRequest(
            body: {"users": userIdsList},
            url: "${AppUrl.usersListApi}/getAiRecommended"),
      ));

      if (model.status! && model.code == 200) {
        // Extract the list from the body and filter items with recommended == true
        if (model.body != null) {
          recommendedIdsList.addAll(model.body!
              .where((item) => item.isRecommended == true)
              .map((item) => item.id)
              .toList());
        }
      } else {
        print(model.code.toString());
        return;
      }
    } catch (exception) {
      debugPrint(exception.toString());
    } finally {
      // Code here will run whether or not an exception was thrown
      debugPrint("Completed the process of fetching recommended IDs");
    }
  }

  //get user details
  Future<void> getUserDetailApi(
    dynamic id,
    role,
  ) async {
    if (!authenticationManager.isLogin()) {
      DialogConstantHelper.showLoginDialog(Get.context!, authenticationManager);
      return;
    }
    notesData.value.text = "";
    notesEdtController.text = "";
    isEditNotes(true);
    this.role = role;
    var body = {"id": id, "role": role};
    isLoading(true);
    final model = UserDetailModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: body,
        url: "${AppUrl.usersListApi}/get",
      ),
    ));

    isLoading(false);
    if (model.status! && model.code == 200) {
      userDetailBody.value = model.body!;
      isBlocked(
          userDetailBody.value.isBlocked.toString() == "1" ? true : false);
      pageTitle(role == MyConstant.attendee ? "Profile" : "Profile");
      Get.toNamed(UserDetailPage.routeName);
      commonChatMeetingController.getChatRequestStatus(
          isShow: false, receiverId: userDetailBody.value.id ?? "");
      getUserNotes(requestBody: {
        "item_type": role,
        "item_id": userDetailBody.value.id ?? "",
      });
      userDetailBody.refresh();
    } else {
      print(model.code.toString());
    }
  }

  //get notes text
  Future<void> getUserNotes({required requestBody}) async {
    if (!authenticationManager.isLogin()) {
      return;
    }
    isNotesLoading(true);
    final model = CommonNotesModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: requestBody,
        url: AppUrl.getNotes,
      ),
    ));
    isNotesLoading(false);
    if (model.status! && model.code == 200) {
      if (model.body != null && model.body!.isNotEmpty) {
        notesEdtController.text = model.body?[0].text ?? "";
        notesData(model.body?[0]);
        isEditNotes(notesData.value.text.toString().isNotEmpty ? false : true);
      } else {
        notesData(NotesDataModel());
      }
    }
  }

  saveEditNotesApi(BuildContext context) async {
    MyNotesController notesController = Get.isRegistered<MyNotesController>()
        ? Get.find()
        : Get.put(MyNotesController());
    var postRequest = {
      "id": notesData.value.id ?? "",
      "item_id": userDetailBody.value.id ?? "",
      "item_type": userDetailBody.value.role,
      "text": notesEdtController.text.trim().toString()
    };
    isLoading(true);
    var result = await notesController.addNotesToUser(postRequest);
    isLoading(false);
    if (result['status'] == true) {
      isEditNotes(!isEditNotes.value);
      notesData(NotesDataModel(text: result["text"], id: result["id"]));
      refresh();
      print(notesData);
    } else {
      notesData.value.text = "";
    }
  }

  /*used for attendee*/
  Future<dynamic> bookmarkToUser(
      dynamic id, dynamic role, BuildContext context) async {
    if (bookMarkIdsList.contains(id)) {
      bookMarkIdsList.remove(id);
      removeItemFromBookmark(id);
    } else {
      bookMarkIdsList.add(id);
    }
    _documentController.bookmarkToItem(
        requestBody: BookmarkRequestModel(itemType: role, itemId: id));
    return true;
  }

  ///used for the delete the ite from the list at time time of bookmark
  void removeItemFromBookmark(String id) {
    Future.delayed(const Duration(seconds: 1), () {
      if (Get.isRegistered<FavUserController>()) {
        FavUserController favouriteController = Get.find();
        // Remove item where 'id' matches 'idToDelete'
        favouriteController.favouriteAttendeeList
            .removeWhere((item) => item.id == id);
        favouriteController.favouriteAttendeeList.refresh();
      }
    });
  }

  void saveBlockUnblockDialog(
      {required context, required content, required body}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogWidget(
          title: isBlocked.value ? "Unblock?" : "Block?",
          logo: ImageConstant.block,
          description:
              "Are you sure you want to ${isBlocked.value ? "unblock" : "block"} this user.",
          buttonAction: isBlocked.value ? "Yes, Unblock" : "Yes, Block",
          buttonCancel: "Cancel",
          onCancelTap: () {},
          onActionTap: () async {
            isLoading(true);
            final model = CommonModel.fromJson(json.decode(
              await apiService.dynamicPostRequest(
                body: body,
                url: "${AppUrl.blockUnblockUser}/save",
              ),
            ));
            isLoading(false);
            if (model.status! && model.code == 200) {
              isBlocked(!isBlocked.value);
              if (isBlocked.value) {
                removeTheBlockedUser(userId: body["block_user_id"]);
              }
              await Get.dialog(
                  barrierDismissible: false,
                  CustomAnimatedDialogWidget(
                    title: "",
                    logo: ImageConstant.icSuccessAnimated,
                    description: model.body!.message ?? "",
                    buttonAction: "okay".tr,
                    buttonCancel: "cancel".tr,
                    isHideCancelBtn: true,
                    onCancelTap: () {},
                    onActionTap: () async {},
                  ));
            } else {
              UiHelper.showFailureMsg(null, model.body?.message ?? "");
            }

            //Get.back();
            //;
          },
        );
      },
    );
  }

  removeTheBlockedUser({userId}) {
    final NetworkingController networkingController = Get.find();
    networkingController.attendeeList.removeWhere((user) => user.id == userId);
    networkingController.getUserCount(isRefresh: false);
    networkingController.attendeeList.refresh();
  }

  void shareEvent(
    BuildContext context,
  ) {
    // Deep link to the event, replace with your actual deep link logic

    String deepLink =
        "${authenticationManager.deeplinkUrl}?page=${MyConstant.networking}&role=$role&id=${userDetailBody.value.id}";
    // Format the content to be shared
    String shareText =
        'Meet ${userDetailBody.value.name} at Dreamcast Event app!\n'
        'Check out the ${userDetailBody.value.role} profile here: $deepLink';

    // Share the content using the share package
    Share.share(shareText);
  }
}
