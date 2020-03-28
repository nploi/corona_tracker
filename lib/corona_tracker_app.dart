import 'package:corona_tracker/ui/screens/home.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:page_transition/page_transition.dart';
import 'blocs/blocs.dart';
import 'generated/l10n.dart';
import 'services/locator.dart';
import 'services/services.dart';
import 'utils/utils.dart';

class CoronaTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          var settings = BlocProvider.of<SettingsBloc>(context).settings;

          return MaterialApp(
            navigatorKey: locator<NavigationService>().navigatorKey,
            debugShowCheckedModeBanner: false,
            darkTheme: Themes.getTheme(ThemeMode.dark),
            theme: Themes.getTheme(ThemeMode.light),
            themeMode: ThemeMode.values[settings.themeMode],
            builder: DevicePreview.appBuilder,
            initialRoute: HomeScreen.routeName,
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              const LocaleNamesLocalizationsDelegate()
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: settings.isLanguageSystem()
                ? null
                : Locale(settings.languageCode, ""),
            onGenerateRoute: (routeSettings) {
              Widget screen;
              switch (routeSettings.name) {
                case HomeScreen.routeName:
                  screen = HomeScreen();
                  break;
              }
              return PageTransition(
                type: PageTransitionType.rightToLeft,
                child: screen,
              );
            },
          );
        },
      ),
    );
  }
}
