import '../../../../core/data/datasources/transaction_local_data_source.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_local_data_source.dart';
import '../../../invoice/data/datasources/invoice_local_data_source.dart';

import '../models/customer_model.dart';
import '../models/customer_statement_dto.dart';

@LazySingleton(as: CustomerRepository)
class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerLocalDataSource localDataSource;
  final InvoiceLocalDataSource? invoiceLocalDataSource;
  final TransactionLocalDataSource? transactionLocalDataSource;

  CustomerRepositoryImpl({
    required this.localDataSource,
    this.invoiceLocalDataSource,
    this.transactionLocalDataSource,
  });

  @override
  Future<void> addCustomer(CustomerModel customer) async {
    await localDataSource.insertCustomer(customer);
  }

  @override
  Future<List<CustomerModel>> getCustomers() async {
    return await localDataSource.getCustomers();
  }

  @override
  Future<CustomerModel?> getCustomerById(String id) async {
    return await localDataSource.getCustomerById(id);
  }

  @override
  Future<void> updateCustomerBalance(
      String customerId, double balanceDelta) async {
    await localDataSource.updateCustomerBalance(customerId, balanceDelta);
  }

  @override
  Future<List<CustomerStatementDTO>> getCustomerStatement(
      String customerId) async {
    final customer = await localDataSource.getCustomerById(customerId);
    if (customer == null) return [];

    final List<CustomerStatementDTO> statements = [];
    double runningBalance = customer.initialBalance;

    if (invoiceLocalDataSource != null) {
      final invoices =
          await invoiceLocalDataSource!.getInvoicesByCustomerId(customerId);
      for (final invoice in invoices) {
        runningBalance += invoice.totalAmount;
        statements.add(
          CustomerStatementDTO(
            id: invoice.id,
            date: invoice.date,
            details: 'فاکتور فروش شماره ${invoice.invoiceNumber}',
            totalAmount: invoice.totalAmount,
            receipts: 0.0,
            runningBalance: runningBalance,
          ),
        );
      }
    }

    if (transactionLocalDataSource != null) {
      final transactions = await transactionLocalDataSource!
          .getTransactionsByCustomerId(customerId);
      for (final tx in transactions) {
        runningBalance -= tx.amount;
        statements.add(
          CustomerStatementDTO(
            id: tx.id,
            date: tx.date,
            details: tx.details ?? 'رسید نقد / دریافتی',
            totalAmount: 0.0,
            receipts: tx.amount,
            runningBalance: runningBalance,
          ),
        );
      }
    }

    statements.sort((a, b) => a.date.compareTo(b.date));

    double recalculatedBalance = customer.initialBalance;
    final List<CustomerStatementDTO> finalStatements = [];

    for (final item in statements) {
      recalculatedBalance += (item.totalAmount - item.receipts);
      finalStatements.add(
        CustomerStatementDTO(
          id: item.id,
          date: item.date,
          details: item.details,
          quantity: item.quantity,
          price: item.price,
          totalAmount: item.totalAmount,
          receipts: item.receipts,
          runningBalance: recalculatedBalance,
        ),
      );
    }

    return finalStatements;
  }
}
