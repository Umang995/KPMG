//ignore: unused_import
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static SharedPreferences? _sharedPreferences;

  /// Call this ONCE before using any getters/setters
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    print('SharedPreferences Initialized');
  }

  static SharedPreferences get prefs {
    assert(_sharedPreferences != null, 'Call PrefUtils.init() before use!');
    return _sharedPreferences!;
  }

  static Future<void> clearPreferencesData() async {
    var timezone = getTimezone();
    await prefs.clear();
    saveTimezone(timezone);
  }

  //used for login
  static Future<void> setToken(String value) => prefs.setString('token', value);

  static String getToken() => prefs.getString('token') ?? "";

  //used for guest login id
  static Future<void> setGuestLoginId(String value) =>
      prefs.setString('guest_id', value);

  static String getGuestLoginId() => prefs.getString('guest_id') ?? "";

  //used for AI features enabled and disable
  static Future<void> setAiFeature(bool value) =>
      prefs.setBool('ai_feature', value);

  static bool getAiFeatures() => prefs.getBool('ai_feature') ?? true;

  //used for guest login
  static Future<void> setGuestLogin(bool value) =>
      prefs.setBool('guest_login', value);

  static bool getGuestLogin() => prefs.getBool('guest_login') ?? false;

  static Future<void> setThemeMode(bool isDarkMode) =>
      prefs.setBool('isDarkMode', isDarkMode);

  static bool getThemeMode() => prefs.getBool('isDarkMode') ?? false;

  static Future<void> saveDocumentPath(String key, String value) =>
      prefs.setString(key, value);

  static String getDocumentPath(String key) => prefs.getString(key) ?? "";

  // Generic methods
  static Future<void> _writeString(String key, String? value) async {
    if (value == null) return;
    await prefs.setString(key, value);
  }

  static Future<void> _writeBool(String key, bool value) async {
    await prefs.setBool(key, value);
  }

  static Future<void> _writeInt(String key, int value) async {
    await prefs.setInt(key, value);
  }

  static String? _getString(String key) => prefs.getString(key);
  static bool? _getBool(String key) => prefs.getBool(key);
  static int? _getInt(String key) => prefs.getInt(key);

  // Tokens
  static Future<void> saveFcmToken(String? token) =>
      _writeString("fcm_token", token);
  static String? getFcmToken() => _getString("fcm_token");

  static Future<void> saveAuthToken(String? token) =>
      _writeString("auth_token", token);
  static String? getAuthToken() => _getString("auth_token");

  // Feed Email
  static Future<void> saveFeedEmail(String? email) =>
      _writeString("feed_email", email);
  static String? getFeedEmail() => _getString("feed_email");

  // Profile Data
  static Future<void> saveProfileData({
    required String fullName,
    required String username,
    required String profile,
    required String role,
    required String userId,
    required String chatId,
    required String email,
    required String category,
  }) async {
    await Future.wait([
      _writeString("name", fullName),
      _writeString("username", username),
      _writeString("profile", profile),
      _writeString("role", role),
      _writeString("user_id", userId),
      _writeString("chat_id", chatId),
      _writeString("email", email),
      _writeString("category", category),
    ]);
  }

  static String getName() => _getString("name") ?? "Guest";
  static String? getUsername() => _getString("username");
  static String? getProfileImage() => _getString("profile") ?? "";
  static String? getRole() => _getString("role") ?? "user";
  static String? getUserId() => _getString("user_id");
  static String? getEmail() => _getString("email");
  static String? getChatId() => _getString("chat_id");
  static String? getCategory() => _getString("category");

  static Future<void> saveProfileImage(String? profile) =>
      _writeString("profile", profile);

  static String? getImage() => _getString("profile");

  // Privacy Settings
  static Future<void> savePrivacyData({
    required bool isChat,
    required bool isMeeting,
    required bool isProfile,
  }) async {
    await Future.wait([
      _writeBool("is_chat", isChat),
      _writeBool("is_meeting", isMeeting),
      _writeBool("is_profile", isProfile),
    ]);
  }

  static bool? isChat() => _getBool("is_chat");
  static bool? isMeeting() => _getBool("is_meeting");

  // Linked URL
  static Future<void> saveLinkedUrl(String? url) =>
      _writeString("linked_url", url);
  static String? getLinkedUrl() => _getString("linked_url");

  // Timezone
  static Future<void> saveTimezone(String? timezone) =>
      _writeString("timezone", timezone);
  static String getTimezone() => _getString("timezone") ?? "";

  // Exhibitor Type
  static Future<void> saveExhibitorType(String? type) =>
      _writeString("exhibitor_type", type);
  static String? getExhibitorType() => _getString("exhibitor_type");

  // Profile update
  static Future<void> setProfileUpdate(int isProfile) =>
      _writeInt("is_profile_update", isProfile);
  static int? getProfileUpdate() => _getInt("is_profile_update");
}
