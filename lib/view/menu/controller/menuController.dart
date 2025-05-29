import 'dart:convert';
import 'dart:io';

import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/view/askQuestion/view/ask_question_page.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/chat/view/chatDashboard.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:dreamcast/view/gallery/controller/galleryController.dart';
import 'package:dreamcast/view/gallery/views/galleryDashboardPage.dart';
import 'package:dreamcast/view/home/controller/home_controller.dart';
import 'package:dreamcast/view/menu/model/menu_data_model.dart';
import 'package:dreamcast/view/myFavourites/controller/favourite_controller.dart';
import 'package:dreamcast/view/photobooth/controller/downloadImageController.dart';
import 'package:dreamcast/view/photobooth/controller/photobooth_controller.dart';
import 'package:dreamcast/view/speakers/controller/speakerNetworkController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../model/guide_model.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/dialog_constant.dart';
import '../../../utils/file_manager.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/fullscreen_image.dart';
import '../../IFrame/socialWallController.dart';
import '../../IFrame/socialWallpage.dart';
import '../../Notes/controller/my_notes_controller.dart';
import '../../Notes/view/notes_dashboard.dart';
import '../../account/controller/account_controller.dart';
import '../../alert/pages/alert_dashboard.dart';
import '../../bestForYou/view/aiMatch_dashboard_page.dart';
import '../../breifcase/controller/common_document_controller.dart';
import '../../breifcase/view/breifcase_page.dart';
import '../../breifcase/view/resourceCenter.dart';
import '../../eventFeed/controller/eventFeedController.dart';
import '../../eventFeed/view/feedListPage.dart';
import '../../exhibitors/controller/exhibitorsController.dart';
import '../../exhibitors/view/bootListPage.dart';
import '../../guide/view/info_faq_dashboard.dart';
import '../../home/screen/inAppWebview.dart';
import '../../home/screen/pdfViewer.dart';
import '../../leaderboard/view/leaderboard__dashboard_page.dart';
import '../../meeting/controller/meetingController.dart';
import '../../meeting/view/meeting_dashboard_page.dart';
import '../../meeting/view/meeting_details_page.dart';
import '../../myFavourites/view/for_you_dashboard.dart';
import '../../nearbyAttraction/view/nearbyAttractionPage.dart';
import '../../partners/controller/partnersController.dart';
import '../../partners/view/partnersPage.dart';
import '../../photobooth/view/photoBooth.dart';
import '../../polls/controller/pollsController.dart';
import '../../polls/view/pollsPage.dart';
import '../../profileSetup/view/draft_profile_page.dart';
import '../../profileSetup/view/edit_profile_page.dart';
import '../../qrCode/view/qr_dashboard_page.dart';
import '../../quiz/view/feedback_page.dart';
import '../../representatives/controller/user_detail_controller.dart';
import '../../schedule/controller/session_controller.dart';
import '../../schedule/view/watch_session_page.dart';
import '../../speakers/controller/speakersController.dart';
import '../../speakers/view/speaker_list_page.dart';
import '../../support/view/helpdeskDashboard.dart';
import '../../travelDesk/view/travelDeskPage.dart';
import 'package:http/http.dart' as http;

import '../model/more_button_model.dart';

class HubController extends GetxController {
  var loading = false.obs;
  var contentLoading = false.obs;

  var hubMenuMain = <MenuData>[].obs;
  var hubTopMenu = <MenuData>[].obs;

  var galleryFrameUrl = "";
  var aboutUsHtml = "";
  AuthenticationManager authenticationManager = Get.find();
  DashboardController dashboardController = Get.find();
  HomeController homeController = Get.find();
  bool _isButtonDisabled = false;

  @override
  void onInit() {
    super.onInit();
    getHubMenuAPi(isRefresh: false);
  }

  Future<void> getHtmlPage(
      {required String title,
      required String slug,
      required bool isExternal}) async {
    UiHelper.isInternetConnect().then((isConnected) async {
      if (isConnected) {
        try {
          contentLoading(true);
          final model = IFrameModel.fromJson(json.decode(
            await apiService.dynamicGetRequest(
              url: "${AppUrl.iframe}/$slug",
            ),
          ));
          contentLoading(false);
          if (model.status == true) {
            final body = model.body;
            // Handle API body status
            if (body?.status == false) {
              UiHelper.showFailureMsg(
                  null, body?.messageData?.body ?? "Something went wrong");
              return;
            }
            final webview = body?.webview;
            if (webview != null) {
              if (webview.contains("pdf")) {
                offlineDownloadPdf(
                    fileName: title, networkPath: webview, isConnected: true);
              } else if (webview.toLowerCase().endsWith(".png") ||
                  webview.toLowerCase().endsWith(".jpg") ||
                  webview.toLowerCase().endsWith(".jpeg")) {
                Get.to(() => FullImageView(imgUrl: webview));
              } else if (isExternal) {
                UiHelper.externalWebView(Uri.parse(webview ?? ""));
              } else {
                Get.toNamed(CustomWebViewPage.routeName, arguments: {
                  "page_url": webview,
                  "title": title,
                });
              }
            } else {
              UiHelper.showFailureMsg(null, "Webview data is missing");
            }
          } else {
            UiHelper.showFailureMsg(
                null, model.message ?? "Failed to load data");
          }
        } catch (e) {
          contentLoading(false);
          UiHelper.showFailureMsg(null, "An error occurred: $e");
        }
      } else {
        offlineDownloadPdf(
            fileName: title, networkPath: "", isConnected: false);
      }
    });
  }

  Future<void> offlineDownloadPdf({
    required String fileName,
    required String networkPath,
    required bool isConnected,
  }) async {
    final directory = await FileManager.instance.getDocumentsDirectoryPath;
    final filePath = '$directory/$fileName.pdf';
    final pdfFile = File(filePath);

    if (isConnected) {
      // 1. Show PDF directly from the URL
      Get.to(PdfViewPage(
        htmlPath: networkPath,
        title: fileName,
        isLocalDataShow: false,
      ));

      // 2. Download and save PDF in the background
      try {
        final response = await http.get(Uri.parse(networkPath));
        if (response.statusCode == 200) {
          await FileManager.instance
              .saveFile("$fileName.pdf", response.bodyBytes);
          PrefUtils.saveDocumentPath(fileName, networkPath);
        }
      } catch (e) {
        print("Error downloading PDF: $e");
        // Silent catch - logging can be added if needed
      }
    } else {
      // Offline: show from local file if available
      if (await pdfFile.exists()) {
        Get.to(PdfViewPage(
          htmlPath: filePath,
          title: fileName,
          isLocalDataShow: true,
        ));
      } else {
        UiHelper.showFailureMsg(null, "Please check your internet connection.");
      }
    }
  }

  ///used for the open the other options
  Future<void> openMoreButton(
      {required String id, required String title}) async {
    contentLoading(true);
    final model = MoreButtonModel.fromJson(json.decode(
      await apiService
          .dynamicPostRequest(url: AppUrl.navigationMenuById, body: {"id": id}),
    ));
    contentLoading(false);
    String url = model.body?.url ?? "";
    String widget = model.body?.widgetType ?? "";

    if (widget.contains("pdf")) {
      Get.to(PdfViewPage(htmlPath: url, title: title, isLocalDataShow: false));
    } else if (widget.contains("image")) {
      Get.to(() => FullImageView(imgUrl: url));
    } else if (widget.contains("external_link")) {
      UiHelper.externalWebView(Uri.parse(url));
    } else {
      // Handles both "in_app_link" and the default case
      Get.toNamed(CustomWebViewPage.routeName, arguments: {
        "page_url": url,
        "title": title,
      });
    }
  }

  ///get dynamic menu options
  Future<void> getHubMenuAPi({required bool isRefresh}) async {
    try {
      loading(!isRefresh);
      final model = MenuDataModel.fromJson(json.decode(
        await apiService.dynamicGetRequest(
          url: AppUrl.navigationMenu,
        ),
      ));
      loading(false);
      if (model.status! && model.code == 200) {
        hubTopMenu.clear();
        hubMenuMain.clear();

        hubTopMenu.addAll(model.body?.hubTop ?? []);
        hubMenuMain.addAll(model.body?.hubMain ?? []);

        homeController.menuHorizontalHome(model.body?.homeProfile ?? []);
        homeController.menuFeatureHome(model.body?.homeFeature ?? []);
        homeController.menuFooterHome(model.body?.lunchFooter ?? []);
        if (Get.isRegistered<AccountController>()) {
          AccountController accountController = Get.find();
          accountController.profileMenu(model.body?.userProfile ?? []);
        } else {
          AccountController accountController = Get.put(AccountController());
          accountController.profileMenu(model.body?.userProfile ?? []);
        }
      }
    } catch (e) {
      print(e.toString());
      loading(false);
    }
  }

  void commonMenuRouting({required MenuData menuData}) async {
    print(
        "141 deep link ${menuData.pageId} ${menuData.slug}  ${menuData.role}");
    if (_isButtonDisabled) return; // Prevent further clicks
    _isButtonDisabled = true;
    Future.delayed(const Duration(seconds: 2), () {
      _isButtonDisabled =
          false; // Re-enable the button after the screen is closed
    });

    // Helper to check login and show dialog if not logged in
    bool isLoggedIn() {
      if (!authenticationManager.isLogin()) {
        DialogConstantHelper.showLoginDialog(
            Get.context!, authenticationManager);
        return false;
      }
      return true;
    }

    // Helper to handle navigation
    void navigateTo(String routeName, {Map<String, dynamic>? arguments}) {
      Get.toNamed(routeName, arguments: arguments);
    }

    // Switch case for routing
    switch (menuData.slug) {
      case "resource_center":
        _handleController<CommonDocumentController>((controller) =>
            controller.getDocumentList(isRefresh: false, limitedMode: false));
        navigateTo(ResourceCenterListPage.routeName,
            arguments: {MyConstant.titleKey: menuData.label});
        break;

      case "infodesk":
        navigateTo(InfoFaqDashboard.routeName,
            arguments: {MyConstant.titleKey: menuData.label});
        break;

      case "my_profile":
        if (isLoggedIn()) {
          _handleController<AccountController>(
              (controller) => controller.callDefaultApi());
          dashboardController.changeTabIndex(4);
        }
        break;

      case "leaderboard":
        if (isLoggedIn()) {
          navigateTo(LeaderboardDashboardPage.routeName,
              arguments: {MyConstant.titleKey: menuData.label});
        }
        break;

      case "poll":
      case "event_poll":
        if (isLoggedIn()) {
          _deleteController<PollController>();
          navigateTo(PollsPage.routeName, arguments: {
            "item_type": "event",
            "item_id": "",
            MyConstant.titleKey: menuData.label
          });
        }
        break;
      case "session_poll":
        if (isLoggedIn()) {
          _deleteController<PollController>();
          navigateTo(PollsPage.routeName, arguments: {
            "item_type": "webinar",
            "item_id": menuData.pageId ?? "",
            MyConstant.titleKey: menuData.label
          });
        }
        break;
      case "event_ask_a_question":
        if (isLoggedIn()) {
          Get.toNamed(AskQuestionPage.routeName, arguments: {
            "item_id": "",
            "item_type": "event",
          });
        }
        break;
      case "feedback":
      case "event_feedback":
        if (isLoggedIn()) {
          navigateTo(FeedbackPage.routeName,
              arguments: {MyConstant.titleKey: menuData.label});
        }
        break;

      case "my_badge":
        if (isLoggedIn()) {
          navigateTo(QRDashboardPage.routeName,
              arguments: {MyConstant.titleKey: menuData.label});
        }
        break;

      case "networking":
        if (menuData.pageId?.isNotEmpty ?? false) {
          openUserDetails(
              menuData.pageId ?? "", menuData.role ?? MyConstant.attendee);
        } else {
          dashboardController.changeTabIndex(3);
        }
        break;

      case "exhibitors":
        if (menuData.pageId?.isNotEmpty ?? false) {
          openExhibitorDetails(
              menuData.pageId ?? "", menuData.role ?? MyConstant.exhibitor);
        } else {
          _deleteController<BoothController>();
          navigateTo(BoothListPage.routeName,
              arguments: {MyConstant.titleKey: menuData.label});
        }
        break;

      case "speakers":
        if (menuData.pageId?.isNotEmpty ?? false) {
          openSpeakerDetails(
              menuData.pageId ?? "", menuData.role ?? MyConstant.speakers);
        } else {
          navigateTo(SpeakerListPage.routeName,
              arguments: {MyConstant.titleKey: menuData.label});
        }
        break;

      case "agenda":
        getHtmlPage(
            title: menuData.label ?? "", slug: "agenda", isExternal: false);
        break;

      case "helpdesk":
        navigateTo(HelpDeskDashboard.routeName,
            arguments: {MyConstant.titleKey: menuData.label});
        break;

      case "partners":
        _handleController<SponsorPartnersController>((controller) {
          controller.allSponsorsPartnersListApi(
              requestBody: {"limited_mode": false}, isRefresh: true);
        });
        navigateTo(SponsorsList.routeName,
            arguments: {MyConstant.titleKey: menuData.label});
        break;

      case "session":
      case "sessions":
        if (menuData.pageId?.isNotEmpty ?? false) {
          openScheduleDetail(menuData.pageId ?? "");
        } else {
          dashboardController.changeTabIndex(1);
        }
        break;

      case "feeds":
        if (isLoggedIn()) {
          _handleController<EventFeedController>(
              (controller) => controller.getEventFeed(isLimited: false));
          navigateTo(SocialFeedListPage.routeName,
              arguments: {MyConstant.titleKey: menuData.label});
        }
        break;

      case "social_wall":
        _handleController<SocialWallController>((controller) async {
          await controller.getSocialWallUrl();
          Get.to(() => SocialWallPage(
                title: menuData.label,
                showToolbar: true,
              ));
        });
        break;
      case "b2b_meeting":
      case "meetingDetail":
      case "my_meetings":
        if (isLoggedIn()) {
          if (menuData.pageId?.isNotEmpty ?? false) {
            openMeetingDetail(menuData.pageId ?? "");
          } else {
            navigateTo(MyMeetingList.routeName);
          }
        }
        break;

      case "ai_gallery":
        if (isLoggedIn()) {
          if (Get.isRegistered<PhotoBoothController>()) {
            PhotoBoothController photoBoothController =
                Get.put(PhotoBoothController());
            photoBoothController
                .getAllPhotos(body: {"page": "1"}, isRefresh: false);
          } else {
            PhotoBoothController photoBoothController =
                Get.put(PhotoBoothController());
            photoBoothController
                .getAllPhotos(body: {"page": "1"}, isRefresh: false);
          }
          navigateTo(AIPhotoSeachPage.routeName,
              arguments: {MyConstant.titleKey: menuData.label});
        }
        break;

      case "floorplan":
        getHtmlPage(
            title: menuData.label ?? "",
            slug: menuData.slug ?? MyConstant.slugFloorMap,
            isExternal: false);
        break;

      case "photobooth":
        if (isLoggedIn()) {
          getHtmlPage(
              title: menuData.label ?? "",
              slug: MyConstant.slugPhotoBoothWall,
              isExternal: true);
        }
        break;

      case "ai_matches":
        if (isLoggedIn()) {
          navigateTo(AiMatchDashboardPage.routeName,
              arguments: {MyConstant.titleKey: menuData.label});
        }
        break;

      case "briefcase":
        if (isLoggedIn()) {
          _handleController<CommonDocumentController>(
              (controller) => controller.getBriefcaseList(isRefresh: false));
          navigateTo(BriefcasePage.routeName,
              arguments: {MyConstant.titleKey: menuData.label});
        }
        break;

      case "near_by_attractions":
        navigateTo(NearbyAttractionPage.routeName,
            arguments: {MyConstant.titleKey: menuData.label});
        break;

      case "favourites":
        if (isLoggedIn()) {
          _handleController<FavouriteController>(
              (controller) => controller.tabIndexAndSearch(true));
          navigateTo(ForYouDashboard.routeName,
              arguments: {MyConstant.titleKey: menuData.label});
        }
        break;

      case "travel_desk":
        if (isLoggedIn()) {
          navigateTo(TravelDashboardPage.routeName,
              arguments: {MyConstant.titleKey: menuData.label});
        }
        break;

      case "my_notes":
        if (isLoggedIn()) {
          _deleteController<MyNotesController>();
          navigateTo(NotesDashboard.routeName,
              arguments: {MyConstant.titleKey: menuData.label});
        }
        break;

      case "image":
      case "pdf":
      case "in-app-link":
      case "external-link":
        openMoreButton(title: menuData.label ?? "", id: menuData.id ?? "");
        break;

      case "alert":
        navigateTo(AlertDashboard.routeName);
        break;
      case "other":
        UiHelper.externalWebView(Uri.parse(menuData.url ?? ""));
        break;
      case "aiprofile":
        if (isLoggedIn()) {
          navigateTo(DraftProfilePage.routeName,
              arguments: {MyConstant.isAiProfile: true});
        }
        break;
      case "chat":
      case "new_message":
        if (isLoggedIn()) {
          navigateTo(ChatDashboardPage.routeName,
              arguments: menuData.slug == "new_message"
                  ? {"chat_data": authenticationManager.notificationNode}
                  : null);
        }
        break;
      case "images":
        if (isLoggedIn()) {
          GalleryController galleryController = Get.put(GalleryController());
          galleryController.selectedTabIndex(0);
          galleryController.getGalleryList();
          navigateTo(GalleryDashboardPage.routeName,
              arguments: {MyConstant.titleKey: menuData.label ?? "Gallery"});
        }
        break;
    }
  }

  // Helper to handle controller logic
  T _handleController<T>(void Function(T controller) action) {
    if (Get.isRegistered<T>()) {
      T controller = Get.find();
      action(controller);
      return controller;
    }
    return Get.put<T>(Get.find<T>());
  }

// Helper to delete a controller
  void _deleteController<T>() {
    if (Get.isRegistered<T>()) {
      Get.delete<T>();
    }
  }

  /// Method to open the schedule detail page based on the session ID.
  openScheduleDetail(String sessionId) async {
    if (!authenticationManager.isLogin()) {
      return;
    }
    var controller = Get.put(SessionController());
    // Fetch session details using the controller.
    dashboardController.loading(true);
    var result =
        await controller.getSessionDetail(requestBody: {"id": sessionId});
    dashboardController.loading(false);
    if (result["status"]) {
      // Check if the session has an embed link; navigate to WatchDetailPage or SessionDetailPage.
      Get.to(() => WatchDetailPage(sessions: controller.sessionDetailBody));
    }
  }

  /// Method to open the meeting detail page based on the session ID.
  openMeetingDetail(String sessionId) async {
    if (!authenticationManager.isLogin()) {
      return;
    }
    MeetingController controller = Get.put(MeetingController());
    // Fetch meeting details using the controller.
    dashboardController.loading(true);
    var result =
        await controller.getMeetingDetail(requestBody: {"id": sessionId});
    dashboardController.loading(false);
    if (result['status']) {
      // Navigate to the meeting detail page.
      Get.toNamed(MeetingDetailPage.routeName);
    } else {
      // Show error message if meeting details are not found.
      UiHelper.showFailureMsg(
        null,
        result['message'] ?? "meeting_details_not_found".tr,
      );
    }
  }

  /// Method to open the user detail page based on the user ID.
  openUserDetails(String userId, String role) async {
    if (!authenticationManager.isLogin()) {
      return;
    }
    final UserDetailController controller =
        Get.isRegistered<UserDetailController>()
            ? Get.find()
            : Get.put(UserDetailController());
    // Fetch meeting details using the controller.
    dashboardController.loading(true);
    await controller.getUserDetailApi(userId, role);
    dashboardController.loading(false);
  }

  /// Method to open the boot detail page based on the boot ID.
  openExhibitorDetails(String userId, String role) async {
    if (!authenticationManager.isLogin()) {
      return;
    }
    var controller = Get.put(BoothController());
    // Fetch meeting details using the controller.
    dashboardController.loading(true);
    await controller.getExhibitorsDetail(userId);
    dashboardController.loading(false);
  }

  /// Method to open the speaker detail page based on the speaker ID.
  openSpeakerDetails(String userId, String role) async {
    if (!authenticationManager.isLogin()) {
      return;
    }
    var controller = Get.put(SpeakersDetailController());
    // Fetch meeting details using the controller.
    dashboardController.loading(true);
    await controller.getSpeakerDetail(
        speakerId: userId, role: role, isSessionSpeaker: true);
    dashboardController.loading(false);
  }
}
