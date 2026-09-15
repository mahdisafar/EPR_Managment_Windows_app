import '../../../../core/domain/repositories/transaction_repository.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/models/transaction_model.dart';
import '../../data/models/invoice_model.dart';
import '../repositories/invoice_repository.dart';
import '../../../inventory/domain/repositories/inventory_repository.dart';
import '../../../customer/domain/repositories/customer_repository.dart';
import '../../../../core/domain/repositories/account_repository.dart';
import 'package:eprwindowsapp/config/enum.dart';

@lazySingleton
class ProcessSaleInvoiceUseCase {
  final InvoiceRepository invoiceRepository;
  final InventoryRepository inventoryRepository;
  final CustomerRepository customerRepository;
  final AccountRepository accountRepository;
  final TransactionRepository transactionRepository;

  ProcessSaleInvoiceUseCase({
    required this.invoiceRepository,
    required this.inventoryRepository,
    required this.customerRepository,
    required this.accountRepository,
    required this.transactionRepository,
  });

  Future<void> execute({
    required InvoiceModel saleInvoice,
    required bool isCashPayment,
    String? cashAccountId,
  }) async {
    for (final item in saleInvoice.items) {
      final productResult =
          await inventoryRepository.getProductById(item.productId);

      final product = productResult.fold(
        (failure) => throw Exception(failure.message),
        (p) => p,
      );

      if (product == null) {
        throw Exception('کالای با شناسه ${item.productId} یافت نشد.');
      }

      if (product.currentStock < item.quantity) {
        throw Exception(
          'موجودی کالای "${product.name}" کافی نیست. موجودی فعلی: ${product.currentStock}',
        );
      }

      final updateResult = await inventoryRepository.updateProductStockAndCost(
        productId: item.productId,
        quantityChange: -item.quantity.toDouble(),
        newUnitCost: product.landedCost,
      );

      updateResult.fold(
        (failure) => throw Exception(failure.message),
        (_) {},
      );
    }

    if (isCashPayment) {
      if (cashAccountId == null || cashAccountId.isEmpty) {
        throw Exception(
            'برای پرداخت نقدی، تعیین حساب صندوق یا بانک الزامی است.');
      }
      final accountResult =
          await accountRepository.getAccountById(cashAccountId);
      final account = accountResult.fold(
        (failure) => throw Exception(failure.message),
        (a) => a,
      );
      if (account != null) {
        final updateResult = await accountRepository.updateAccountBalance(
          cashAccountId,
          account.balance + saleInvoice.totalAmount,
        );
        updateResult.fold(
          (failure) => throw Exception(failure.message),
          (_) {},
        );
      }
    } else if (saleInvoice.customerId != null) {
      final customer =
          await customerRepository.getCustomerById(saleInvoice.customerId!);
      if (customer != null) {
        await customerRepository.updateCustomerBalance(
          saleInvoice.customerId!,
          customer.balance + saleInvoice.totalAmount,
        );
      }
    }

    final addResult = await invoiceRepository.addInvoice(saleInvoice);
    addResult.fold(
      (failure) => throw Exception(failure.message),
      (_) {},
    );

    final transaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'فاکتور فروش شماره ${saleInvoice.invoiceNumber}',
      details: 'ثبت سیستم بابت فروش کالا',
      amount: saleInvoice.totalAmount,
      type: TransactionType.income,
      referenceType: ReferenceType.inventory,
      referenceId: saleInvoice.id,
      documentNumber: saleInvoice.invoiceNumber,
      sourceAccount: isCashPayment ? cashAccountId : saleInvoice.customerId,
      paidToOrFrom: saleInvoice.customerId,
      date: saleInvoice.date,
    );
    await transactionRepository.addTransaction(transaction);
  }
}
