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
        ? new Coordinates.fromJson(json['coordinates'])
        : null;
    latest =
        json['latest'] != null ? new Latest.fromJson(json['latest']) : null;
    timeLines = json['timelines'] != null
        ? new TimeLines.fromJson(json['timelines'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country'] = this.country;
    data['country_code'] = this.countryCode;
    data['country_population'] = this.countryPopulation;
    data['province'] = this.province;
    data['county'] = this.county;
    data['last_updated'] = this.lastUpdated;
    if (this.coordinates != null) {
      data['coordinates'] = this.coordinates.toJson();
    }
    if (this.latest != null) {
      data['latest'] = this.latest.toJson();
    }
    if (this.timeLines != null) {
      data['timelines'] = this.timeLines.toJson();
    }
    return data;
  }
}
