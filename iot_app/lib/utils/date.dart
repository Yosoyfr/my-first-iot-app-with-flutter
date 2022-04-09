import 'package:intl/intl.dart';

class Date {
  static String getFormattedDate(DateTime date) {
    var outputFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    var outputDate = outputFormat.format(date);

    return outputDate.toString();
  }

  static String getHomeScreenDate() {
    var outputFormat = DateFormat("dd MMMM");
    var outputDate = outputFormat.format(DateTime.now());

    return outputDate.toString();
  }
}
