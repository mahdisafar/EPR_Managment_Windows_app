import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/product_model.dart';

abstract class InventoryRepository {
  Future<Either<Failure, Unit>> addProduct(ProductModel product);
  Future<Either<Failure, ProductModel?>> getProductById(String id);
  Future<Either<Failure, List<ProductModel>>> getAllProducts();
  Future<Either<Failure, Unit>> updateProductStockAndCost({
    required String productId,
    required double quantityChange,
    required double newUnitCost,
  });
}
