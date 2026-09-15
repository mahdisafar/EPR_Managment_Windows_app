import 'package:sqflite/sqflite.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/database/table_constants.dart';
import '../../../../config/enum.dart';
import '../models/shipment_model.dart';
import '../models/shipment_expense_model.dart';

abstract class ShipmentLocalDataSource {
  Future<void> insertShipment(ShipmentModel shipment);
  Future<List<ShipmentModel>> getShipments();
  Future<void> updateShipmentStatus(
      String shipmentId, ShipmentStatus newStatus);
  Future<void> insertShipmentExpense(ShipmentExpenseModel expense);
  Future<List<ShipmentExpenseModel>> getExpensesByShipmentId(String shipmentId);
}

@LazySingleton(as: ShipmentLocalDataSource)
class ShipmentLocalDataSourceImpl implements ShipmentLocalDataSource {
  final DatabaseHelper dbHelper;

  ShipmentLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<void> insertShipment(ShipmentModel shipment) async {
    final db = await dbHelper.database;
    await db.insert(
      TableConstants.shipmentsTable,
      shipment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<ShipmentModel>> getShipments() async {
    final db = await dbHelper.database;
    final result = await db.query(
      TableConstants.shipmentsTable,
      orderBy: '${TableConstants.colDispatchDate} DESC',
    );
    return result.map((map) => ShipmentModel.fromMap(map)).toList();
  }

  @override
  Future<void> updateShipmentStatus(
      String shipmentId, ShipmentStatus newStatus) async {
    final db = await dbHelper.database;
    await db.update(
      TableConstants.shipmentsTable,
      {TableConstants.colStatus: newStatus.name},
      where: '${TableConstants.columnId} = ?',
      whereArgs: [shipmentId],
    );
  }

  @override
  Future<void> insertShipmentExpense(ShipmentExpenseModel expense) async {
    final db = await dbHelper.database;
    await db.transaction((txn) async {
      await txn.insert(
        TableConstants.shipmentExpensesTable,
        expense.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await txn.rawUpdate(
        'UPDATE ${TableConstants.shipmentsTable} SET ${TableConstants.colTotalCosts} = ${TableConstants.colTotalCosts} + ? WHERE ${TableConstants.columnId} = ?',
        [expense.amount, expense.shipmentId],
      );
    });
  }

  @override
  Future<List<ShipmentExpenseModel>> getExpensesByShipmentId(
      String shipmentId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      TableConstants.shipmentExpensesTable,
      where: '${TableConstants.colShipmentId} = ?',
      whereArgs: [shipmentId],
      orderBy: '${TableConstants.columnDate} DESC',
    );
    return result.map((map) => ShipmentExpenseModel.fromMap(map)).toList();
  }
}
