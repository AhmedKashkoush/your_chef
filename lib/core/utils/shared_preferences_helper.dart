import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static late final SharedPreferences _prefs;
  const SharedPreferencesHelper._();
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> set<T>(String key, T value) async {
    switch (value.runtimeType) {
      case const (String):
        await _prefs.setString(key, value as String);
        return;
      case const (int):
        await _prefs.setInt(key, value as int);
        return;
      case const (double):
        await _prefs.setDouble(key, value as double);
        return;
      case const (bool):
        await _prefs.setBool(key, value as bool);
        return;
      case const (List):
        await _prefs.setStringList(key, value as List<String>);
        return;
    }
  }

  static T? get<T>(String key) => _prefs.get(key) as T?;

  static Future<void> remove(String key) async => _prefs.remove(key);

  static Future<void> clear() async => _prefs.clear();
}
