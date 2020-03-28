import 'dart:convert';

import 'package:corona_tracker/models/settings.dart';
import 'package:corona_tracker/services/locator.dart';
import 'package:corona_tracker/services/services.dart';

class SettingsRepository {
  const SettingsRepository();

  Future<bool> updateSettings(Settings settings) async {
    return locator<StorageDeviceService>()
        .set(StorageDeviceService.settingsKey, jsonEncode(settings.toJson()));
  }

  Settings getSettings() {
    var settingInfo =
        locator<StorageDeviceService>().get(StorageDeviceService.settingsKey);
    if (settingInfo == null) {
      return Settings();
    }
    return Settings.fromJson(jsonDecode(settingInfo));
  }
}
