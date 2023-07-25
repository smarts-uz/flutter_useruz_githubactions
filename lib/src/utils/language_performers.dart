import 'package:shared_preferences/shared_preferences.dart';

class LanguagePerformers {
  static const String _key = 'language';
  static SharedPreferences? preferences;

  static init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static void saveLanguage(String lan) {
    preferences!.setString(_key, lan);
  }

  static String getLanguage() {
    String theme = preferences!.getString(_key) ?? "ru";
    return theme;
  }

  static int getRoleId() {
    int id = preferences!.getInt("roleId") ?? 0;
    return id;
  }

  static int getUserId() {
    int id = preferences!.getInt("id") ?? 0;
    return id;
  }
}
