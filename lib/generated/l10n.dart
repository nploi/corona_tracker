// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

class S {
  S(this.localeName);
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final String name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return S(localeName);
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  final String localeName;

  String get appName {
    return Intl.message(
      'Corona Tracker',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  String get confirmedTitle {
    return Intl.message(
      'Confirmed',
      name: 'confirmedTitle',
      desc: '',
      args: [],
    );
  }

  String get deathsTitle {
    return Intl.message(
      'Deaths',
      name: 'deathsTitle',
      desc: '',
      args: [],
    );
  }

  String get recoveredTitle {
    return Intl.message(
      'Recovered',
      name: 'recoveredTitle',
      desc: '',
      args: [],
    );
  }

  String get onlineStatus {
    return Intl.message(
      'Online',
      name: 'onlineStatus',
      desc: '',
      args: [],
    );
  }

  String get offlineStatus {
    return Intl.message(
      'Offline',
      name: 'offlineStatus',
      desc: '',
      args: [],
    );
  }

  String get worldwide {
    return Intl.message(
      'Worldwide',
      name: 'worldwide',
      desc: '',
      args: [],
    );
  }

  String get themeTitle {
    return Intl.message(
      'Theme',
      name: 'themeTitle',
      desc: '',
      args: [],
    );
  }

  String get dartModeTitle {
    return Intl.message(
      'Dark mode',
      name: 'dartModeTitle',
      desc: '',
      args: [],
    );
  }

  String get languageTitle {
    return Intl.message(
      'Language',
      name: 'languageTitle',
      desc: '',
      args: [],
    );
  }

  String get filterWithTitle {
    return Intl.message(
      'Filter with',
      name: 'filterWithTitle',
      desc: '',
      args: [],
    );
  }

  String get activeTitle {
    return Intl.message(
      'active',
      name: 'activeTitle',
      desc: '',
      args: [],
    );
  }

  String get backAgainToLeaveMessage {
    return Intl.message(
      'Tap back again to leave',
      name: 'backAgainToLeaveMessage',
      desc: '',
      args: [],
    );
  }

  String get topAffectedCountries {
    return Intl.message(
      'Top affected countries',
      name: 'topAffectedCountries',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'), Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}