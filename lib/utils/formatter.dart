import 'package:intl/intl.dart';

class FormatterUtils {
  static String formatDateFromString(String date) {
    final dateFormat = DateFormat('yyyy-MM-dd hh:mm');
    return dateFormat.format(DateTime.parse(date));
  }
}
