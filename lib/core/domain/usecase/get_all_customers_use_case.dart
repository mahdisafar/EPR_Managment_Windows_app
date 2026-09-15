import 'package:injectable/injectable.dart';
import '../../../features/customer/data/models/customer_model.dart';
import '../../../features/customer/domain/repositories/customer_repository.dart';

@lazySingleton
class GetAllCustomersUseCase {
  final CustomerRepository repository;

  GetAllCustomersUseCase(this.repository);

  Future<List<CustomerModel>> call() async {
    return await repository.getCustomers();
  }
}
