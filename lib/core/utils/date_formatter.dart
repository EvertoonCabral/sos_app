import 'package:intl/intl.dart';

/// Formatadores de data padronizados para o app.
class DateFormatter {
  static final _dateFmt = DateFormat('dd/MM/yyyy');
  static final _dateTimeFmt = DateFormat('dd/MM/yyyy HH:mm');
  static final _isoFmt = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

  static String formatDate(DateTime date) => _dateFmt.format(date);
  static String formatDateTime(DateTime date) => _dateTimeFmt.format(date);
  static String formatIso(DateTime date) => _isoFmt.format(date);
}
