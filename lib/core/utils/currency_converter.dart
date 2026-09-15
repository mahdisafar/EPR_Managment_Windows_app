import 'package:eprwindowsapp/config/enum.dart';

class CurrencyConverter {
  static double totoman({
    required double amount,
    required CurrencyType currency,
    required double exchangeRate,
  }) {
    if (currency == CurrencyType.toman) return amount;
    return amount * exchangeRate;
  }

  static String label(CurrencyType c) {
    switch (c) {
      case CurrencyType.toman:
        return 'تومان';
      case CurrencyType.usd:
        return 'دلار';
      case CurrencyType.eur:
        return 'یورو';
      case CurrencyType.pkr:
        return 'لیر';
      case CurrencyType.irr:
        return 'ریال';
    }
  }

  static String shortLabel(CurrencyType c) {
    switch (c) {
      case CurrencyType.toman:
        return 'تومان';
      case CurrencyType.usd:
        return 'USD';
      case CurrencyType.eur:
        return 'EUR';
      case CurrencyType.pkr:
        return 'TRY';
      case CurrencyType.irr:
        return 'ریال';
    }
  }
}
