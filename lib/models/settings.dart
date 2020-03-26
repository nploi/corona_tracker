class Settings {
  static const int THEME_SYSTEM = 0;
  static const String LANGUAGE_SYSTEM = "system";

  int themeMode;
  String languageCode;

  Settings({
    this.themeMode = THEME_SYSTEM,
    this.languageCode = LANGUAGE_SYSTEM,
  });

  Settings.fromJson(Map<String, dynamic> json) {
    themeMode = json['theme_mode'] ?? THEME_SYSTEM;
    languageCode = json['language_code'] ?? LANGUAGE_SYSTEM;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['theme_mode'] = themeMode ?? THEME_SYSTEM;
    data['language_code'] = languageCode ?? LANGUAGE_SYSTEM;
    return data;
  }

  bool isThemeSystem() {
    return themeMode == THEME_SYSTEM;
  }

  bool isLanguageSystem() {
    return languageCode == LANGUAGE_SYSTEM;
  }
}
