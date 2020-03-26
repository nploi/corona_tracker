import 'package:corona_tracker/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Models Coordinates test", () {
    test("toJson method", () {
      var coordinates = Coordinates(latitude: "10.0", longitude: "11.0");
      expect(coordinates.toJson(), {"latitude": "10.0", "longitude": "11.0"});
    });

    test("fromJson method", () {
      var coordinates = Coordinates(latitude: "10.0", longitude: "11.0");
      var json = {"latitude": "10.0", "longitude": "11.0"};
      expect(Coordinates.fromJson(json).toJson(), coordinates.toJson());
    });
  });
}
