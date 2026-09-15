import 'package:equatable/equatable.dart';
import 'package:eprwindowsapp/core/database/table_constants.dart';

import '../../config/enum.dart';

class TransactionModel extends Equatable {
  final String id;
  final String title;
  final String? details;
  final double amount;
  final CurrencyType currency;
  final double? originalAmount;
  final double? exchangeRate;
  final TransactionType type;
  final ReferenceType referenceType;
  final String? referenceId;
  final String? documentNumber;
  final String? sourceAccount;
  final String? destinationAccount;
  final String? paidToOrFrom;
  final double? quantity;
  final double? unitPrice;
  final DateTime date;

  const TransactionModel({
    required this.id,
    required this.title,
    this.details,
    required this.amount,
    this.currency = CurrencyType.toman,
    this.originalAmount,
    this.exchangeRate,
    required this.type,
    required this.referenceType,
    this.referenceId,
    this.documentNumber,
    this.sourceAccount,
    this.destinationAccount,
    this.paidToOrFrom,
    this.quantity,
    this.unitPrice,
    required this.date,
  });

  TransactionModel copyWith({
    String? id,
    String? title,
    String? details,
    double? amount,
    CurrencyType? currency,
    double? originalAmount,
    double? exchangeRate,
    TransactionType? type,
    ReferenceType? referenceType,
    String? referenceId,
    String? documentNumber,
    String? sourceAccount,
    String? destinationAccount,
    String? paidToOrFrom,
    double? quantity,
    double? unitPrice,
    DateTime? date,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      details: details ?? this.details,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      originalAmount: originalAmount ?? this.originalAmount,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      type: type ?? this.type,
      referenceType: referenceType ?? this.referenceType,
      referenceId: referenceId ?? this.referenceId,
      documentNumber: documentNumber ?? this.documentNumber,
      sourceAccount: sourceAccount ?? this.sourceAccount,
      destinationAccount: destinationAccount ?? this.destinationAccount,
      paidToOrFrom: paidToOrFrom ?? this.paidToOrFrom,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      TableConstants.columnId: id,
      TableConstants.colTitle: title,
      TableConstants.columnDetails: details,
      TableConstants.columnAmount: amount,
      TableConstants.colCurrency: currency.name,
      TableConstants.colOriginalAmount: originalAmount,
      TableConstants.colExchangeRate: exchangeRate,
      TableConstants.columnType: type.name,
      TableConstants.colReferenceType: referenceType.name,
      TableConstants.colReferenceId: referenceId,
      TableConstants.colDocumentNumber: documentNumber,
      TableConstants.colSourceAccount: sourceAccount,
      TableConstants.colDestinationAccount: destinationAccount,
      TableConstants.colPaidToOrFrom: paidToOrFrom,
      TableConstants.colQuantity: quantity,
      TableConstants.colUnitPrice: unitPrice,
      TableConstants.columnDate: date.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map[TableConstants.columnId] as String,
      title: map[TableConstants.colTitle] as String,
      details: map[TableConstants.columnDetails] as String?,
      amount: (map[TableConstants.columnAmount] as num).toDouble(),
      currency: CurrencyType.values
          .byName(map[TableConstants.colCurrency] as String? ?? 'toman'),
      originalAmount: map[TableConstants.colOriginalAmount] != null
          ? (map[TableConstants.colOriginalAmount] as num).toDouble()
          : null,
      exchangeRate: map[TableConstants.colExchangeRate] != null
          ? (map[TableConstants.colExchangeRate] as num).toDouble()
          : null,
      type: TransactionType.values
          .byName(map[TableConstants.columnType] as String),
      referenceType: ReferenceType.values
          .byName(map[TableConstants.colReferenceType] as String),
      referenceId: map[TableConstants.colReferenceId] as String?,
      documentNumber: map[TableConstants.colDocumentNumber] as String?,
      sourceAccount: map[TableConstants.colSourceAccount] as String?,
      destinationAccount: map[TableConstants.colDestinationAccount] as String?,
      paidToOrFrom: map[TableConstants.colPaidToOrFrom] as String?,
      quantity: map[TableConstants.colQuantity] != null
          ? (map[TableConstants.colQuantity] as num).toDouble()
          : null,
      unitPrice: map[TableConstants.colUnitPrice] != null
          ? (map[TableConstants.colUnitPrice] as num).toDouble()
          : null,
      date: DateTime.parse(map[TableConstants.columnDate] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        details,
        amount,
        currency,
        originalAmount,
        exchangeRate,
        type,
        referenceType,
        referenceId,
        documentNumber,
        sourceAccount,
        destinationAccount,
        paidToOrFrom,
        quantity,
        unitPrice,
        date,
      ];
}
