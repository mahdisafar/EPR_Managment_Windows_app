import 'package:intl/intl.dart' as intl;
import 'package:shamsi_date/shamsi_date.dart';

class AppDate {
  static String _two(int n) => n.toString().padLeft(2, '0');

  static String format(DateTime date) {
    final j = Jalali.fromDateTime(date);
    return _toFa('${_two(j.year)}/${_two(j.month)}/${_two(j.day)}');
  }

  static String formatDateTime(DateTime date) {
    return '${format(date)} · ${intl.DateFormat('HH:mm').format(date)}';
  }

  static String today() {
    final j = Jalali.now();
    return '${_two(j.year)}/${_two(j.month)}/${_two(j.day)}';
  }

  static DateTime? parse(String? input) {
    if (input == null || input.trim().isEmpty) return null;
    final m = RegExp(r'^(\d{3,4})[\/\-.](\d{1,2})[\/\-.](\d{1,2})$')
        .firstMatch(input.trim());
    if (m == null) return DateTime.tryParse(input);
    final j = Jalali(
      int.parse(m.group(1)!),
      int.parse(m.group(2)!),
      int.parse(m.group(3)!),
    );
    return j.toDateTime();
  }

  static String _toFa(String s) {
    const en = '0123456789';
    const fa = '۰۱۲۳۴۵۶۷۸۹';
    for (var i = 0; i < 10; i++) {
      s = s.replaceAll(en[i], fa[i]);
    }
    return s;
  }
}
