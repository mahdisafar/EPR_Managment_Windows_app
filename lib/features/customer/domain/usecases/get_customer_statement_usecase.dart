import 'package:eprwindowsapp/features/customer/domain/repositories/customer_repository.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/customer_statement_dto.dart';

@lazySingleton
class GetCustomerStatementUseCase {
  final CustomerRepository repository;

  GetCustomerStatementUseCase(this.repository);

  Future<List<CustomerStatementDTO>> call(String customerId) async {
    return await repository.getCustomerStatement(customerId);
  }
}
