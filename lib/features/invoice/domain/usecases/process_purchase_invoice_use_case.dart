import '../../../../core/domain/repositories/account_repository.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/domain/repositories/transaction_repository.dart';
import '../../../../core/models/transaction_model.dart';
import '../repositories/invoice_repository.dart';
import '../../../inventory/domain/repositories/inventory_repository.dart';
import 'package:eprwindowsapp/config/enum.dart';
import '../../data/models/invoice_model.dart';
import 'calculate_landed_cost_use_case.dart';

@lazySingleton
class ProcessPurchaseInvoiceUseCase {
  final InvoiceRepository invoiceRepository;
  final AccountRepository accountRepository;
  final InventoryRepository inventoryRepository;
  final TransactionRepository transactionRepository;
  final CalculateLandedCostUseCase calculateLandedCostUseCase;

  ProcessPurchaseInvoiceUseCase({
    required this.invoiceRepository,
    required this.accountRepository,
    required this.inventoryRepository,
    required this.transactionRepository,
    required this.calculateLandedCostUseCase,
  });

  Future<LandedCostCalculationResult> execute({
    required InvoiceModel purchaseInvoice,
    required String supplierAccountId,
    required String paymentAccountId,
    required List<InvoiceItemInput> items,
    required List<AdditionalExpense> additionalExpenses,
    LandedCostAllocationMethod allocationMethod =
        LandedCostAllocationMethod.byValue,
  }) async {
    final landedCostResult = calculateLandedCostUseCase(
      items: items,
      expenses: additionalExpenses,
      allocationMethod: allocationMethod,
    );

    for (final item in landedCostResult.items) {
      final productResult =
          await inventoryRepository.getProductById(item.productId);

      final product = productResult.fold(
        (failure) => throw Exception(failure.message),
        (p) => p,
      );

      final double currentAvgCost = product?.landedCost ?? 0.0;
      final double currentStock = product?.currentStock ?? 0.0;

      final double newStock = currentStock + item.quantity;
      final double newAverageCost = newStock > 0
          ? ((currentStock * currentAvgCost) +
                  (item.quantity * item.unitLandedCost)) /
              newStock
          : item.unitLandedCost;

      final updateResult = await inventoryRepository.updateProductStockAndCost(
        productId: item.productId,
        quantityChange: item.quantity.toDouble(),
        newUnitCost: newAverageCost,
      );

      updateResult.fold(
        (failure) => throw Exception(failure.message),
        (_) {},
      );
    }

    final supplierResult =
        await accountRepository.getAccountById(supplierAccountId);
    final supplierAccount = supplierResult.fold(
      (failure) => throw Exception(failure.message),
      (a) => a,
    );
    if (supplierAccount != null) {
      final r = await accountRepository.updateAccountBalance(
        supplierAccountId,
        supplierAccount.balance + landedCostResult.totalSubtotal,
      );
      r.fold((f) => throw Exception(f.message), (_) {});
    }

    if (additionalExpenses.isNotEmpty && landedCostResult.totalExpenses > 0) {
      final paymentResult =
          await accountRepository.getAccountById(paymentAccountId);
      final paymentAccount = paymentResult.fold(
        (failure) => throw Exception(failure.message),
        (a) => a,
      );
      if (paymentAccount != null) {
        final r = await accountRepository.updateAccountBalance(
          paymentAccountId,
          paymentAccount.balance - landedCostResult.totalExpenses,
        );
        r.fold((f) => throw Exception(f.message), (_) {});
      }
    }

    final addResult = await invoiceRepository.addInvoice(purchaseInvoice);
    addResult.fold(
      (failure) => throw Exception(failure.message),
      (_) {},
    );

    final transaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'فاکتور خرید شماره ${purchaseInvoice.invoiceNumber}',
      details: 'ثبت سیستم بابت خرید کالا',
      amount: landedCostResult.grandTotalLandedCost,
      type: TransactionType.expense,
      referenceType: ReferenceType.inventory,
      referenceId: purchaseInvoice.id,
      documentNumber: purchaseInvoice.invoiceNumber,
      sourceAccount: supplierAccountId,
      destinationAccount: paymentAccountId,
      date: purchaseInvoice.date,
    );
    await transactionRepository.addTransaction(transaction);

    return landedCostResult;
  }
}
