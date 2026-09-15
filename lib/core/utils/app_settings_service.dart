import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../database/table_constants.dart';

@lazySingleton
class AppSettingsService {
  final DatabaseHelper dbHelper;

  AppSettingsService({required this.dbHelper});

  static const String keyCompanyName = 'company_name';
  static const String keyCompanyPhone = 'company_phone';
  static const String keyCompanyAddress = 'company_address';

  Future<String?> get(String key) async {
    final db = await dbHelper.database;
    final res = await db.query(
      TableConstants.appSettingsTable,
      where: '${TableConstants.colSettingKey} = ?',
      whereArgs: [key],
    );
    if (res.isEmpty) return null;
    return res.first[TableConstants.colSettingValue] as String?;
  }

  Future<void> set(String key, String value) async {
    final db = await dbHelper.database;
    await db.insert(
      TableConstants.appSettingsTable,
      {
        TableConstants.colSettingKey: key,
        TableConstants.colSettingValue: value,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
