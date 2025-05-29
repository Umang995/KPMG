import 'dart:convert';

import 'package:dreamcast/api_repository/app_url.dart';
import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/view/Notes/controller/my_notes_controller.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/breifcase/controller/common_document_controller.dart';
import 'package:dreamcast/view/breifcase/model/common_document_request.dart';
import 'package:dreamcast/view/commonController/bookmark_request_model.dart';
import 'package:dreamcast/view/exhibitors/model/exibitors_detail_model.dart';
import 'package:dreamcast/view/myFavourites/controller/favourite_boot_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../api_repository/api_service.dart';
import '../../../model/common_model.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/dialog_constant.dart';
import '../../Notes/model/common_notes_model.dart';
import '../../breifcase/model/BriefcaseModel.dart';
import '../../myFavourites/model/BookmarkIdsModel.dart';
import '../../representatives/model/user_count_model.dart';
import '../../representatives/model/save_notes_model.dart';
import '../model/exhibitorTeamModel.dart';
import '../model/exhibitors_filter_model.dart';
import '../model/exibitorsModel.dart';
import '../model/product_detail_model.dart';
import '../model/product_list_model.dart';
import '../request_model/request_model.dart';
import '../view/document_list_page.dart';
import '../view/exhibitors_details_page.dart';
import '../view/video_list_page.dart';

class BoothController extends GetxController {
  late bool hasNextPage = false;

  late int _pageNumber = 0;

  var isFirstLoadRunning = false.obs;
  var isLoading = false.obs;
  var isFavLoading = false.obs;
  var isBookmarkLoaded = false.obs;

  var isLoadMoreRunning = false.obs;

  final textController = TextEditingController().obs;
  final CommonDocumentController _documentController = Get.find();

  final AuthenticationManager authenticationManager = Get.find();

  final MyNotesController notesController = Get.find();
  ScrollController scrollController = ScrollController();
  var exhibitorsList = <Exhibitors>[].obs;
  var exhibitorsFeatureList = <Exhibitors>[].obs;
  var exhibitorsBody = ExhibitorsBody().obs;

  var documentList = <DocumentData>[].obs;
  var productList = <Products>[].obs;

  var exhibitorsMenuList = <MenuItem>[].obs;

  //list of ids to send to check the bookmark
  var userIdsList = <dynamic>[];
  //used for match the ids to user ids
  var bookMarkIdsList = <dynamic>[].obs;

  ScrollController userScrollController = ScrollController();

  var documentIdsList = <dynamic>[];
  //used for match the ids to user ids
  var bookmarkDocumentIdsList = <dynamic>[].obs;

  //note section
  var notesData = NotesDataModel().obs;
  var isEditNotes = false.obs;
  final TextEditingController notesEdtController = TextEditingController();
  var recommendedIdsList = <dynamic>[].obs;
  bool isStartup = false;

  ///used for the refresh the page.
  final GlobalKey<RefreshIndicatorState> _refreshTab1Key =
      GlobalKey<RefreshIndicatorState>();
  GlobalKey<RefreshIndicatorState> get refreshTab1Key => _refreshTab1Key;

  ///used for the filter data
  var exhibitorFilterData = ExhibitorFilterData().obs;
  var tempExhibitorFilterData = ExhibitorFilterData().obs;
  var isFilterApply = false.obs;

  var isReset = false.obs;
  var isNotesFilter = false.obs;

  var isNotesLoading = false.obs;

  ///used for the filter data
  BootRequestModel bootRequestModel = BootRequestModel();
  var totalUserCount = "".obs;
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      isEditNotes(Get.arguments[MyConstant.isNotes]);

      ///isStartup = Get.arguments[MyConstant.isStartup];///used only startup networking
    }

    ///its a initial request for the get the data
    bootRequestModel = BootRequestModel(
        favourite: 0,
        featured: 0,
        filters: RequestFilters(
            text: textController.value.text.trim() ?? "",
            sort: "",
            notes: isEditNotes.value));
    hasNextPage = true;
    exhibitorMenuList();
    getApiData();
  }

  @override
  void onReady() {
    super.onReady();
    if (isStartup == false) {
      bootRequestModel.featured = 0;
      getFeatureExhibitorsList(isRefresh: false);
    }
  }

  getApiData() async {
    bootRequestModel.featured = 0;
    textController.value.clear();
    bootRequestModel.filters?.text = "";
    await getExhibitorsList(isRefresh: false);
  }

  ///get the total user count
  Future<void> getUserCount({required isRefresh}) async {
    isNotesLoading(true);
    bootRequestModel.featured = 0;
    final userCountModel = UserCountModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: bootRequestModel,
        url: "${AppUrl.exhibitorsListApi}/getTotalCount",
      ),
    ));

    isNotesLoading(false);
    if (userCountModel.status! &&
        userCountModel.code == 200 &&
        userCountModel.body != null) {
      totalUserCount(userCountModel.body?.total.toString());
    }
  }

  ///create a menu list
  Future<void> exhibitorMenuList() async {
    exhibitorsMenuList.add(MenuItem.createItem(
        title: "ask_question".tr,
        iconUrl: ImageConstant.ask_question,
        id: "ask_a_question",
        isSelected: false));
    exhibitorsMenuList.add(MenuItem.createItem(
        title: "videos".tr,
        id: "videos",
        iconUrl: ImageConstant.ic_video_link,
        isSelected: false));
    exhibitorsMenuList.add(MenuItem.createItem(
        title: "documents".tr,
        id: "documents",
        iconUrl: ImageConstant.ic_document_link,
        isSelected: false));

    exhibitorsMenuList.add(MenuItem.createItem(
        title: "feedback".tr,
        iconUrl: ImageConstant.menu_feedback,
        isSelected: false,
        id: "feedback"));
    /*exhibitorsMenuList.add(MenuItem.createItem(
        title: "contact_details".tr,
        iconUrl: "assets/svg/ic_contact.svg",
        isSelected: false));*/
  }

  ///load product list filter
  Future<void> getAndResetFilter(
      {required isRefresh, bool? isFromReset}) async {
    isLoading(isRefresh);

    final model = ExhibitorsFilterModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: {},
        url: "${AppUrl.exhibitorsListApi}/getFilters",
      ),
    ));
    if (model.status! && model.code == 200) {
      exhibitorFilterData(model.body);
      isNotesFilter(false);
      if (isFromReset == null) {
        tempExhibitorFilterData.value = model.body!;
      }
      update();
    }
    isLoading(false);
  }

  ///this is used for the remove the filter is its not applied.
  clearFilterIfNotApply() {
    if (isReset.value) {
      exhibitorFilterData(tempExhibitorFilterData.value);
      isReset(false);
    }
    exhibitorFilterData.value.filters?.forEach((data) {
      if (data.value is List) {
        data.value = data.options
                ?.where((opt) => opt.apply)
                .map((opt) => opt.id)
                .toList() ??
            [];
      } else {
        data.value = data.options
            ?.firstWhere((opt) => opt.apply, orElse: () => Options(id: ""))
            .id;
      }
    });

    ///this is used to reset the default value after filter is not apply
    final filter = exhibitorFilterData.value;
    filter.notes?.value = filter.notes?.apply;
  }

  ///get the list of exhibitor
  Future<void> getExhibitorsList({
    required bool isRefresh,
  }) async {
    getUserCount(isRefresh: true);
    try {
      // Set up initial loading state
      _pageNumber = 1;
      bootRequestModel.page = 1;

      if (!isRefresh) {
        isFirstLoadRunning(true);
      }

      // Fetch the exhibitors list from API
      final model = ExhibitorsModel.fromJson(json.decode(
        await apiService.dynamicPostRequest(
          body: bootRequestModel,
          url: "${AppUrl.exhibitorsListApi}/search",
        ),
      ));
      isFirstLoadRunning(false);
      if (model != null && model.status == true && model.code == 200) {
        _handleSuccessResponse(model);
      }
    } catch (e, stacktrace) {
      _handleException(e, stacktrace);
    } finally {
      isFirstLoadRunning(false);
      update();
    }
  }

  void _handleSuccessResponse(ExhibitorsModel model) {
    exhibitorsList.clear();
    hasNextPage = model.body?.hasNextPage ?? false;
    _pageNumber++;

    exhibitorsList.addAll(model.body?.exhibitors ?? []);
    userIdsList.clear();
    userIdsList.addAll(model.body?.exhibitors?.map((obj) => obj.id) ?? []);

    // Fetch bookmarks and recommendations
    getBookmarkAndRecommendedByIds();
    // Load more exhibitors if there are more pages
  }

  void _handleException(dynamic e, StackTrace stacktrace) {
    // Log or handle exceptions
    print("Error fetching exhibitors: $e");
    print("Stacktrace: $stacktrace");
  }

  ///add pagination for exhibitor
  Future<void> loadMoreExhibitor() async {
    isLoadMoreRunning(true);
    bootRequestModel.page = _pageNumber;
    try {
      final model = ExhibitorsModel.fromJson(json.decode(
        await apiService.dynamicPostRequest(
          body: bootRequestModel,
          url: "${AppUrl.exhibitorsListApi}/search",
        ),
      ));
      if (model.status! && model.code == 200) {
        hasNextPage = model.body!.hasNextPage!;
        _pageNumber = _pageNumber + 1;
        exhibitorsList.addAll(model.body!.exhibitors!);
        print("@@@ list length ${exhibitorsList.length}");
        userIdsList.addAll(
            model.body!.exhibitors!.map((obj) => obj.id.toString()).toList());
        update();
        await getBookmarkAndRecommendedByIds();
      }
    } catch (e) {
      print(e.toString());
    }
    isLoadMoreRunning(false);
  }

  saveEditNotesApi(BuildContext context) async {
    var postRequest = {
      "id": notesData.value.id ?? "",
      "item_id": exhibitorsBody.value.id ?? "",
      "item_type": MyConstant.exhibitor,
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

  ///get the list of exhibitor
  Future<void> getFeatureExhibitorsList({
    required bool isRefresh,
  }) async {
    try {
      // Fetch the feature exhibitors list from API
      final model = ExhibitorsModel.fromJson(json.decode(
        await apiService.dynamicPostRequest(
          body: {
            "filters": {"text": "", "sort": ""},
            "featured": 1,
            "favourite": 0,
            "page": 1
          },
          url: "${AppUrl.exhibitorsListApi}/search",
        ),
      ));
      if (model.status == true && model.code == 200) {
        exhibitorsFeatureList.clear();
        exhibitorsFeatureList.addAll(model.body?.exhibitors ?? []);
      }
    } catch (e, stacktrace) {
      _handleException(e, stacktrace);
      isFirstLoadRunning(false);
    } finally {
      update();
    }
  }

  //load detail of exhibitor
  bool cancelRequestDetail = false;
  Future<void> getExhibitorsDetail(dynamic id) async {
    if (!authenticationManager.isLogin()) {
      DialogConstantHelper.showLoginDialog(Get.context!, authenticationManager);
      return;
    }
    notesData.value.text = "";
    notesEdtController.text = "";
    isEditNotes(true);
    isLoading(true);

    final model = ExhibitorsDetailsModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: {"id": id},
        url: "${AppUrl.exhibitorsListApi}/get",
      ),
    ));

    isLoading(false);
    if (model != null && (model.status ?? true) && model.code == 200) {
      exhibitorsBody.value = ExhibitorsBody();
      exhibitorsBody.value = model.body!;
      if (cancelRequestDetail) {
        isLoading(false);
        return; // Exit method early if user cancels
      }
      Get.toNamed(ExhibitorsDetailPage.routeName);
      getUserNotes(requestBody: {
        "item_type": MyConstant.exhibitor,
        "item_id": exhibitorsBody.value.id ?? "",
      });
    } else {
      print(model?.code.toString() ?? "Failed to get exhibitors detail");
    }
  }

  getBookmarkAndRecommendedByIds() async {
    if (!authenticationManager.isLogin()) {
      return;
    }
    getBookmarkIds();
    getRecommendedIds();
  }

  ///get recommended items
  Future<void> getRecommendedIds() async {
    if (userIdsList.isEmpty) {
      return;
    }

    final model = BookmarkIdsModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: {"users": userIdsList},
          url: "${AppUrl.exhibitorsListApi}/getAiRecommended"),
    ));

    if (model.status! && model.code == 200) {
      // Extract the list from the body and filter items with recommended == true
      recommendedIdsList.addAll(model.body!
          .where((item) => item.isRecommended == true)
          .map((item) => item.id)
          .toList());
    } else {
      print(model.code.toString());
    }
  }

  //get recommended items
  Future<void> getBookmarkIds() async {
    isBookmarkLoaded(true);
    bookMarkIdsList.value = await _documentController.getCommonBookmarkIds(
        items: userIdsList, itemType: MyConstant.exhibitor);
    isBookmarkLoaded(false);
  }

  ///get notes text
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

  ///load document list and bookmark ids by exhibitor id
  Future<void> getExhibitorsDocument(
      {required type, required isRefresh, required context}) async {
    isLoading(!isRefresh);

    final model = CommonDocumentModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: CommonDocumentRequest(
              itemId: exhibitorsBody.value.id ?? "",
              itemType: "exhibitor",
              type: type,
              favourite: 0),
          url: AppUrl.getCommonDocument),
    ));

    isLoading(false);
    if (model.status == true && model.code == 200) {
      documentIdsList.clear();
      documentList.clear();
      if (model.body?.isNotEmpty == true) {
        if (type == "videos") {
          documentList.value = model.body!
              .where((item) =>
                  item.media?.type?.contains("youtube") == true ||
                  item.media?.type?.contains("vimeo") == true ||
                  item.media?.type?.contains("html5") == true)
              .toList();

          documentIdsList.addAll(documentList.map((obj) => obj.id));
          if (!isRefresh) {
            Get.toNamed(VideoListPage.routeName);
            bookmarkDocumentIdsList.value =
                await _documentController.getCommonBookmarkIds(
                    items: documentIdsList, itemType: "document");
          }
        } else if (type == "documents") {
          documentList.value = model.body!
              .where((item) =>
                  item.media?.type?.contains("pdf") == true ||
                  item.media?.type?.contains("image") == true)
              .toList();
          documentIdsList.addAll(documentList.map((obj) => obj.id));
          if (!isRefresh) {
            Get.toNamed(DocumentListPage.routeName);
            bookmarkDocumentIdsList.value =
                await _documentController.getCommonBookmarkIds(
                    items: documentIdsList, itemType: "document");
          }
        }
      } else {
        UiHelper.showFailureMsg(context, model.message ?? "");
      }
    }
  }

  ///bookmark to exhibitor item
  Future<void> bookmarkToExhibitorItem({
    required dynamic id,
    required dynamic itemType,
    BuildContext? context,
  }) async {
    final isDocument = itemType == MyConstant.document;
    if (isDocument) {
      if (bookmarkDocumentIdsList.contains(id)) {
        bookmarkDocumentIdsList.remove(id);
      } else {
        bookmarkDocumentIdsList.add(id);
      }
    } else {
      if (bookMarkIdsList.contains(id)) {
        bookMarkIdsList.remove(id);
        exhibitorsBody.value.favourite = "";
      } else {
        bookMarkIdsList.add(id);
        exhibitorsBody.value.favourite = id;
      }
    }
    bookMarkIdsList.refresh();
    exhibitorsBody.refresh();
    isFavLoading(true);
    var model = await _documentController.bookmarkToItem(
      requestBody: BookmarkRequestModel(itemType: itemType, itemId: id),
    );
    isFavLoading(false);
    final success = model["status"] ?? false;
    if (success == false && !isDocument) {
      removeItemFromBookmark(id);
    }
    bookMarkIdsList.refresh();
  }

  ///used for the delete the ite from the list at time time of bookmark
  void removeItemFromBookmark(String id) {
    if (Get.isRegistered<FavBootController>()) {
      FavBootController favouriteController = Get.find();
      // Remove item where 'id' matches 'idToDelete'
      favouriteController.favouriteBootList
          .removeWhere((item) => item.id == id);
      favouriteController.favouriteBootList.refresh();
    }
  }

  void shareEvent(
    BuildContext context,
  ) {
    // Deep link to the event, replace with your actual deep link logic
    String deepLink =
        "${authenticationManager.deeplinkUrl}?page=exhibitors&id=${exhibitorsBody.value.id}";
    // Format the content to be shared
    String shareText =
        'Explore ${exhibitorsBody.value.company} at Dreamcast Event app!\n'
        'Check out the ${exhibitorsBody.value.company} profile here: $deepLink';
    // Share the content using the share package
    Share.share(shareText);
  }

  @override
  void onClose() {
    super.onClose();
    Get.delete<BoothController>();
  }

  bool get isFilterApplied =>
      (exhibitorFilterData.value.filters?.any(
            (filter) =>
                filter.options?.any((option) => option.apply ?? false) ?? false,
          ) ??
          false) ||
      (exhibitorFilterData.value.notes?.value ?? false) ||
      (exhibitorFilterData.value.sort?.value?.isNotEmpty ?? false);
}

class MenuItem {
  String? title;
  String? id;
  String? iconUrl;
  bool isSelected = false;
  MenuItem.createItem(
      {required this.title,
      required this.iconUrl,
      required this.isSelected,
      this.id});
}
