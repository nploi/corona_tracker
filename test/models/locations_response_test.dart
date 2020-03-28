import 'package:corona_tracker/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Models LocationsResponse test", () {
    test("toJson method", () {
      var timeLine = TimeLine(latest: 0, timeline: {
        "2020-01-22T00:00:00Z": 0,
        "2020-01-23T00:00:00Z": 0,
        "2020-01-24T00:00:00Z": 0,
      });

      var timeLines = TimeLines(
        recovered: timeLine,
        deaths: timeLine,
        confirmed: timeLine,
      );

      var location = Location(
          id: 0,
          country: "",
          countryCode: "",
          countryPopulation: 0,
          county: "",
          lastUpdated: "",
          province: "",
          latest: Latest(
            confirmed: 0,
            deaths: 0,
            recovered: 0,
          ),
          coordinates: Coordinates(
            longitude: "10",
            latitude: "10",
          ),
          timeLines: timeLines);

      var locationsResponse = LocationsResponse(
        latest: Latest(
          recovered: 0,
          deaths: 0,
          confirmed: 0,
        ),
        locations: [location],
      );

      expect(locationsResponse.toJson(), {
        "latest": {
          "recovered": 0,
          "deaths": 0,
          "confirmed": 0,
        },
        "locations": [
          {
            "id": 0,
            "country": "",
            "country_code": "",
            "country_population": 0,
            "county": "",
            "last_updated": "",
            "province": "",
            "latest": {
              "confirmed": 0,
              "deaths": 0,
              "recovered": 0,
            },
            "coordinates": {
              "longitude": "10",
              "latitude": "10",
            },
            "timelines": {
              "recovered": {
                "latest": 0,
                "timeline": {
                  "2020-01-22T00:00:00Z": 0,
                  "2020-01-23T00:00:00Z": 0,
                  "2020-01-24T00:00:00Z": 0,
                }
              },
              "deaths": {
                "latest": 0,
                "timeline": {
                  "2020-01-22T00:00:00Z": 0,
                  "2020-01-23T00:00:00Z": 0,
                  "2020-01-24T00:00:00Z": 0,
                }
              },
              "confirmed": {
                "latest": 0,
                "timeline": {
                  "2020-01-22T00:00:00Z": 0,
                  "2020-01-23T00:00:00Z": 0,
                  "2020-01-24T00:00:00Z": 0,
                }
              },
            }
          }
        ]
      });
    });

    test("fromJson method", () {
      var timeLine = TimeLine(latest: 0, timeline: {
        "2020-01-22T00:00:00Z": 0,
        "2020-01-23T00:00:00Z": 0,
        "2020-01-24T00:00:00Z": 0,
      });

      var timeLines = TimeLines(
        recovered: timeLine,
        deaths: timeLine,
        confirmed: timeLine,
      );

      var location = Location(
        id: 0,
        country: "",
        countryCode: "",
        countryPopulation: 0,
        county: "",
        lastUpdated: "",
        province: "",
        latest: Latest(
          confirmed: 0,
          deaths: 0,
          recovered: 0,
        ),
        coordinates: Coordinates(
          longitude: "10",
          latitude: "10",
        ),
        timeLines: timeLines,
      );

      var locationsResponse = LocationsResponse(
        latest: Latest(
          recovered: 0,
          deaths: 0,
          confirmed: 0,
        ),
        locations: [location],
      );

      var json = {
        "latest": {
          "recovered": 0,
          "deaths": 0,
          "confirmed": 0,
        },
        "locations": [
          {
            "id": 0,
            "country": "",
            "country_code": "",
            "country_population": 0,
            "county": "",
            "last_updated": "",
            "province": "",
            "latest": {
              "confirmed": 0,
              "deaths": 0,
              "recovered": 0,
            },
            "coordinates": {
              "longitude": "10",
              "latitude": "10",
            },
            "timelines": {
              "recovered": {
                "latest": 0,
                "timeline": {
                  "2020-01-22T00:00:00Z": 0,
                  "2020-01-23T00:00:00Z": 0,
                  "2020-01-24T00:00:00Z": 0,
                }
              },
              "deaths": {
                "latest": 0,
                "timeline": {
                  "2020-01-22T00:00:00Z": 0,
                  "2020-01-23T00:00:00Z": 0,
                  "2020-01-24T00:00:00Z": 0,
                }
              },
              "confirmed": {
                "latest": 0,
                "timeline": {
                  "2020-01-22T00:00:00Z": 0,
                  "2020-01-23T00:00:00Z": 0,
                  "2020-01-24T00:00:00Z": 0,
                }
              },
            }
          }
        ]
      };

      expect(LocationsResponse.fromJson(json).toJson(),
          locationsResponse.toJson());
    });
  });
}
