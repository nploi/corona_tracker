import 'package:corona_tracker/models/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Models settings test", () {
    test("toJson method", () {
      Settings settings = Settings(languageCode: "vi");
      expect(settings.toJson(), {
        'language_code': 'vi',
        'theme_mode': Settings.themeSystem,
      });
    });

    test("fromJson method", () {
      Settings settings = Settings(languageCode: "vi");
      var json = {
        'language_code': 'vi',
      };
      expect(Settings.fromJson(json).toJson(), settings.toJson());
    });

    test("default values", () {
      Settings settings = Settings();
      expect(true, settings.isThemeSystem());
      expect(true, settings.isLanguageSystem());
    });
  });
}
