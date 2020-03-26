import 'package:corona_tracker/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Models TimeLine test", () {
    test("toJson method", () {
      var timeLine = TimeLine(latest: 0, timeline: {
        "2020-01-22T00:00:00Z": 0,
        "2020-01-23T00:00:00Z": 0,
        "2020-01-24T00:00:00Z": 0,
      });
      expect(timeLine.toJson(), {
        "latest": 0,
        "timeline": {
          "2020-01-22T00:00:00Z": 0,
          "2020-01-23T00:00:00Z": 0,
          "2020-01-24T00:00:00Z": 0,
        }
      });
    });

    test("fromJson method", () {
      var timeLine = TimeLine(latest: 0, timeline: {
        "2020-01-22T00:00:00Z": 0,
        "2020-01-23T00:00:00Z": 0,
        "2020-01-24T00:00:00Z": 0,
      });
      var json = {
        "latest": 0,
        "timeline": {
          "2020-01-22T00:00:00Z": 0,
          "2020-01-23T00:00:00Z": 0,
          "2020-01-24T00:00:00Z": 0,
        }
      };
      expect(TimeLine.fromJson(json).toJson(), timeLine.toJson());
    });
  });
}
