import 'package:dreamcast/view/Notes/binding/user_notes_binding.dart';
import 'package:dreamcast/view/Notes/view/featureNetworkingPage.dart';
import 'package:dreamcast/view/Notes/view/notes_dashboard.dart';
import 'package:dreamcast/view/alert/pages/alert_dashboard.dart';
import 'package:dreamcast/view/beforeLogin/login/login_page_otp.dart';
import 'package:dreamcast/view/breifcase/view/breifcase_page.dart';
import 'package:dreamcast/view/exhibitors/view/bootUserListPage.dart';
import 'package:dreamcast/view/gallery/views/galleryDashboardPage.dart';
import 'package:dreamcast/view/globalSearch/page/global_search_page.dart';
import 'package:dreamcast/view/guide/controller/info_faq_binding.dart';
import 'package:dreamcast/view/guide/view/info_faq_dashboard.dart';
import 'package:dreamcast/view/leaderboard/binding/leaderboard_binding.dart';
import 'package:dreamcast/view/leaderboard/view/leaderboard__dashboard_page.dart';
import 'package:dreamcast/view/meeting/binding/meeting_binding.dart';
import 'package:dreamcast/view/meeting/view/meeting_details_page.dart';
import 'package:dreamcast/view/bestForYou/view/aiMatches_exhibitor_page.dart';
import 'package:dreamcast/view/guide/view/user_guide_page.dart';
import 'package:dreamcast/view/nearbyAttraction/view/nearbyAttractionPage.dart';
import 'package:dreamcast/view/photobooth/controller/photoboothBinding.dart';
import 'package:dreamcast/view/profileSetup/view/draft_profile_page.dart';
import 'package:dreamcast/view/support/view/faq_list_page.dart';
import 'package:dreamcast/view/home/screen/pagesUsView.dart';
import 'package:dreamcast/view/meeting/view/meeting_dashboard_page.dart';
import 'package:dreamcast/view/speakers/view/speaker_list_page.dart';
import 'package:dreamcast/view/partners/controller/partner_binding.dart';
import 'package:dreamcast/view/photobooth/view/photoBooth.dart';
import 'package:dreamcast/view/photos/view/photo_list_page.dart';
import 'package:dreamcast/view/profileSetup/controller/edit_profile_controller_binding.dart';
import 'package:dreamcast/view/qrCode/controller/qrbadge_binding.dart';
import 'package:dreamcast/view/quiz/view/quiz_page.dart';
import 'package:dreamcast/view/schedule/binding/session_binding.dart';
import 'package:dreamcast/view/speakers/binding/speaker_detail_binding.dart';
import 'package:dreamcast/view/startNetworking/view/pitchStage/binding/pitchStageBinding.dart';
import 'package:dreamcast/view/travelDesk/binding/travelBinding.dart';
import 'package:dreamcast/view/travelDesk/view/travelSaveFormPage.dart';
import 'package:dreamcast/view/travelDesk/view/travelDeskPage.dart';
import 'package:get/get.dart';
import 'package:dreamcast/view/account/view/account_page.dart';
import 'package:dreamcast/view/beforeLogin/login/login_binding.dart';
import 'package:dreamcast/view/dashboard/dashboard_binding.dart';
import 'package:dreamcast/view/beforeLogin/splash/splash_binding.dart';
import 'package:dreamcast/view/beforeLogin/splash/splash_page.dart';
import 'package:dreamcast/view/dashboard/dashboard_page.dart';
import 'package:dreamcast/view/more/widget/timezone_page.dart';
import 'package:dreamcast/view/more/widget/sucess_page.dart';
import 'package:dreamcast/view/profileSetup/view/edit_profile_page.dart';
import '../view/IFrame/binding/customWebviewBinding.dart';
import '../view/Notes/binding/user_feature_binding.dart';
import '../view/account/controller/account_binding.dart';
import '../view/account/controller/setting_binding.dart';
import '../view/account/view/privacy_preference.dart';
import '../view/account/view/settingPage.dart';
import '../view/alert/controller/alert_binding.dart';
import '../view/bestForYou/binding/aiMatch_binding.dart';
import '../view/bestForYou/view/aiMatch_dashboard_page.dart';
import '../view/breifcase/controller/resource_center_binding.dart';
import '../view/breifcase/view/resourceCenter.dart';
import '../view/chat/view/chatDashboard.dart';
import '../view/eventFeed/controller/event_feed_binding.dart';
import '../view/exhibitors/binding/exhibitor_binding.dart';
import '../view/askQuestion/view/ask_question_page.dart';
import '../view/globalSearch/globalSearchBinding.dart';
import '../view/home/screen/inAppWebview.dart';
import '../view/myFavourites/binding/favourite_binding.dart';
import '../view/myFavourites/view/favourite_dashboard.dart';
import '../view/myFavourites/view/favourite_session_page.dart';
import '../view/eventFeed/view/feedListPage.dart';
import '../view/eventFeed/view/upload_post_page.dart';
import '../view/myFavourites/view/for_you_dashboard.dart';
import '../view/partners/view/partnersPage.dart';
import '../view/polls/view/pollsPage.dart';
import '../view/qrCode/view/qr_dashboard_page.dart';
import '../view/contact/view/contact_list_page.dart';
import '../view/exhibitors/view/document_list_page.dart';
import '../view/exhibitors/view/bootListPage.dart';
import '../view/exhibitors/view/exhibitors_details_page.dart';
import '../view/quiz/controller/feedback_binding.dart';
import '../view/quiz/view/feedback_page.dart';
import '../view/exhibitors/view/video_list_page.dart';
import '../view/products/view/product_list_page.dart';
import '../view/products/view/product_details_page.dart';
import '../view/representatives/view/userDetailsPage.dart';
import '../view/schedule/view/session_dashboard_page.dart';
import '../view/speakers/binding/speaker_binding.dart';
import '../view/speakers/view/speakers_details_page.dart';
import '../view/startNetworking/controller/investor_binding.dart';
import '../view/startNetworking/view/angelAlly/angelHallListpage.dart';
import '../view/startNetworking/view/investerAndMentoring/InvestorListPage.dart';
import '../view/startNetworking/view/investerAndMentoring/investorDetailsPage.dart';
import '../view/startNetworking/view/dashboard/networkingDashboard.dart';
import '../view/startNetworking/view/dashboard/startupDashboard.dart';
import '../view/startNetworking/view/pitchStage/pitchStageList.dart';
import '../view/support/controller/helpdesk_binding.dart';
import '../view/support/view/helpdeskDashboard.dart';
part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
        name: Routes.INITIAL,
        page: () => const SplashScreen(),
        binding: SplashBinding()),
    GetPage(
        name: Routes.LOGIN,
        page: () => LoginPageOTP(),
        binding: LoginBinding()),
    GetPage(
        name: DashboardPage.routeName,
        bindings: [
          RootBinding(),
          //FavouriteDashboardBinding(),
          //OneToOneBinding(),
        ],
        page: () => DashboardPage()),
    GetPage(
        binding: HelpDeskBinding(),
        name: HelpDeskDashboard.routeName,
        page: () => HelpDeskDashboard(
              showToolbar: false,
            )),
    GetPage(
        binding: AiMatchDashboardBinding(),
        name: AiMatchDashboardPage.routeName,
        page: () => const AiMatchDashboardPage()),
    GetPage(
        binding: InfoFaqBinding(),
        name: InfoFaqDashboard.routeName,
        page: () => InfoFaqDashboard()),
    GetPage(
        name: SocialFeedListPage.routeName,
        //binding: EventFeedBinding(),
        page: () => SocialFeedListPage(
              isFromLaunchpad: false,
            )),
    GetPage(
        binding: SettingBinding(),
        name: SettingPage.routeName,
        page: () => SettingPage()),
    GetPage(
        binding: EditProfileControllerBinding(),
        name: ProfileEditPage.routeName,
        page: () => const ProfileEditPage()),
    GetPage(
        binding: EditProfileControllerBinding(),
        name: DraftProfilePage.routeName,
        page: () => const DraftProfilePage()),
    GetPage(
        name: ForYouDashboard.routeName,
        page: () => const ForYouDashboard(),
        binding: FavouriteDashboardBinding()),
    GetPage(
        name: ResourceCenterListPage.routeName,
        page: () => ResourceCenterListPage(),
        binding: ResourceCenterBinding()),
    GetPage(
        binding: MeetingDashboardBinding(),
        name: MyMeetingList.routeName,
        page: () => MyMeetingList()),
    GetPage(
        binding: SponsorPartnerBinding(),
        name: SponsorsList.routeName,
        page: () => SponsorsList()),
    GetPage(
        name: BoothListPage.routeName,
        page: () => BoothListPage(
              showAppbar: true,
            ),
        binding: ExhibitorBinding()),
    GetPage(
      name: LeaderboardDashboardPage.routeName,
      page: () => const LeaderboardDashboardPage(),
      binding: LeaderboardBinding(),
    ),
    GetPage(
        name: FeatureNetworkingPage.routeName,
        page: () => FeatureNetworkingPage(),
        binding: UserFeatureBinding()),
    GetPage(
        name: GlobalSearchPage.routeName,
        page: () => GlobalSearchPage(),
        binding: GlobalSearchBinding()),
    GetPage(
        name: ExhibitorsDetailPage.routeName,
        page: () => ExhibitorsDetailPage(),
        binding: ExhibitorBinding()),
    /* GetPage(
      name: SpeakerListPage.routeName,
      page: () => SpeakerListPage(),
      bindings: [SpeakerBinding()],
    ),*/
    GetPage(
      name: SpeakerListPage.routeName,
      page: () => SpeakerListPage(),
      bindings: [SpeakerBinding()],
    ),
    GetPage(
        name: SessionDashboardPage.routeName,
        page: () => SessionDashboardPage(),
        bindings: [SessionBinding()]),
    /* GetPage(
        name: FeaturedSpeakersListPage.routeName,
        page: () => FeaturedSpeakersListPage(),
        binding: SpeakerBinding()),*/
    GetPage(
        name: SpeakersDetailPage.routeName,
        page: () => SpeakersDetailPage(),
        binding: SpeakerDetailBinding()),
    GetPage(
        binding: FeedbackBinding(),
        name: FeedbackPage.routeName,
        page: () => FeedbackPage()),
    GetPage(
        binding: CustomWebViewBinding(),
        name: CustomWebViewPage.routeName,
        page: () => CustomWebViewPage()),
    GetPage(
      binding: AccountBinding(),
      name: AccountPage.routeName,
      page: () => AccountPage(),
    ),

    /*no used binding method*/
    GetPage(name: PhotoListPage.routeName, page: () => PhotoListPage()),
    GetPage(name: ProductListPage.routeName, page: () => ProductListPage()),
    GetPage(name: UserDetailPage.routeName, page: () => UserDetailPage()),
    GetPage(
        name: AiMatchExhibitorPage.routeName,
        page: () => AiMatchExhibitorPage()),
    GetPage(name: ChatDashboardPage.routeName, page: () => ChatDashboardPage()),
    GetPage(name: MyContactListPage.routeName, page: () => MyContactListPage()),
    GetPage(
        name: GalleryDashboardPage.routeName,
        page: () => GalleryDashboardPage()),

    /*boot section*/
    GetPage(
        name: VideoListPage.routeName,
        page: () => VideoListPage(
              showAppbar: true,
            )),
    /*boot section*/
    GetPage(name: DocumentListPage.routeName, page: () => DocumentListPage()),
    GetPage(name: FaqListPage.routeName, page: () => FaqListPage()),
    GetPage(name: UserGuideList.routeName, page: () => UserGuideList()),
    GetPage(name: MeetingDetailPage.routeName, page: () => MeetingDetailPage()),
    GetPage(
        name: NearbyAttractionPage.routeName,
        page: () => NearbyAttractionPage()),
    GetPage(
        bindings: [TravelBinding()],
        name: TravelDashboardPage.routeName,
        page: () => TravelDashboardPage()),
    GetPage(
        name: TravelSaveFormPage.routeName, page: () => TravelSaveFormPage()),
    GetPage(
        bindings: [AlertPageBinding()],
        name: AlertDashboard.routeName,
        page: () => AlertDashboard()),
    GetPage(name: PollsPage.routeName, page: () => PollsPage()),
    GetPage(
        binding: PhotoBoothBinding(),
        name: AIPhotoSeachPage.routeName,
        page: () => AIPhotoSeachPage()),
    GetPage(name: UploadPostPage.routeName, page: () => UploadPostPage()),
    GetPage(name: TimezonePage.routeName, page: () => TimezonePage()),
    GetPage(name: QuizPage.routeName, page: () => QuizPage()),
    GetPage(name: PrivacyPreference.routeName, page: () => PrivacyPreference()),
    GetPage(name: ProductDetailPage.routeName, page: () => ProductDetailPage()),
    GetPage(
        binding: QRBadgeBinding(),
        name: QRDashboardPage.routeName,
        page: () => const QRDashboardPage()),
    GetPage(
      name: SucessPage.routeName,
      page: () => SucessPage(message: ""),
    ),
    GetPage(
        name: PagesView.routeName,
        page: () => PagesView(
              title: '',
              slug: '',
            )),
    GetPage(
        name: NetworkingDashboard.routeName,
        page: () => const NetworkingDashboard()),
    GetPage(name: StartupDashboard.routeName, page: () => StartupDashboard()),
    GetPage(name: AskQuestionPage.routeName, page: () => AskQuestionPage()),
    GetPage(
        name: NotesDashboard.routeName,
        page: () => NotesDashboard(),
        binding: UserNotesBinding()),
    GetPage(
      name: BriefcasePage.routeName,
      page: () => BriefcasePage(),
    ),
    GetPage(
        name: InvestorListPage.routeName,
        page: () => InvestorListPage(),
        binding: InvestorBinding()),
    GetPage(
        name: InvestorDetailPage.routeName, page: () => InvestorDetailPage()),
    GetPage(name: AngelHallListPage.routeName, page: () => AngelHallListPage()),
    GetPage(
        name: PitchStageList.routeName,
        page: () => PitchStageList(),
        binding: PitchStageBinding()),
    GetPage(
      name: BootUserListPage.routeName,
      page: () => BootUserListPage(),
      binding: ExhibitorBinding(),
    ),
  ];
}
