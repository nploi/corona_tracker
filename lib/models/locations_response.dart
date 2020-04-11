import 'latest.dart';
import 'location.dart';

class LocationsResponse {
  Latest latest;
  List<Location> locations;

  LocationsResponse({this.latest, this.locations});

  LocationsResponse.fromJson(Map<String, dynamic> json) {
    latest = json['latest'] != null ? Latest.fromJson(json['latest']) : null;
    if (json['locations'] != null) {
      locations = <Location>[];
      json['locations'].forEach((location) {
        locations.add(Location.fromJson(location));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (latest != null) {
      data['latest'] = latest.toJson();
    }
    if (locations != null) {
      data['locations'] =
          locations.map((location) => location.toJson()).toList();
    }
    return data;
  }
}
