import 'package:corona_tracker/utils/formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("FormatterUtils", () {
    test("formatDateFromString", () {
      var input = "2020-04-11T16:29:26.236998Z";
      expect(FormatterUtils.formatDateFromString(input), "2020-04-11 04:29");
    });
  });
}
