import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefServices {
  static SharedPreferences? prefs;
  static Future<void> clearUserFromSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();

    await prefs!.setString(_keyuserId, '');
    await prefs?.clear();
  }

  static const _keyuserId = 'userId';
  static Future init() async => prefs = await SharedPreferences.getInstance();
  static Future setuserId(String userId) async =>
      await prefs!.setString(_keyuserId, userId);

  static String? getuserId() => prefs!.getString(_keyuserId);
}
