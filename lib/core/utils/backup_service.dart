import 'dart:io';
import 'package:injectable/injectable.dart';
import '../database/database_helper.dart';

@lazySingleton
class BackupService {
  final DatabaseHelper dbHelper;

  BackupService({required this.dbHelper});

  Future<String> get databasePath async {
    final db = await dbHelper.database;
    return db.path;
  }

  Future<String> backupTo(String targetPath) async {
    final source = File(await databasePath);
    final target = File(targetPath);
    await source.copy(target.path);
    return target.path;
  }

  Future<void> restoreFrom(String sourcePath) async {
    final db = await dbHelper.database;
    await db.close();
    dbHelper.resetReference();

    final targetPath = await databasePath;
    await File(sourcePath).copy(targetPath);
  }
}
