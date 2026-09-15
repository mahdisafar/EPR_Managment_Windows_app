import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';
import 'package:injectable/injectable.dart';
import '../../database/database_helper.dart';
import '../../database/table_constants.dart';
import '../../error/failures.dart';
import '../../domain/repositories/account_repository.dart';
import '../../models/account_model.dart';

@LazySingleton(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  final DatabaseHelper databaseHelper;

  AccountRepositoryImpl({DatabaseHelper? dbHelper})
      : databaseHelper = dbHelper ?? DatabaseHelper.instance;

  @override
  Future<Either<Failure, Unit>> addAccount(AccountModel account) async {
    try {
      final db = await databaseHelper.database;
      await db.insert(
        TableConstants.accountsTable,
        account.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure('خطا در ثبت حساب: $e'));
    }
  }

  @override
  Future<Either<Failure, AccountModel?>> getAccountById(String id) async {
    try {
      final db = await databaseHelper.database;
      final maps = await db.query(
        TableConstants.accountsTable,
        where: '${TableConstants.columnId} = ?',
        whereArgs: [id],
      );
      if (maps.isEmpty) return const Right(null);
      return Right(AccountModel.fromMap(maps.first));
    } catch (e) {
      return Left(DatabaseFailure('خطا در یافتن حساب: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AccountModel>>> getAllAccounts() async {
    try {
      final db = await databaseHelper.database;
      final maps = await db.query(TableConstants.accountsTable);
      return Right(maps.map((map) => AccountModel.fromMap(map)).toList());
    } catch (e) {
      return Left(DatabaseFailure('خطا در دریافت لیست حساب‌ها: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateAccountBalance(
      String accountId, double newBalance) async {
    try {
      final db = await databaseHelper.database;
      await db.update(
        TableConstants.accountsTable,
        {TableConstants.colBalance: newBalance},
        where: '${TableConstants.columnId} = ?',
        whereArgs: [accountId],
      );
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure('خطا در به‌روزرسانی بیلانس حساب: $e'));
    }
  }
}
