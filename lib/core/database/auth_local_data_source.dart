import 'package:eprwindowsapp/core/database/database_helper.dart';
import 'package:eprwindowsapp/core/database/table_constants.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

abstract class AuthLocalDataSource {
  Future<String?> getSetting(String key);
  Future<void> setSetting(String key, String value);
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final DatabaseHelper dbHelper;

  AuthLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<String?> getSetting(String key) async {
    final db = await dbHelper.database;
    final result = await db.query(
      TableConstants.appSettingsTable,
      columns: [TableConstants.colSettingValue],
      where: '${TableConstants.colSettingKey} = ?',
      whereArgs: [key],
    );
    if (result.isEmpty) return null;
    return result.first[TableConstants.colSettingValue] as String?;
  }

  @override
  Future<void> setSetting(String key, String value) async {
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
