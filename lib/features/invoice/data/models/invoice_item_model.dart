import 'package:equatable/equatable.dart';
import '../../../../core/database/table_constants.dart';

class InvoiceItemModel extends Equatable {
  final String id;
  final String invoiceId;
  final String productId;
  final double quantity;
  final double unitPrice;
  final double unitLandedCost;
  final double totalPrice;

  const InvoiceItemModel({
    required this.id,
    required this.invoiceId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    this.unitLandedCost = 0.0,
    required this.totalPrice,
  });

  InvoiceItemModel copyWith({
    String? id,
    String? invoiceId,
    String? productId,
    double? quantity,
    double? unitPrice,
    double? unitLandedCost,
    double? totalPrice,
  }) {
    return InvoiceItemModel(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      unitLandedCost: unitLandedCost ?? this.unitLandedCost,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      TableConstants.columnId: id,
      TableConstants.colInvoiceId: invoiceId,
      TableConstants.colProductId: productId,
      TableConstants.colQuantity: quantity,
      TableConstants.colUnitPrice: unitPrice,
      TableConstants.colUnitLandedCost: unitLandedCost,
      TableConstants.colTotalPrice: totalPrice,
    };
  }

  factory InvoiceItemModel.fromMap(Map<String, dynamic> map) {
    return InvoiceItemModel(
      id: map[TableConstants.columnId] as String,
      invoiceId: map[TableConstants.colInvoiceId] as String,
      productId: map[TableConstants.colProductId] as String,
      quantity: (map[TableConstants.colQuantity] as num).toDouble(),
      unitPrice: (map[TableConstants.colUnitPrice] as num).toDouble(),
      unitLandedCost:
          (map[TableConstants.colUnitLandedCost] as num? ?? 0.0).toDouble(),
      totalPrice: (map[TableConstants.colTotalPrice] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        invoiceId,
        productId,
        quantity,
        unitPrice,
        unitLandedCost,
        totalPrice,
      ];
}
