import 'package:equatable/equatable.dart';
import '../../../../config/enum.dart';
import '../../../../core/database/table_constants.dart';

class PersonalExpenseModel extends Equatable {
  final String id;
  final String itemName;
  final String category;
  final double quantity;
  final double unitPrice;
  final double totalAmount;
  final CurrencyType currency;
  final double? originalAmount;
  final double? exchangeRate;
  final DateTime date;
  final String? notes;
  final String? receiptNumber;
  final String? accountId;
  final String? accountName;

  const PersonalExpenseModel({
    required this.id,
    required this.itemName,
    required this.category,
    this.quantity = 1.0,
    required this.unitPrice,
    required this.totalAmount,
    this.currency = CurrencyType.toman,
    this.originalAmount,
    this.exchangeRate,
    required this.date,
    this.notes,
    this.receiptNumber,
    this.accountId,
    this.accountName,
  });

  PersonalExpenseModel copyWith({
    String? id,
    String? itemName,
    String? category,
    double? quantity,
    double? unitPrice,
    double? totalAmount,
    CurrencyType? currency,
    double? originalAmount,
    double? exchangeRate,
    DateTime? date,
    String? notes,
    String? receiptNumber,
    String? accountId,
    String? accountName,
  }) {
    return PersonalExpenseModel(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalAmount: totalAmount ?? this.totalAmount,
      currency: currency ?? this.currency,
      originalAmount: originalAmount ?? this.originalAmount,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      accountId: accountId ?? this.accountId,
      accountName: accountName ?? this.accountName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      TableConstants.columnId: id,
      TableConstants.colItemName: itemName,
      TableConstants.colCategory: category,
      TableConstants.colQuantity: quantity,
      TableConstants.colUnitPrice: unitPrice,
      TableConstants.colTotalAmount: totalAmount,
      TableConstants.colCurrency: currency.name,
      TableConstants.colOriginalAmount: originalAmount,
      TableConstants.colExchangeRate: exchangeRate,
      TableConstants.columnDate: date.toIso8601String(),
      TableConstants.colNotes: notes,
      TableConstants.colReceiptNumber: receiptNumber,
      TableConstants.colAccountId: accountId,
      TableConstants.colAccountName: accountName,
    };
  }

  factory PersonalExpenseModel.fromMap(Map<String, dynamic> map) {
    return PersonalExpenseModel(
      id: map[TableConstants.columnId] as String,
      itemName: map[TableConstants.colItemName] as String,
      category: (map[TableConstants.colCategory] ?? '') as String,
      quantity: (map[TableConstants.colQuantity] as num?)?.toDouble() ?? 1.0,
      unitPrice: (map[TableConstants.colUnitPrice] as num?)?.toDouble() ?? 0.0,
      totalAmount: (map[TableConstants.colTotalAmount] as num).toDouble(),
      currency: CurrencyType.values
          .byName(map[TableConstants.colCurrency] as String? ?? 'toman'),
      originalAmount: map[TableConstants.colOriginalAmount] != null
          ? (map[TableConstants.colOriginalAmount] as num).toDouble()
          : null,
      exchangeRate: map[TableConstants.colExchangeRate] != null
          ? (map[TableConstants.colExchangeRate] as num).toDouble()
          : null,
      date: DateTime.parse(map[TableConstants.columnDate] as String),
      notes: map[TableConstants.colNotes] as String?,
      receiptNumber: map[TableConstants.colReceiptNumber] as String?,
      accountId: map[TableConstants.colAccountId] as String?,
      accountName: map[TableConstants.colAccountName] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        itemName,
        category,
        quantity,
        unitPrice,
        totalAmount,
        currency,
        originalAmount,
        exchangeRate,
        date,
        notes,
        receiptNumber,
        accountId,
        accountName,
      ];
}
