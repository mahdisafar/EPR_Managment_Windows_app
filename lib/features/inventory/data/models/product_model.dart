import 'package:equatable/equatable.dart';
import '../../../../core/database/table_constants.dart';
import '../../../../config/enum.dart' show UnitType;

class ProductModel extends Equatable {
  final String id;
  final String name;
  final UnitType unit;
  final double currentStock;
  final double purchasePrice;
  final double landedCost;

  const ProductModel({
    required this.id,
    required this.name,
    required this.unit,
    this.currentStock = 0.0,
    required this.purchasePrice,
    required this.landedCost,
  });

  ProductModel copyWith({
    String? id,
    String? name,
    UnitType? unit,
    double? currentStock,
    double? purchasePrice,
    double? landedCost,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      currentStock: currentStock ?? this.currentStock,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      landedCost: landedCost ?? this.landedCost,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      TableConstants.columnId: id,
      TableConstants.colProductName: name,
      TableConstants.colUnit: unit.name,
      TableConstants.colCurrentStock: currentStock,
      TableConstants.colPurchasePrice: purchasePrice,
      TableConstants.colLandedCost: landedCost,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map[TableConstants.columnId] as String,
      name: map[TableConstants.colProductName] as String,
      unit: UnitType.values.byName(map[TableConstants.colUnit] as String),
      currentStock:
          (map[TableConstants.colCurrentStock] as num? ?? 0.0).toDouble(),
      purchasePrice:
          (map[TableConstants.colPurchasePrice] as num? ?? 0.0).toDouble(),
      landedCost: (map[TableConstants.colLandedCost] as num? ?? 0.0).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        unit,
        currentStock,
        purchasePrice,
        landedCost,
      ];
}
