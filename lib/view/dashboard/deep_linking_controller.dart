import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:dreamcast/api_repository/app_url.dart';
import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/view/account/controller/setting_controller.dart';
import 'package:dreamcast/view/breifcase/controller/common_document_controller.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:dreamcast/view/dashboard/dashboard_page.dart';
import 'package:dreamcast/view/menu/controller/menuController.dart';
import 'package:dreamcast/view/photobooth/view/photoBooth.dart';
import 'package:dreamcast/view/quiz/view/feedback_page.dart';
import 'package:dreamcast/view/representatives/controller/user_detail_controller.dart';
import 'package:dreamcast/view/schedule/view/session_list_page.dart';
import 'package:dreamcast/view/speakers/controller/speakersController.dart';
import 'package:get/get.dart';
import '../../theme/ui_helper.dart';
import '../alert/pages/alert_dashboard.dart';
import '../beforeLogin/globalController/authentication_manager.dart';
import '../chat/view/chatDashboard.dart';
import '../eventFeed/view/feedListPage.dart';
import '../exhibitors/controller/exhibitorsController.dart';
import '../exhibitors/view/bootListPage.dart';
import '../meeting/controller/meetingController.dart';
import '../meeting/view/meeting_dashboard_page.dart';
import '../meeting/view/meeting_details_page.dart';
import '../menu/model/menu_data_model.dart';
import '../polls/controller/pollsController.dart';
import '../polls/view/pollsPage.dart';
import '../profileSetup/view/edit_profile_page.dart';
import '../schedule/controller/session_controller.dart';
import '../schedule/view/watch_session_page.dart';

/// Controller for handling deep linking in the app using GetX.
class DeepLinkingController extends GetxController {
  // Reference to the authentication manager, fetched using Get.find().
  final AuthenticationManager _authManager = Get.find();
  final DashboardController dashboardController = Get.find();

  // Observable variable to track the loading state.
  var loading = false.obs;

  // Deep linking instance and stream subscription for listening to app links.
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void onInit() {
    super.onInit();
    Get.lazyPut<HubController>(() => HubController());
    Get.lazyPut<CommonDocumentController>(() => CommonDocumentController());
    // Initialize deep linking when the controller is initialized.
    navigatePageAsPerNotification();
  }

  @override
  void onReady() {
    super.onReady();
    _initAppLinks();
  }

  /// Method to navigate to different pages based on the notification data.
  navigatePageAsPerNotification() async {
    if (!Get.isRegistered<HubController>()) {
      Get.lazyPut<HubController>(() => HubController());
    }
    HubController hubController = Get.find();
    print("_authManager.pageRouteName ${_authManager.pageRouteName}");
    print("_authManager.pageRouteId ${_authManager.pageRouteId}");

    hubController.commonMenuRouting(
        menuData: MenuData(
            pageId: _authManager.pageRouteId,
            icon: "",
            role: _authManager.role ?? "",
            slug: _authManager.pageRouteName));
    _authManager.pageRouteName = "";
    _authManager.pageRouteId = "";
  }

  /// Initialize deep linking and listen for incoming links.
  Future<void> _initAppLinks() async {
    _appLinks = AppLinks();

    try {
      // Get the initial link when the app starts.
      final uri = await _appLinks.getInitialLink();
      if (uri == null || uri.toString().isEmpty) return;
      print("141 Initial link: $uri");
      getTheParameter(uri);
    } catch (e) {
      print('Failed to get initial uri: $e');
    }

    // Listen for incoming URI links while the app is running.
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (uri == null || uri.toString().isEmpty) return;
      dashboardController.loading(true);
      Future.delayed(const Duration(seconds: 3), () {
        dashboardController.loading(false);
        getTheParameter(uri);
      });
    }, onError: (err) => print('Error: $err'));
  }

  getTheParameter(Uri uri) {
    print('141 Received URI: $uri');
    // Extract query parameters from the URI.
    final queryParams = uri.queryParameters;
    if (queryParams['page'] != null) {
      _authManager.pageRouteName = queryParams['page'] ?? "";
      if (queryParams['role'] != null) {
        _authManager.role = queryParams['role'] ?? "";
      }
      if (queryParams['id'] != null) {
        _authManager.pageRouteId = queryParams['id'] ?? "";
      }
    }
    // Navigate based on the extracted page name and ID.
    if (_authManager.pageRouteName.isNotEmpty ||
        _authManager.pageRouteId.isNotEmpty) {
      navigatePageAsPerNotification();
    }
    print(
        "Page: ${_authManager.pageRouteName}, ID: ${_authManager.pageRouteId}");
  }

  @override
  void dispose() {
    // Cancel the link subscription when the controller is disposed.
    _linkSubscription?.cancel();
    super.dispose();
  }
}
