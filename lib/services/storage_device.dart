import 'package:shared_preferences/shared_preferences.dart';

class StorageDeviceService {
  static const String settingsKey = "settings";

  SharedPreferences _preferences;

  Future<void> boot() async {
    _preferences = await SharedPreferences.getInstance();
  }

  String get(String key) {
    return _preferences.get(key);
  }

  Future<bool> set(String key, String value) async {
    return _preferences.setString(key, value);
  }
}
