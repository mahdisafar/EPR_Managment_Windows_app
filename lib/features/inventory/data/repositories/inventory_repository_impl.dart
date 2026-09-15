import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_local_data_source.dart';
import '../models/product_model.dart';

@LazySingleton(as: InventoryRepository)
class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryLocalDataSource localDataSource;

  InventoryRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Unit>> addProduct(ProductModel product) async {
    try {
      await localDataSource.insertProduct(product);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure('خطا در ثبت کالا: $e'));
    }
  }

  @override
  Future<Either<Failure, ProductModel?>> getProductById(String id) async {
    try {
      final product = await localDataSource.getProductById(id);
      return Right(product);
    } catch (e) {
      return Left(DatabaseFailure('خطا در یافتن کالا: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProducts() async {
    try {
      final products = await localDataSource.getAllProducts();
      return Right(products);
    } catch (e) {
      return Left(DatabaseFailure('خطا در دریافت لیست کالاها: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProductStockAndCost({
    required String productId,
    required double quantityChange,
    required double newUnitCost,
  }) async {
    try {
      await localDataSource.updateStockAndLandedCost(
          productId, quantityChange, newUnitCost);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure('خطا در به‌روزرسانی موجودی: $e'));
    }
  }
}
