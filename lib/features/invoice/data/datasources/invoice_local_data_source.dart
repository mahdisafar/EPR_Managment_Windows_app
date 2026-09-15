import 'package:sqflite/sqflite.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/database/table_constants.dart';
import '../models/invoice_item_model.dart';
import '../models/invoice_model.dart';

abstract class InvoiceLocalDataSource {
  Future<void> insertInvoice(InvoiceModel invoice);
  Future<InvoiceModel?> getInvoiceById(String id);
  Future<List<InvoiceModel>> getAllInvoices();
  Future<List<InvoiceModel>> getInvoicesByCustomerId(String customerId);
  Future<void> deleteInvoice(String id);
}

@LazySingleton(as: InvoiceLocalDataSource)
class InvoiceLocalDataSourceImpl implements InvoiceLocalDataSource {
  final DatabaseHelper _databaseHelper;

  InvoiceLocalDataSourceImpl({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  @override
  Future<void> insertInvoice(InvoiceModel invoice) async {
    final db = await _databaseHelper.database;

    await db.transaction((txn) async {
      await txn.insert(
        TableConstants.invoicesTable,
        invoice.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await txn.delete(
        TableConstants.invoiceItemsTable,
        where: '${TableConstants.colInvoiceId} = ?',
        whereArgs: [invoice.id],
      );

      for (final item in invoice.items) {
        await txn.insert(
          TableConstants.invoiceItemsTable,
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  @override
  Future<InvoiceModel?> getInvoiceById(String id) async {
    final db = await _databaseHelper.database;
    final invoiceMaps = await db.query(
      TableConstants.invoicesTable,
      where: '${TableConstants.columnId} = ?',
      whereArgs: [id],
    );

    if (invoiceMaps.isEmpty) return null;

    final itemMaps = await db.query(
      TableConstants.invoiceItemsTable,
      where: '${TableConstants.colInvoiceId} = ?',
      whereArgs: [id],
    );

    final items = itemMaps.map((e) => InvoiceItemModel.fromMap(e)).toList();
    return InvoiceModel.fromMap(invoiceMaps.first, items: items);
  }

  @override
  Future<List<InvoiceModel>> getAllInvoices() async {
    final db = await _databaseHelper.database;
    final invoiceMaps = await db.query(
      TableConstants.invoicesTable,
      orderBy: '${TableConstants.columnDate} DESC',
    );

    final List<InvoiceModel> invoices = [];
    for (final map in invoiceMaps) {
      final invoiceId = map[TableConstants.columnId] as String;
      final itemMaps = await db.query(
        TableConstants.invoiceItemsTable,
        where: '${TableConstants.colInvoiceId} = ?',
        whereArgs: [invoiceId],
      );
      final items = itemMaps.map((e) => InvoiceItemModel.fromMap(e)).toList();
      invoices.add(InvoiceModel.fromMap(map, items: items));
    }
    return invoices;
  }

  @override
  Future<List<InvoiceModel>> getInvoicesByCustomerId(String customerId) async {
    final db = await _databaseHelper.database;
    final invoiceMaps = await db.query(
      TableConstants.invoicesTable,
      where: '${TableConstants.colCustomerId} = ?',
      whereArgs: [customerId],
      orderBy: '${TableConstants.columnDate} DESC',
    );

    final List<InvoiceModel> invoices = [];
    for (final map in invoiceMaps) {
      final invoiceId = map[TableConstants.columnId] as String;
      final itemMaps = await db.query(
        TableConstants.invoiceItemsTable,
        where: '${TableConstants.colInvoiceId} = ?',
        whereArgs: [invoiceId],
      );
      final items = itemMaps.map((e) => InvoiceItemModel.fromMap(e)).toList();
      invoices.add(InvoiceModel.fromMap(map, items: items));
    }
    return invoices;
  }

  @override
  Future<void> deleteInvoice(String id) async {
    final db = await _databaseHelper.database;
    await db.transaction((txn) async {
      await txn.delete(
        TableConstants.invoiceItemsTable,
        where: '${TableConstants.colInvoiceId} = ?',
        whereArgs: [id],
      );
      await txn.delete(
        TableConstants.invoicesTable,
        where: '${TableConstants.columnId} = ?',
        whereArgs: [id],
      );
    });
  }
}
