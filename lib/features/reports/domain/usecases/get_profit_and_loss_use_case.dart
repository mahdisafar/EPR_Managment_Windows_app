import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/domain/repositories/transaction_repository.dart';
import '../../../invoice/domain/repositories/invoice_repository.dart';
import '../../../inventory/domain/repositories/inventory_repository.dart';
import 'package:eprwindowsapp/config/enum.dart';

class ProfitAndLossReport {
  final DateTime startDate;
  final DateTime endDate;
  final double totalSalesRevenue;
  final double totalCostOfGoodsSold;
  final double grossProfit;
  final double totalOperatingExpenses;
  final double netProfitOrLoss;

  const ProfitAndLossReport({
    required this.startDate,
    required this.endDate,
    required this.totalSalesRevenue,
    required this.totalCostOfGoodsSold,
    required this.grossProfit,
    required this.totalOperatingExpenses,
    required this.netProfitOrLoss,
  });
}

@lazySingleton
class GetProfitAndLossUseCase {
  final InvoiceRepository invoiceRepository;
  final InventoryRepository inventoryRepository;
  final TransactionRepository transactionRepository;

  GetProfitAndLossUseCase({
    required this.invoiceRepository,
    required this.inventoryRepository,
    required this.transactionRepository,
  });

  Future<Either<Failure, ProfitAndLossReport>> execute({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final invoicesResult = await invoiceRepository.getAllInvoices();

    return invoicesResult.fold(
      (failure) => Left(failure),
      (allInvoices) async {
        final periodSaleInvoices = allInvoices.where((inv) {
          return inv.type == InvoiceType.sale &&
              inv.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
              inv.date.isBefore(endDate.add(const Duration(days: 1)));
        }).toList();

        final seenIds = <String>{};
        final uniqueInvoices = periodSaleInvoices.where((inv) {
          if (seenIds.contains(inv.id)) return false;
          seenIds.add(inv.id);
          return true;
        }).toList();

        double totalSalesRevenue = 0.0;
        double totalCOGS = 0.0;

        for (final invoice in uniqueInvoices) {
          totalSalesRevenue += invoice.totalAmount;
          for (final item in invoice.items) {
            final productResult =
                await inventoryRepository.getProductById(item.productId);
            final double unitCost = productResult.fold(
              (f) => 0.0,
              (p) => p?.landedCost ?? 0.0,
            );
            totalCOGS += (item.quantity * unitCost);
          }
        }

        final double grossProfit = totalSalesRevenue - totalCOGS;

        final periodTransactions = await transactionRepository
            .getTransactionsByDateRange(startDate, endDate);

        final double totalExpenses = periodTransactions
            .where((t) => t.type == TransactionType.expense)
            .fold(0.0, (sum, t) => sum + t.amount);

        final double netProfit = grossProfit - totalExpenses;

        return Right(
          ProfitAndLossReport(
            startDate: startDate,
            endDate: endDate,
            totalSalesRevenue: totalSalesRevenue,
            totalCostOfGoodsSold: totalCOGS,
            grossProfit: grossProfit,
            totalOperatingExpenses: totalExpenses,
            netProfitOrLoss: netProfit,
          ),
        );
      },
    );
  }
}
