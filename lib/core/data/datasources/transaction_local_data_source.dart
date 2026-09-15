import 'package:sqflite/sqflite.dart';
import 'package:injectable/injectable.dart';
import '../../database/database_helper.dart';
import '../../database/table_constants.dart';
import '../../models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<void> insertTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getAllTransactions();
  Future<List<TransactionModel>> getTransactionsByDateRange(
      DateTime startDate, DateTime endDate);
  Future<List<TransactionModel>> getTransactionsByReference(
      String referenceType, String referenceId);
  Future<List<TransactionModel>> getTransactionsByCustomerId(String customerId);
  Future<Map<String, double>> getFinancialSummary(
      {DateTime? startDate, DateTime? endDate});
  Future<void> deleteTransaction(String id);
}

@LazySingleton(as: TransactionLocalDataSource)
class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final DatabaseHelper dbHelper;

  TransactionLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<void> insertTransaction(TransactionModel transaction) async {
    final db = await dbHelper.database;
    await db.insert(
      TableConstants.transactionsTable,
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await dbHelper.database;
    final result = await db.query(
      TableConstants.transactionsTable,
      orderBy: '${TableConstants.columnDate} DESC',
    );
    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }

  @override
  Future<List<TransactionModel>> getTransactionsByDateRange(
      DateTime startDate, DateTime endDate) async {
    final db = await dbHelper.database;
    final result = await db.query(
      TableConstants.transactionsTable,
      where: '${TableConstants.columnDate} BETWEEN ? AND ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: '${TableConstants.columnDate} DESC',
    );
    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }

  @override
  Future<List<TransactionModel>> getTransactionsByReference(
      String referenceType, String referenceId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      TableConstants.transactionsTable,
      where:
          '${TableConstants.colReferenceType} = ? AND ${TableConstants.colReferenceId} = ?',
      whereArgs: [referenceType, referenceId],
      orderBy: '${TableConstants.columnDate} DESC',
    );
    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }

  @override
  Future<Map<String, double>> getFinancialSummary(
      {DateTime? startDate, DateTime? endDate}) async {
    final db = await dbHelper.database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (startDate != null && endDate != null) {
      whereClause = 'WHERE ${TableConstants.columnDate} BETWEEN ? AND ?';
      whereArgs = [startDate.toIso8601String(), endDate.toIso8601String()];
    }

    final incomeResult = await db.rawQuery(
      'SELECT SUM(${TableConstants.columnAmount}) as total FROM ${TableConstants.transactionsTable} $whereClause ${whereClause.isEmpty ? 'WHERE' : 'AND'} ${TableConstants.columnType} = \'income\'',
      whereArgs,
    );

    final expenseResult = await db.rawQuery(
      'SELECT SUM(${TableConstants.columnAmount}) as total FROM ${TableConstants.transactionsTable} $whereClause ${whereClause.isEmpty ? 'WHERE' : 'AND'} ${TableConstants.columnType} = \'expense\'',
      whereArgs,
    );

    final totalIncome =
        (incomeResult.first['total'] as num?)?.toDouble() ?? 0.0;
    final totalExpense =
        (expenseResult.first['total'] as num?)?.toDouble() ?? 0.0;

    return {
      'total_income': totalIncome,
      'total_expense': totalExpense,
      'net_profit': totalIncome - totalExpense,
    };
  }

  @override
  Future<List<TransactionModel>> getTransactionsByCustomerId(
      String customerId) async {
    return await getTransactionsByReference('customer', customerId);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final db = await dbHelper.database;
    await db.delete(
      TableConstants.transactionsTable,
      where: '${TableConstants.columnId} = ?',
      whereArgs: [id],
    );
  }
}
