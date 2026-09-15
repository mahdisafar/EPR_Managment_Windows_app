import '../repositories/customer_repository.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/customer_model.dart';

@lazySingleton
class AddCustomerUseCase {
  final CustomerRepository repository;

  AddCustomerUseCase(this.repository);

  Future<void> call(CustomerModel customer) async {
    await repository.addCustomer(customer);
  }
}
