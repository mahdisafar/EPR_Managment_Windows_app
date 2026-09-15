import 'package:equatable/equatable.dart';
import 'package:eprwindowsapp/features/customer/data/models/customer_model.dart';
import 'package:eprwindowsapp/features/inventory/data/models/product_model.dart';

abstract class InvoiceEvent extends Equatable {
  const InvoiceEvent();

  @override
  List<Object?> get props => [];
}

class AddInvoiceItemEvent extends InvoiceEvent {
  final ProductModel product;
  final double quantity;
  final double unitPrice;

  const AddInvoiceItemEvent({
    required this.product,
    required this.quantity,
    required this.unitPrice,
  });

  @override
  List<Object?> get props => [product, quantity, unitPrice];
}

class RemoveInvoiceItemEvent extends InvoiceEvent {
  final int index;

  const RemoveInvoiceItemEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class LoadPurchaseInvoiceDependenciesEvent extends InvoiceEvent {}

class UpdateLandedCostsEvent extends InvoiceEvent {
  final double freightCost;
  final double customsCost;
  final double laborCost;

  const UpdateLandedCostsEvent({
    required this.freightCost,
    required this.customsCost,
    required this.laborCost,
  });

  @override
  List<Object?> get props => [freightCost, customsCost, laborCost];
}

class SubmitPurchaseInvoiceEvent extends InvoiceEvent {
  final String invoiceNumber;
  final String supplierName;
  final String date;
  final String? shipmentId;
  final String? supplierAccountId;
  final String? paymentAccountId;

  const SubmitPurchaseInvoiceEvent({
    required this.invoiceNumber,
    required this.supplierName,
    required this.date,
    this.shipmentId,
    this.supplierAccountId,
    this.paymentAccountId,
  });

  @override
  List<Object?> get props => [
        invoiceNumber,
        supplierName,
        date,
        shipmentId,
        supplierAccountId,
        paymentAccountId,
      ];
}

class LoadSaleInvoiceDependenciesEvent extends InvoiceEvent {}

class SelectSaleCustomerEvent extends InvoiceEvent {
  final CustomerModel customer;

  const SelectSaleCustomerEvent(this.customer);

  @override
  List<Object?> get props => [customer];
}

class SubmitSaleInvoiceEvent extends InvoiceEvent {
  final String invoiceNumber;
  final String date;

  const SubmitSaleInvoiceEvent({
    required this.invoiceNumber,
    required this.date,
  });

  @override
  List<Object?> get props => [invoiceNumber, date];
}
