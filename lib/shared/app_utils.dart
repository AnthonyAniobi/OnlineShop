import 'package:intl/intl.dart';

class AppUtils {
  static String formatCurrency(
    double amount, {
    bool showSymbol = true,
    int decimalDigits = 2,
  }) {
    return NumberFormat.currency(
      decimalDigits: decimalDigits,
      locale: 'en_NG',
      symbol: showSymbol ? '₦ ' : '',
    ).format(amount);
  }
}
