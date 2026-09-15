import 'package:injectable/injectable.dart';

enum LandedCostAllocationMethod {
  byValue,
  byQuantity,
  byWeight,
}

class AdditionalExpense {
  final String title;
  final double amount;

  const AdditionalExpense({
    required this.title,
    required this.amount,
  });
}

class InvoiceItemInput {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double weightKg;

  const InvoiceItemInput({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    this.weightKg = 0.0,
  });

  double get totalPrice => quantity * unitPrice;
}

class LandedCostItemResult {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double allocatedExpense;
  final double totalLandedCost;
  final double unitLandedCost;

  const LandedCostItemResult({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.allocatedExpense,
    required this.totalLandedCost,
    required this.unitLandedCost,
  });
}

class LandedCostCalculationResult {
  final List<LandedCostItemResult> items;
  final double totalSubtotal;
  final double totalExpenses;
  final double grandTotalLandedCost;

  const LandedCostCalculationResult({
    required this.items,
    required this.totalSubtotal,
    required this.totalExpenses,
    required this.grandTotalLandedCost,
  });
}

@lazySingleton
class CalculateLandedCostUseCase {
  LandedCostCalculationResult call({
    required List<InvoiceItemInput> items,
    required List<AdditionalExpense> expenses,
    LandedCostAllocationMethod allocationMethod =
        LandedCostAllocationMethod.byValue,
  }) {
    if (items.isEmpty) {
      throw ArgumentError('لیست اقلام فاکتور نمی‌تواند خالی باشد.');
    }

    final double totalExpenses = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final double totalSubtotal =
        items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final int totalQuantity = items.fold(0, (sum, item) => sum + item.quantity);
    final double totalWeight =
        items.fold(0.0, (sum, item) => sum + item.weightKg);

    final List<LandedCostItemResult> calculatedItems = [];

    for (final item in items) {
      double allocationRatio = 0.0;

      switch (allocationMethod) {
        case LandedCostAllocationMethod.byValue:
          allocationRatio =
              totalSubtotal > 0 ? (item.totalPrice / totalSubtotal) : 0;
          break;
        case LandedCostAllocationMethod.byQuantity:
          allocationRatio =
              totalQuantity > 0 ? (item.quantity / totalQuantity) : 0;
          break;
        case LandedCostAllocationMethod.byWeight:
          if (totalWeight <= 0) {
            throw ArgumentError(
                'برای تسهیم بر اساس وزن، وزن اقلام باید بزرگتر از صفر باشد.');
          }
          allocationRatio = item.weightKg / totalWeight;
          break;
      }

      final double itemAllocatedExpense = totalExpenses * allocationRatio;
      final double itemTotalLandedCost = item.totalPrice + itemAllocatedExpense;
      final double itemUnitLandedCost =
          item.quantity > 0 ? (itemTotalLandedCost / item.quantity) : 0.0;

      calculatedItems.add(
        LandedCostItemResult(
          productId: item.productId,
          productName: item.productName,
          quantity: item.quantity,
          unitPrice: item.unitPrice,
          allocatedExpense: itemAllocatedExpense,
          totalLandedCost: itemTotalLandedCost,
          unitLandedCost: itemUnitLandedCost,
        ),
      );
    }

    return LandedCostCalculationResult(
      items: calculatedItems,
      totalSubtotal: totalSubtotal,
      totalExpenses: totalExpenses,
      grandTotalLandedCost: totalSubtotal + totalExpenses,
    );
  }
}
