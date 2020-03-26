import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'services/locator.dart';
import 'services/services.dart';
import 'utils/utils.dart';

class CoronaTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: locator<NavigationService>().navigatorKey,
      debugShowCheckedModeBanner: false,
      darkTheme: Themes.getTheme(ThemeMode.dark),
      theme: Themes.getTheme(ThemeMode.light),
      builder: DevicePreview.appBuilder,
      home: Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text("Hello World!")
        ),
      ),
    );
  }
}