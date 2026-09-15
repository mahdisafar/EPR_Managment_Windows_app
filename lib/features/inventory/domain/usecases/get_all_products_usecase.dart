import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/product_model.dart';
import '../repositories/inventory_repository.dart';

@lazySingleton
class GetAllProductsUseCase {
  final InventoryRepository repository;

  GetAllProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductModel>>> call() async {
    return await repository.getAllProducts();
  }
}
