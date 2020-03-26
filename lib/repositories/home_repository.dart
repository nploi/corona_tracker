import 'package:corona_tracker/data/corona_tracker_api.dart';
import 'package:corona_tracker/models/models.dart';

class HomeRepository {
  const HomeRepository();
  final CoronaTrackerApi coronaTrackerApi = const CoronaTrackerApi();

  Future<LocationsResponse> getLocations() async {
    return coronaTrackerApi.getLocations();
  }

  Future<Location> getLocation({int id}) async {
    return coronaTrackerApi.getLocation(id: id);
  }
}
