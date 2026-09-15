import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import '../../config/enum.dart';
import '../database/database_helper.dart';
import '../database/table_constants.dart';

@lazySingleton
class ExchangeRateService {
  final DatabaseHelper dbHelper;

  ExchangeRateService({required this.dbHelper});

  static const String _prefix = 'rate_';

  static double defaultRate(CurrencyType c) {
    switch (c) {
      case CurrencyType.toman:
        return 1.0;
      case CurrencyType.usd:
        return 95000;
      case CurrencyType.eur:
        return 103000;
      case CurrencyType.pkr:
        return 290;
      case CurrencyType.irr:
        return 0.1;
    }
  }

  Future<double> getRate(CurrencyType currency) async {
    if (currency == CurrencyType.toman) return 1.0;
    final db = await dbHelper.database;
    final res = await db.query(
      TableConstants.appSettingsTable,
      where: '${TableConstants.colSettingKey} = ?',
      whereArgs: ['$_prefix${currency.name}'],
    );
    if (res.isEmpty) return defaultRate(currency);
    return double.tryParse(
            (res.first[TableConstants.colSettingValue] ?? '') as String) ??
        defaultRate(currency);
  }

  Future<void> setRate(CurrencyType currency, double rate) async {
    final db = await dbHelper.database;
    await db.insert(
      TableConstants.appSettingsTable,
      {
        TableConstants.colSettingKey: '$_prefix${currency.name}',
        TableConstants.colSettingValue: rate.toString(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<CurrencyType, double>> getAllRates() async {
    final result = <CurrencyType, double>{};
    for (final c in CurrencyType.values) {
      result[c] = await getRate(c);
    }
    return result;
  }
}
