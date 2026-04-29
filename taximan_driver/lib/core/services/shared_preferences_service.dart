import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService._();

  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setBool(String key, bool value) async {
    return _preferences?.setBool(key, value) ?? false;
  }

  static bool? getBool(String key) {
    return _preferences?.getBool(key);
  }

  static Future<bool> setString(String key, String value) async {
    return _preferences?.setString(key, value) ?? false;
  }

  static String? getString(String key) {
    return _preferences?.getString(key);
  }
}
