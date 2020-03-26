import 'latest.dart';
import 'location.dart';

class LocationsResponse {
  Latest latest;
  List<Location> locations;

  LocationsResponse({this.latest, this.locations});

  LocationsResponse.fromJson(Map<String, dynamic> json) {
    latest =
        json['latest'] != null ? new Latest.fromJson(json['latest']) : null;
    if (json['locations'] != null) {
      locations = new List<Location>();
      json['locations'].forEach((v) {
        locations.add(new Location.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.latest != null) {
      data['latest'] = this.latest.toJson();
    }
    if (this.locations != null) {
      data['locations'] = this.locations.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
