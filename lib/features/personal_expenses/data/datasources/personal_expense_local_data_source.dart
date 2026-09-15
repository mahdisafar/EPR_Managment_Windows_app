import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/database/table_constants.dart';
import '../models/personal_expense_model.dart';

abstract class PersonalExpenseLocalDataSource {
  Future<void> insertExpense(PersonalExpenseModel expense);
  Future<List<PersonalExpenseModel>> getAllExpenses();
}

@LazySingleton(as: PersonalExpenseLocalDataSource)
class PersonalExpenseLocalDataSourceImpl
    implements PersonalExpenseLocalDataSource {
  final DatabaseHelper dbHelper;

  PersonalExpenseLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<void> insertExpense(PersonalExpenseModel expense) async {
    final db = await dbHelper.database;
    await db.insert(
      TableConstants.personalExpensesTable,
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<PersonalExpenseModel>> getAllExpenses() async {
    final db = await dbHelper.database;
    final result = await db.query(
      TableConstants.personalExpensesTable,
      orderBy: '${TableConstants.columnDate} DESC',
    );
    return result.map((map) => PersonalExpenseModel.fromMap(map)).toList();
  }
}
