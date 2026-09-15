import 'package:sqflite/sqflite.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/database/table_constants.dart';
import '../models/product_model.dart';

abstract class InventoryLocalDataSource {
  Future<void> insertProduct(ProductModel product);
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel?> getProductById(String id);
  Future<void> updateStockAndLandedCost(
      String productId, double stockDelta, double updatedLandedCost);
}

@LazySingleton(as: InventoryLocalDataSource)
class InventoryLocalDataSourceImpl implements InventoryLocalDataSource {
  final DatabaseHelper dbHelper;

  InventoryLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<void> insertProduct(ProductModel product) async {
    final db = await dbHelper.database;
    await db.insert(
      TableConstants.productsTable,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final db = await dbHelper.database;
    final maps = await db.query(TableConstants.productsTable);
    return maps.map((map) => ProductModel.fromMap(map)).toList();
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      TableConstants.productsTable,
      where: '${TableConstants.columnId} = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return ProductModel.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<void> updateStockAndLandedCost(
      String productId, double stockDelta, double updatedLandedCost) async {
    final db = await dbHelper.database;
    await db.rawUpdate(
      'UPDATE ${TableConstants.productsTable} SET ${TableConstants.colCurrentStock} = ${TableConstants.colCurrentStock} + ?, ${TableConstants.colLandedCost} = ? WHERE ${TableConstants.columnId} = ?',
      [stockDelta, updatedLandedCost, productId],
    );
  }
}
