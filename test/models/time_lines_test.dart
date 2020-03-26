import 'package:corona_tracker/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Models TimeLines test", () {
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

      expect(timeLines.toJson(), {
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

      var json = {
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
      };
      expect(TimeLines.fromJson(json).toJson(), timeLines.toJson());
    });
  });
}
