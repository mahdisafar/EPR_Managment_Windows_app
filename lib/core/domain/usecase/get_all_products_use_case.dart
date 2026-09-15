import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failures.dart';
import '../../../features/inventory/data/models/product_model.dart';
import '../../../features/inventory/domain/repositories/inventory_repository.dart';

@lazySingleton
class GetAllProductsUseCase {
  final InventoryRepository repository;

  GetAllProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductModel>>> call() async {
    return await repository.getAllProducts();
  }
}
