import 'package:shared_preferences/shared_preferences.dart';

///数据存储工具类
class SpUtil {
  static putStr(String key, String value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.setString(key, value);
  }

  static Future<String?> getStr(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return Future.value(sp.getString(key));
  }

  static putInt(String key, int value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return Future.value(sp.getInt(key));
  }

  static putStrList(String key, List<String> value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setStringList(key, value);
  }

  static Future<List<String>?> getStrList(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return Future.value(sp.getStringList(key));
  }

  static putBool(String key, bool value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return Future.value(sp.getBool(key));
  }
}
