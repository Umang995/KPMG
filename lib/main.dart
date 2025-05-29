import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dreamcast/theme/controller/theme_controller.dart';
import 'package:dreamcast/utils/initial_bindings.dart';
import 'package:dreamcast/utils/logger.dart';
import 'package:dreamcast/utils/pref_utils.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dreamcast/routes/app_pages.dart';
import 'package:toastification/toastification.dart';
import 'fcm/firebase_options.dart';
import 'localization/app_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// Create a global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  final context = SecurityContext.defaultContext;
  context.allowLegacyUnsafeRenegotiation = true;
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: SystemUiOverlay.values);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
  ));

  // Clear all GetX controllers and dependencies
  Get.reset();
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await FlutterDownloader.initialize(
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  await Firebase.initializeApp(
      name: "Dreamcast-2024", options: DefaultFirebaseOptions.currentPlatform);
  AwesomeNotifications().initialize(
    null, // Your app icon resource
    [
      NotificationChannel(
        channelKey: 'high_importance_channel', // Channel key
        channelName: 'High Importance Notifications', // Channel name
        channelDescription:
            'Notification channel for Dreamcast 2024 notifications',
        defaultColor: Colors.blue,
        ledColor: Colors.blue,
        playSound: true,
        onlyAlertOnce: true,
        importance: NotificationImportance.High, // Set importance to High
      ),
    ],
  );
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  Logger.init(LogMode.live);
  await PrefUtils.init(); // ✅ wait for proper initialization
  Get.put(ThemeController()); // Register it before running the app
  runApp(MyApp());
}

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    await AwesomeNotifications().createNotificationFromJsonData(message.data);
  }
}

///don't used this for now.
initCrashlytics() {
  const fatalError = true;
  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };
  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };
}

class MyApp extends StatelessWidget {
  final themeController = Get.find<ThemeController>();

  MyApp({Key? key}) : super(key: key);
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return ToastificationWrapper(
        child: Obx(() => GetMaterialApp(
              theme: themeController.lightTheme,
              darkTheme: themeController.darkTheme,
              themeMode: themeController.themeMode.value,
              navigatorKey: navigatorKey,
              defaultTransition:
                  Transition.fade, // Applies to all `Get.to()` calls
              transitionDuration: const Duration(milliseconds: 300),
              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus
                            ?.unfocus(); // Removes focus
                      },
                      child: child!),
                );
              },
              title: '',
              debugShowCheckedModeBanner: false,
              initialBinding: InitialBindings(),
              getPages: AppPages.pages,
              initialRoute: Routes.INITIAL,
              translations: AppLocalization(),
              locale: Get.deviceLocale, //for setting localization strings
              fallbackLocale: const Locale('en', 'US'),
            )),
      );
    });
  }

  /// New code added
}
