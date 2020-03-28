class Settings {
  static const int themeSystem = 1;
  static const String languageSystem = "system";

  int themeMode;
  String languageCode;

  Settings({
    this.themeMode = themeSystem,
    this.languageCode = languageSystem,
  });

  Settings.fromJson(Map<String, dynamic> json) {
    themeMode = json['theme_mode'] ?? themeSystem;
    languageCode = json['language_code'] ?? languageSystem;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['theme_mode'] = themeMode ?? themeSystem;
    data['language_code'] = languageCode ?? languageSystem;
    return data;
  }

  bool isThemeSystem() {
    return themeMode == themeSystem;
  }

  bool isLanguageSystem() {
    return languageCode == languageSystem;
  }

  bool isDarkMode() {
    return themeMode == 2;
  }
}
