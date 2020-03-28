import 'package:corona_tracker/models/time_lines.dart';

import 'coordinates.dart';
import 'latest.dart';

class Location {
  int id;
  String country;
  String countryCode;
  int countryPopulation;
  String province;
  String county;
  String lastUpdated;
  Coordinates coordinates;
  Latest latest;
  TimeLines timeLines;

  Location(
      {this.id,
      this.country,
      this.countryCode,
      this.countryPopulation,
      this.province,
      this.county,
      this.lastUpdated,
      this.coordinates,
      this.latest,
      this.timeLines});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    country = json['country'];
    countryCode = json['country_code'];
    countryPopulation = json['country_population'];
    province = json['province'];
    county = json['county'];
    lastUpdated = json['last_updated'];
    coordinates = json['coordinates'] != null
        ? Coordinates.fromJson(json['coordinates'])
        : null;
    latest = json['latest'] != null ? Latest.fromJson(json['latest']) : null;
    timeLines = json['timelines'] != null
        ? TimeLines.fromJson(json['timelines'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['country'] = country;
    data['country_code'] = countryCode;
    data['country_population'] = countryPopulation;
    data['province'] = province;
    data['county'] = county;
    data['last_updated'] = lastUpdated;
    if (coordinates != null) {
      data['coordinates'] = coordinates.toJson();
    }
    if (latest != null) {
      data['latest'] = latest.toJson();
    }
    if (timeLines != null) {
      data['timelines'] = timeLines.toJson();
    }
    return data;
  }
}
