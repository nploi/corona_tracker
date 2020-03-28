import 'package:corona_tracker/utils/map_styles/dark.dart';
import 'package:corona_tracker/utils/map_styles/light.dart';
import 'package:flutter/material.dart';

String getMapStyle(ThemeMode themeMode) {
  switch (themeMode) {
    case ThemeMode.system:
      return mapStyleLight;
      break;
    case ThemeMode.light:
      return mapStyleLight;
      break;
    case ThemeMode.dark:
      return mapStyleDark;
      break;
  }
  return "";
}
