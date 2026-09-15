import 'package:equatable/equatable.dart';
import '../../../../core/database/table_constants.dart';
import '../../../../config/enum.dart';
import 'invoice_item_model.dart';

class InvoiceModel extends Equatable {
  final String id;
  final String invoiceNumber;
  final InvoiceType type;
  final String? customerId;
  final String? shipmentId;
  final double totalAmount;
  final String? details;
  final DateTime date;
  final List<InvoiceItemModel> items;

  const InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.type,
    this.customerId,
    this.shipmentId,
    required this.totalAmount,
    this.details,
    required this.date,
    this.items = const [],
  });

  InvoiceModel copyWith({
    String? id,
    String? invoiceNumber,
    InvoiceType? type,
    String? customerId,
    String? shipmentId,
    double? totalAmount,
    String? details,
    DateTime? date,
    List<InvoiceItemModel>? items,
  }) {
    return InvoiceModel(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      type: type ?? this.type,
      customerId: customerId ?? this.customerId,
      shipmentId: shipmentId ?? this.shipmentId,
      totalAmount: totalAmount ?? this.totalAmount,
      details: details ?? this.details,
      date: date ?? this.date,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      TableConstants.columnId: id,
      TableConstants.colInvoiceNumber: invoiceNumber,
      TableConstants.columnType: type.name,
      TableConstants.colCustomerId: customerId,
      TableConstants.colShipmentId: shipmentId,
      TableConstants.colTotalAmount: totalAmount,
      TableConstants.columnDetails: details,
      TableConstants.columnDate: date.toIso8601String(),
    };
  }

  factory InvoiceModel.fromMap(
    Map<String, dynamic> map, {
    List<InvoiceItemModel> items = const [],
  }) {
    return InvoiceModel(
      id: map[TableConstants.columnId] as String,
      invoiceNumber: map[TableConstants.colInvoiceNumber] as String,
      type: InvoiceType.values.byName(map[TableConstants.columnType] as String),
      customerId: map[TableConstants.colCustomerId] as String?,
      shipmentId: map[TableConstants.colShipmentId] as String?,
      totalAmount: (map[TableConstants.colTotalAmount] as num).toDouble(),
      details: map[TableConstants.columnDetails] as String?,
      date: DateTime.parse(map[TableConstants.columnDate] as String),
      items: items,
    );
  }

  @override
  List<Object?> get props => [
        id,
        invoiceNumber,
        type,
        customerId,
        shipmentId,
        totalAmount,
        details,
        date,
        items,
      ];
}
