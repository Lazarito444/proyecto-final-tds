import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<bool> getFirstTimeRunningPreference() async {
    final SharedPreferences prefs = await _prefs;
    final bool? firstRun = prefs.getBool("firstRun");

    if (firstRun == null) {
      await prefs.setBool("firstRun", true);
      return true;
    }

    if (firstRun) {
      await prefs.setBool("firstRun", false);
      return false;
    }

    return false;
  }

  static Future<void> setBoolPreference(String key, bool value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(key, value);
  }

  static Future<bool?> getBoolPreference(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(key);
  }

  static Future<void> setStringPreference(String key, String value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(key, value);
  }

  static Future<String?> getStringPreference(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(key);
  }

  static Future<void> setIntPreference(String key, int value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt(key, value);
  }

  static Future<int?> getIntPreference(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(key);
  }

  static Future<void> setDoublePreference(String key, double value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setDouble(key, value);
  }

  static Future<double?> getDoublePreference(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getDouble(key);
  }

  static Future<void> setStringListPreference(
    String key,
    List<String> value,
  ) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setStringList(key, value);
  }

  static Future<List<String>?> getStringListPreference(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getStringList(key);
  }

  static Future<void> removePreference(String key) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(key);
  }
}
