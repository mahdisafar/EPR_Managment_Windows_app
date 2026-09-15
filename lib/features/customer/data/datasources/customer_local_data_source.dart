import 'package:sqflite/sqflite.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/database/table_constants.dart';
import '../models/customer_model.dart';

abstract class CustomerLocalDataSource {
  Future<void> insertCustomer(CustomerModel customer);
  Future<List<CustomerModel>> getCustomers();
  Future<CustomerModel?> getCustomerById(String id);
  Future<void> updateCustomerBalance(String customerId, double balanceDelta);
}

@LazySingleton(as: CustomerLocalDataSource)
class CustomerLocalDataSourceImpl implements CustomerLocalDataSource {
  final DatabaseHelper dbHelper;

  CustomerLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<void> insertCustomer(CustomerModel customer) async {
    final db = await dbHelper.database;
    await db.insert(
      TableConstants.customersTable,
      customer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<CustomerModel>> getCustomers() async {
    final db = await dbHelper.database;
    final result = await db.query(TableConstants.customersTable);
    return result.map((map) => CustomerModel.fromMap(map)).toList();
  }

  @override
  Future<CustomerModel?> getCustomerById(String id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      TableConstants.customersTable,
      where: '${TableConstants.columnId} = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return CustomerModel.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<void> updateCustomerBalance(
      String customerId, double balanceDelta) async {
    final db = await dbHelper.database;
    await db.rawUpdate(
      'UPDATE ${TableConstants.customersTable} SET ${TableConstants.colCurrentBalance} = ${TableConstants.colCurrentBalance} + ? WHERE ${TableConstants.columnId} = ?',
      [balanceDelta, customerId],
    );
  }
}
