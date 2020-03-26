import 'package:corona_tracker/services/services.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<StorageDeviceService>(
      () => StorageDeviceService());
  await locator<StorageDeviceService>().boot();
}
