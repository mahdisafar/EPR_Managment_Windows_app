import 'package:equatable/equatable.dart';
import '../../../../config/enum.dart';
import '../../../../core/database/table_constants.dart';

class ShipmentExpenseModel extends Equatable {
  final String id;
  final String shipmentId;
  final ExpenseType expenseType;
  final double amount;
  final CurrencyType currency;
  final double? originalAmount;
  final double? exchangeRate;
  final String sourceAccount;
  final String paidTo;
  final String? receiptNumber;
  final String? details;
  final DateTime date;

  const ShipmentExpenseModel({
    required this.id,
    required this.shipmentId,
    required this.expenseType,
    required this.amount,
    required this.currency,
    this.originalAmount,
    this.exchangeRate,
    required this.sourceAccount,
    required this.paidTo,
    this.receiptNumber,
    this.details,
    required this.date,
  });

  ShipmentExpenseModel copyWith({
    String? id,
    String? shipmentId,
    ExpenseType? expenseType,
    double? amount,
    CurrencyType? currency,
    double? originalAmount,
    double? exchangeRate,
    String? sourceAccount,
    String? paidTo,
    String? receiptNumber,
    String? details,
    DateTime? date,
  }) {
    return ShipmentExpenseModel(
      id: id ?? this.id,
      shipmentId: shipmentId ?? this.shipmentId,
      expenseType: expenseType ?? this.expenseType,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      originalAmount: originalAmount ?? this.originalAmount,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      sourceAccount: sourceAccount ?? this.sourceAccount,
      paidTo: paidTo ?? this.paidTo,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      details: details ?? this.details,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      TableConstants.columnId: id,
      TableConstants.colShipmentId: shipmentId,
      TableConstants.columnType: expenseType.name,
      TableConstants.columnAmount: amount,
      TableConstants.colCurrency: currency.name,
      TableConstants.colOriginalAmount: originalAmount,
      TableConstants.colExchangeRate: exchangeRate,
      TableConstants.colSourceAccount: sourceAccount,
      TableConstants.colPaidTo: paidTo,
      TableConstants.colReceiptNumber: receiptNumber,
      TableConstants.columnDetails: details,
      TableConstants.columnDate: date.toIso8601String(),
    };
  }

  factory ShipmentExpenseModel.fromMap(Map<String, dynamic> map) {
    return ShipmentExpenseModel(
      id: map[TableConstants.columnId] as String,
      shipmentId: map[TableConstants.colShipmentId] as String,
      expenseType:
          ExpenseType.values.byName(map[TableConstants.columnType] as String),
      amount: (map[TableConstants.columnAmount] as num).toDouble(),
      currency:
          CurrencyType.values.byName(map[TableConstants.colCurrency] as String),
      originalAmount: map[TableConstants.colOriginalAmount] != null
          ? (map[TableConstants.colOriginalAmount] as num).toDouble()
          : null,
      exchangeRate: map[TableConstants.colExchangeRate] != null
          ? (map[TableConstants.colExchangeRate] as num).toDouble()
          : null,
      sourceAccount: map[TableConstants.colSourceAccount] as String,
      paidTo: map[TableConstants.colPaidTo] as String,
      receiptNumber: map[TableConstants.colReceiptNumber] as String?,
      details: map[TableConstants.columnDetails] as String?,
      date: DateTime.parse(map[TableConstants.columnDate] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        shipmentId,
        expenseType,
        amount,
        currency,
        originalAmount,
        exchangeRate,
        sourceAccount,
        paidTo,
        receiptNumber,
        details,
        date,
      ];
}
