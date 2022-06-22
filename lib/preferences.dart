import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static Future<void> setPath(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> getPath(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return prefs.getString(key)!;
    } else {
      return '';
    }
  }
}
