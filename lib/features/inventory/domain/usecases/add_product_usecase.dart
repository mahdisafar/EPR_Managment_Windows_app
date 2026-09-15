import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/product_model.dart';
import '../repositories/inventory_repository.dart';

@lazySingleton
class AddProductUseCase {
  final InventoryRepository repository;

  AddProductUseCase(this.repository);

  Future<Either<Failure, Unit>> execute({required ProductModel product}) async {
    if (product.name.trim().isEmpty) {
      return const Left(ValidationFailure('نام کالا نمی‌تواند خالی باشد.'));
    }
    if (product.purchasePrice < 0) {
      return const Left(ValidationFailure('قیمت خرید نمی‌تواند منفی باشد.'));
    }
    return await repository.addProduct(product);
  }
}
