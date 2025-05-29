import 'dart:async';
import 'dart:convert';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dreamcast/model/common_model.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/breifcase/controller/common_document_controller.dart';
import 'package:dreamcast/view/exhibitors/controller/exhibitorsController.dart';
import 'package:dreamcast/view/myFavourites/controller/favourite_controller.dart';
import 'package:dreamcast/view/schedule/model/sessin_detail_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../main.dart';
import '../../../model/guide_model.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/dialog_constant.dart';
import '../../../widgets/textview/customTextView.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../beforeLogin/splash/model/config_model.dart';
import '../../bestForYou/controller/aiMatchController.dart';
import '../../commonController/bookmark_request_model.dart';
import '../../dashboard/dashboard_controller.dart';
import '../../exhibitors/model/bookmark_common_model.dart';
import '../../myFavourites/controller/favourite_session_controller.dart';
import '../../quiz/model/sessionPollModel.dart';
import '../../representatives/controller/user_detail_controller.dart';
import '../../speakers/controller/speakersController.dart';
import '../model/sessionPollsStatus.dart';
import '../model/scheduleModel.dart';
import '../model/session_filter_model.dart';
import '../model/speaker_webinar_model.dart';
import '../request_model/session_request_model.dart';
import 'booking_controller.dart';

enum BookingType { auto_approval, admin_assign, admin_approval }

class SessionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final DashboardController dashboardController = Get.find();
  final CommonDocumentController commonController = Get.find();

  final AuthenticationManager _authManager = Get.find();
  ScrollController tabScrollController = ScrollController();
  TextEditingController textController = TextEditingController();
  AuthenticationManager get authManager => _authManager;

  var loading = false.obs;
  var isFirstLoading = true.obs;
  var isBookmarkLoaded = false.obs;

  var sessionList = <SessionsData>[].obs;
  var liveSessionList = <SessionsData>[].obs;
  var mySessionList = <SessionsData>[].obs;

  var menuParentItemList = <MenuItem>[];

  final mSessionDetailBody = SessionsData().obs;

  var dateObject = Params();

  SessionsData get sessionDetailBody => mSessionDetailBody.value;

  var selectedFilterSort = "ASC".obs;
  var defaultDate = "";

  final agendaPdf = "".obs;
  final selectedTabIndex = 0.obs;
  final selectedDayIndex = 0.obs;

  var userIdsList = <dynamic>[];
  var userSpeakerIdsList = <dynamic>[];
  //used for match the ids to user ids
  var bookMarkIdsList = <dynamic>[].obs;

  //reaction
  var emoticonsSelected = "".obs;

  //pagination of session
  late bool hasNextPage;
  late int _pageNumber;
  var isLoadMoreRunning = false.obs;
  ScrollController scrollController = ScrollController();

  Set<String> existingAuditoriumKeys = {};

  ///used for the filter data
  var isReset = false.obs;

  var sessionFilterBody = SessionFilterBody().obs;
  var tempSessionFilterBody = SessionFilterBody().obs;
  var isFilterApply = false.obs;
  var isActiveHappening = false.obs; // button `Happening Now`

  SessionRequestModel sessionRequestModel = SessionRequestModel();

  ///refresh the page.
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  GlobalKey<RefreshIndicatorState> get refreshIndicatorKey =>
      _refreshIndicatorKey;

  ///better player controller
  late VideoPlayerController videoPlayerController;

  var isStreaming = false.obs;

  var tabList = <Tabs>[].obs;

  late TabController _tabController;
  TabController get tabController => _tabController;

  @override
  void onInit() {
    super.onInit();
    sessionRequestModel = SessionRequestModel(
        page: 1,
        favourite: 0,
        filters: RequestFilters(
            text: textController.text.trim().toString(),
            sort: "ASC",
            params: RequestParams(date: defaultDate)));
    loadTabsFromApi();
    getChildMenu();
    dependencies();
  }

  void loadTabsFromApi() {
    // Replace with your actual API/response logic
    if (authManager.configModel.body?.sessionSettings?.tabs != null) {
      tabList.value = authManager.configModel.body!.sessionSettings!.tabs!
          .where((e) => e.status == "1")
          .toList();
      _tabController = TabController(length: tabList.length, vsync: this);
    } else {
      tabList.value = [
        Tabs(label: "sessions".tr, value: "sessions"),
        Tabs(label: "aiSessions".tr, value: "aiSessions"),
        Tabs(label: "mySessions".tr, value: "mySessions"),
      ];
      _tabController = TabController(length: tabList.length, vsync: this);
    }
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    // Handle only actual tab switch, not rebuilds
    if (_tabController.indexIsChanging) {
      final newIndex = _tabController.index;
      final selectedTab = tabList[newIndex];

      if ((selectedTab.value == "aiSessions" ||
              selectedTab.value == "myBookings" ||
              selectedTab.value == "mySessions") &&
          !_authManager.isLogin()) {
        DialogConstantHelper.showLoginDialog(
          navigatorKey.currentState!.context!,
          _authManager,
        );

        // Revert to previously selected tab
        _tabController.index = selectedTabIndex.value;
        return;
      }
      selectedTabIndex.value = newIndex;
      selectedTabIndex.refresh();
      refreshTheTab();
    }
  }

  initApiCall() {
    getApiData();
    _loadInitialAudiFirebaseData();
  }

  getApiData() async {
    textController.clear();
    isFilterApply(false);
    sessionRequestModel.filters?.text = "";
    sessionRequestModel.filters?.params = RequestParams(date: defaultDate);
    if (await UiHelper.isNoInternet()) {
      return;
    }
    await getAndResetFilter(isRefresh: true, isFromReset: false);
    await getSessionList(isRefresh: false);
  }

  dependencies() {
    Get.lazyPut(() => FavouriteController(), fenix: true);
    Get.lazyPut(() => SpeakersDetailController(), fenix: true);
    Get.lazyPut(() => FavSessionController(), fenix: true);
    Get.lazyPut(() => SessionBookingController(), fenix: true);
    Get.lazyPut(() => AiMatchController(), fenix: true);
    Get.lazyPut(() => UserDetailController(), fenix: true);
  }

  refreshTheTab() {
    // Handle only actual tab switch, not rebuilds
    final selectedTab = tabList[_tabController.index];
    switch (selectedTab.value) {
      case "sessions":
        getApiData();
        break;
      case "aiSessions":
        dashboardController.selectedAiMatchIndex(1);
        final aiMatchController = Get.isRegistered<AiMatchController>()
            ? Get.find<AiMatchController>()
            : Get.put(AiMatchController());

        aiMatchController.getDataByIndexPage(3);
        break;
      case "mySessions":
        getFavSessionData();
        break;
      case "myBookings":
        getBookingSessionData();
        break;
    }
  }

  getFavSessionData() {
    if (Get.isRegistered<FavSessionController>()) {
      FavSessionController favSessionController = Get.find();
      favSessionController.getApiData();
    }
  }

  getBookingSessionData() {
    if (Get.isRegistered<SessionBookingController>()) {
      SessionBookingController favSessionController = Get.find();
      favSessionController.getApiData();
    }
  }

  Future<void> _loadInitialAudiFirebaseData() async {
    DataSnapshot snapshot = await _authManager.firebaseDatabase
        .ref("${AppUrl.defaultFirebaseNode}/auditoriums")
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      // Store existing keys in the Set
      data.forEach((key, value) {
        existingAuditoriumKeys.add(key);
      });
      initAudiRefUpdate();
    } else {
      initAudiRefUpdate();
    }
  }

  initAudiRefUpdate() {
    _authManager.firebaseDatabase
        .ref("${AppUrl.defaultFirebaseNode}/auditoriums")
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        String childKey = event.snapshot.key!;
        if (!existingAuditoriumKeys.contains(childKey)) {
          final json = event.snapshot.value as Map<dynamic, dynamic>;
          for (var index in Iterable<int>.generate(sessionList.length)) {
            if (sessionList[index].id == event.snapshot.key) {
              sessionList[index].status?.color = json['status']['color'];
              sessionList[index].status?.value = json['status']['value'];
              sessionList[index].status?.text = json['status']['text'];
              sessionList[index].embed = json['embed'];
              sessionList[index].embedPlayer = json['embed_player'];
              sessionList.refresh();
              if (mSessionDetailBody.value.id == event.snapshot.key) {
                mSessionDetailBody.value.status?.color =
                    json['status']['color'];
                mSessionDetailBody.value.status?.value =
                    json['status']['value'];
                mSessionDetailBody.value.status?.text = json['status']['text'];
                mSessionDetailBody.value.embed = json['embed'];
                mSessionDetailBody.value.embedPlayer = json['embed_player'];
                mSessionDetailBody.refresh();
              }
            }
          }
        }
      }
    });

    _authManager.firebaseDatabase
        .ref("${AppUrl.defaultFirebaseNode}/auditoriums")
        .onChildChanged
        .listen((event) {
      if (event.snapshot.value != null) {
        String childKey = event.snapshot.key!;
        final json = event.snapshot.value as Map<dynamic, dynamic>;
        for (var index in Iterable<int>.generate(sessionList.length)) {
          if (sessionList[index].id == childKey) {
            sessionList[index].status?.color = json['status']['color'];
            sessionList[index].status?.value = json['status']['value'];
            sessionList[index].status?.text = json['status']['text'];
            sessionList[index].embed = json['embed'];
            sessionList[index].embedPlayer = json['embed_player'];
            sessionList.refresh();
            if (mSessionDetailBody.value.id == event.snapshot.key) {
              mSessionDetailBody.value.status?.color = json['status']['color'];
              mSessionDetailBody.value.status?.value = json['status']['value'];
              mSessionDetailBody.value.status?.text = json['status']['text'];
              mSessionDetailBody.value.embed = json['embed'];
              mSessionDetailBody.value.embedPlayer = json['embed_player'];
              mSessionDetailBody.refresh();
              update();
            }
          }
        }
      }
    });
  }

  Future<SessionPollModel> initAuditoriumsRef({auditoriumId, sessionId}) async {
    final snapshot = await authManager.firebaseDatabase
        .ref(AppUrl.defaultFirebaseNode)
        .child("auditoriums")
        .child(auditoriumId)
        .child("sessions")
        .child(sessionId)
        .child("poll")
        .get();
    if (snapshot.value != null) {
      final json = snapshot.value as Map<dynamic, dynamic>;
      return SessionPollModel.fromJson(json);
    }
    return SessionPollModel();
  }

  //get session list data
  Future<void> getSessionList({required bool isRefresh}) async {
    if (await UiHelper.isNoInternet()) {
      return;
    }
    sessionRequestModel.page = 1;
    _pageNumber = 1;
    hasNextPage = false;
    isFirstLoading(!isRefresh);

    final model = ScheduleModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: sessionRequestModel,
        url: AppUrl.getSession,
      ),
    ));
    if (model.status == true && model.code == 200) {
      sessionList.clear();
      sessionList.addAll(model.body?.sessions ?? []);
      userIdsList.clear();
      if (model.body?.sessions != null) {
        userIdsList.addAll(model.body!.sessions!.map((obj) => obj.id).toList());
      }
      getBookmarkIds();
      getSpeakerWebinarList(userIdsList: userIdsList, sessionList: sessionList);
      hasNextPage = model.body?.hasNextPage ?? false;
      _pageNumber = _pageNumber + 1;
      if (hasNextPage) {
        _loadMore();
      }
    } else {
      print(model.code.toString());
    }
    isFirstLoading(false);
  }

  ///get more session data
  Future<void> _loadMore() async {
    scrollController.addListener(() async {
      if (hasNextPage == true &&
          isFirstLoading.value == false &&
          isLoadMoreRunning.value == false &&
          scrollController.position.maxScrollExtent ==
              scrollController.position.pixels) {
        isLoadMoreRunning(true);
        sessionRequestModel.page = _pageNumber;
        try {
          final model = ScheduleModel.fromJson(json.decode(
            await apiService.dynamicPostRequest(
              body: sessionRequestModel,
              url: AppUrl.getSession,
            ),
          ));
          if (model.status! && model.code == 200) {
            hasNextPage = model.body!.hasNextPage!;
            _pageNumber = _pageNumber + 1;
            sessionList.addAll(model.body?.sessions ?? []);
            userIdsList
                .addAll(model.body!.sessions!.map((obj) => obj.id).toList());
            getBookmarkIds();
            getSpeakerWebinarList(
                userIdsList: userIdsList, sessionList: sessionList);
            update();
          }
        } catch (e) {
          print(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }

  ///get the panelist of session.
  Future<void> getSpeakerWebinarList(
      {required userIdsList, required sessionList}) async {
    if (userIdsList.isEmpty ?? [].isEmpty) {
      return;
    }
    var requestBody = {"webinars": userIdsList};

    final model = SpeakerModelWebinarModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: requestBody,
        url: AppUrl.getSpeakerByWebinarId,
      ),
    ));

    if (model.status! && model.code == 200) {
      for (var session in sessionList) {
        var matchingSpeakerData = model.body!
            .firstWhere((speakerData) => speakerData.id == session.id);
        if (matchingSpeakerData != null) {
          session.speakers.clear();
          session.speakers?.addAll(matchingSpeakerData.sessionSpeaker ?? []);
          sessionList.refresh();
        }
      }
    } else {
      print(model.code.toString());
    }
  }

  ///get the session details by id
  Future<Map> getSessionDetail({required requestBody}) async {
    if (!authManager.isLogin()) {
      DialogConstantHelper.showLoginDialog(Get.context!, authManager);
      return {"status": false, "message": ""};
    }
    isStreaming(false);
    var result = {};
    loading(true);
    final model = SessionDetailModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: requestBody,
        url: AppUrl.getSessionDetail,
      ),
    ));
    loading(false);
    if (model.status! && model.code == 200) {
      if (model.body != null) {
        if (bookMarkIdsList.contains(sessionDetailBody.id)) {
          sessionDetailBody.bookmark = sessionDetailBody.id;
        }
        emoticonsSelected();
        mSessionDetailBody(model.body);
        result = {"status": model.status, "message": ""};
        getBookmarkIdDetail(sessionDetailBody.id);
        if (authManager.isLogin()) {
          getSpeakerWebinarListDetail(sessionDetailBody.id);
        }
      } else {
        result = {"status": false, "message": ""};
      }
    } else {
      result = {"status": false};
    }
    getSessionBanner();
    return result;
  }

  ///get the speaker of session
  Future<void> getSpeakerWebinarListDetail(sessionId) async {
    var requestBody = {
      "webinars": [sessionId]
    };

    final model = SpeakerModelWebinarModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
        body: requestBody,
        url: AppUrl.getSpeakerByWebinarId,
      ),
    ));
    try {
      if (model.status! && model.code == 200) {
        if (model.body != null && model.body!.isNotEmpty) {
          sessionDetailBody.speakers = model.body![0].sessionSpeaker ?? [];
        }
      } else {
        print(model.code.toString());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  /*accept and reject the request of meeting*/
  Future<Map> actionAgainstSessionBooking(
      {required requestBody, required url}) async {
    var result = {};
    loading(true);

    final model = BookmarkCommonModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(body: requestBody, url: url),
    ));

    loading(false);
    if (model.status! && model.code == 200) {
      result = {"status": true, "message": model.body?.message ?? ""};
    } else {
      result = {"status": false, "message": model.message ?? ""};
    }
    return result;
  }

  void getSessionBanner() {
    commonController.getBannerList(
        itemId: sessionDetailBody.id ?? "", itemType: "webinar_banner");
  }

  Future<void> getAndResetFilter(
      {required isRefresh, bool? isFromReset}) async {
    isFirstLoading(isRefresh);

    final model = SessionFilterModel.fromJson(json.decode(
      await apiService.dynamicGetRequest(
        url: AppUrl.sessionsFilter,
      ),
    ));
    if (model.status! && model.code == 200) {
      sessionFilterBody(model.body!);
      if (isFromReset == false) {
        tempSessionFilterBody.value = model.body!;
      } else {
        isFirstLoading(false);
      }
      // Using firstWhere to find the date by name
      dateObject = sessionFilterBody.value.params!
          .firstWhere((obj) => obj.name == "date", orElse: () => Params());
      if (dateObject.options != null) {
        defaultDate =
            dateObject.value?.toString() ?? dateObject.options?[0].value ?? "";

        ///set the default date to request
        sessionRequestModel.filters?.params?.date = defaultDate;
        int index = dateObject.options!
            .indexWhere((dateItem) => dateItem.value == defaultDate);
        selectedDayIndex(index);
        if (selectedDayIndex.value != 0 &&
            dateObject.options != null &&
            dateObject.options!.isNotEmpty) {
          Future.delayed(const Duration(seconds: 1), () {
            // Scroll to the selected item
            double itemWidth = 140.h + 12; // Width + margin
            tabScrollController.animateTo(
              selectedDayIndex.value * itemWidth,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        }
      }
      update();
    }
  }

  ///this is used for the remove the filter is its not applied.
  clearFilterIfNotApply() {
    if (isReset.value) {
      sessionFilterBody(tempSessionFilterBody.value);
      isReset(false);
    }
    sessionFilterBody.value.params?.forEach((data) {
      if (data.value is List) {
        data.value = data.options
                ?.where((opt) => opt.apply)
                .map((opt) => opt.value)
                .toList() ??
            [];
      } else {
        data.value = data.options
            ?.firstWhere((opt) => opt.apply, orElse: () => Options(value: ""))
            .value;
      }
    });
  }

  Future<void> bookmarkToSession({required id}) async {
    if (bookMarkIdsList.contains(id)) {
      bookMarkIdsList.remove(id);
      mSessionDetailBody.value.bookmark = "";
      removeItemFromBookmark(id);
    } else {
      bookMarkIdsList.add(id);
      mSessionDetailBody.value.bookmark = id;
    }
    mSessionDetailBody.refresh();
    commonController.bookmarkToItem(
        requestBody: BookmarkRequestModel(itemType: "webinar", itemId: id));
  }

  void removeItemFromBookmark(String id) {
    Future.delayed(const Duration(seconds: 1), () {
      if (Get.isRegistered<FavSessionController>()) {
        FavSessionController favouriteController = Get.find();
        // Remove item where 'id' matches 'idToDelete'
        favouriteController.favouriteSessionList
            .removeWhere((item) => item.id == id);
        favouriteController.favouriteSessionList.refresh();
      }
    });
  }

  Future<void> getChildMenu() async {
    menuParentItemList.add(MenuItem.createItem(
        title: "polls".tr,
        iconUrl: ImageConstant.ic_poll,
        isSelected: false,
        id: "poll"));
    menuParentItemList.add(MenuItem.createItem(
        title: "ask_question".tr,
        iconUrl: ImageConstant.ic_ask_question,
        isSelected: false,
        id: "ask_a_question"));
    menuParentItemList.add(MenuItem.createItem(
        title: "chat".tr,
        iconUrl: ImageConstant.ic_chat_session,
        isSelected: false,
        id: "chat"));
    menuParentItemList.add(MenuItem.createItem(
        title: "feedback".tr,
        iconUrl: ImageConstant.menu_feedback,
        isSelected: false,
        id: "feedback"));
  }

  Event buildEvent({Recurrence? recurrence, required SessionsData sessions}) {
    return Event(
      title: sessions.label ?? "",
      description: sessions.description ?? "",
      location: '',
      startDate: DateTime.parse(sessions.startDatetime ?? ""),
      endDate: DateTime.parse(sessions.endDatetime ?? ""),
      allDay: false,
      iosParams: const IOSParams(reminder: Duration(minutes: 40)),
      recurrence: recurrence,
    );
  }

  Event buildEventDetail(
      {Recurrence? recurrence, required SessionsData sessions}) {
    return Event(
      title: sessions.label ?? "",
      description: sessions.description ?? "",
      location: '',
      startDate: DateTime.parse(sessions.startDatetime ?? ""),
      endDate: DateTime.parse(sessions.endDatetime ?? ""),
      allDay: false,
      iosParams: const IOSParams(reminder: Duration(minutes: 40)),
      recurrence: recurrence,
    );
  }

  Future<void> getBookmarkIds() async {
    if (userIdsList.isEmpty) {
      return;
    }
    isBookmarkLoaded(false);
    bookMarkIdsList.value = await commonController.getCommonBookmarkIds(
        items: userIdsList, itemType: "webinar");
    isBookmarkLoaded(true);
  }

  /// it is for temporary set
  Future<void> getBookmarkIdDetail(id) async {
    var bookMarkIdsList = await commonController
        .getCommonBookmarkIds(items: [id], itemType: "webinar");
    sessionDetailBody.bookmark = bookMarkIdsList.contains(id) ? id : "";
    mSessionDetailBody.refresh();
  }

  Future<void> sendEmoticonsRequest(
      {required Map<String, dynamic> requestBody,
      required String previousSelection}) async {
    final model = CommonModel.fromJson(json.decode(
      await apiService.dynamicPostRequest(
          body: requestBody, url: AppUrl.webinarEmoticons),
    ));

    if (model.status! && model.code == 200) {
      // Keep the reacted state as it is
      //UiHelper.showSuccessMsg(null, model.body?.message ?? "");
    } else {
      // Revert back to previous state if API call fails
      emoticonsSelected(previousSelection);
      emoticonsSelected.refresh();
      UiHelper.showFailureMsg(null, model.body?.message ?? "");
    }
  }

  List<dynamic> getSessionHallWise(sessionId) {
    List outputList = sessionList
        .where((parentRoomModel) => parentRoomModel.id != sessionId)
        .toList();
    return outputList;
  }

  var selectedPollIndex = 100.obs;

  shareTheSession() {
    // Deep link to the event, replace with your actual deep link logic

    String deepLink =
        "${authManager.deeplinkUrl}?page=${MyConstant.sessions}&id=${mSessionDetailBody.value.id}";
    // Format the content to be shared
    String shareText = '${mSessionDetailBody.value.label}'
        '${(mSessionDetailBody.value.description?.isNotEmpty ?? false) ? '\n\n${mSessionDetailBody.value.description}' : ''}'
        '${(mSessionDetailBody.value.embed?.isNotEmpty ?? false) ? '\n\n${mSessionDetailBody.value.embed}' : ''}'
        '\n\nAccess the session details here: $deepLink';

    Share.share(shareText);
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  void playSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/like_soundeffect.mp3'));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }
}
