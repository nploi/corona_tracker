import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corona_tracker/corona_tracker_app.dart';

import 'blocs/blocs.dart';
import 'services/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = AppBlocDelegate(debug: true);
  await setupLocator();

  runApp(
    DevicePreview(
      builder: (context) => CoronaTrackerApp(),
    ),
  );
}
