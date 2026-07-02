import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final aDate = DateTime(date.year, date.month, date.day);

    if (aDate == today) {
      return 'Bugün';
    } else if (aDate == yesterday) {
      return 'Dün';
    } else {
      // For any other day, display standard short date e.g., 2 Eki 2023
      return DateFormat('d MMM yyyy', 'tr_TR').format(date);
    }
  }
}
