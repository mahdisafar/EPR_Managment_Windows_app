import '../repositories/customer_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RecordCustomerPaymentUseCase {
  final CustomerRepository repository;

  RecordCustomerPaymentUseCase(this.repository);

  Future<void> call(
      {required String customerId, required double amount}) async {
    await repository.updateCustomerBalance(customerId, -amount);
  }
}
