import 'package:corona_tracker/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Models Latest test", () {
    test("toJson method", () {
      var latest = Latest(
        confirmed: 0,
        deaths: 0,
        recovered: 0,
      );
      expect(latest.toJson(), {
        "confirmed": 0,
        "deaths": 0,
        "recovered": 0,
      });
    });

    test("fromJson method", () {
      var latest = Latest(
        confirmed: 0,
        deaths: 0,
        recovered: 0,
      );
      var json = {
        "confirmed": 0,
        "deaths": 0,
        "recovered": 0,
      };
      expect(Latest.fromJson(json).toJson(), latest.toJson());
    });
  });
}
