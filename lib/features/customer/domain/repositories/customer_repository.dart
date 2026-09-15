import '../../data/models/customer_model.dart';
import '../../data/models/customer_statement_dto.dart';

abstract class CustomerRepository {
  Future<void> addCustomer(CustomerModel customer);
  Future<List<CustomerModel>> getCustomers();
  Future<CustomerModel?> getCustomerById(String id);
  Future<void> updateCustomerBalance(String customerId, double balanceDelta);
  Future<List<CustomerStatementDTO>> getCustomerStatement(String customerId);
}
