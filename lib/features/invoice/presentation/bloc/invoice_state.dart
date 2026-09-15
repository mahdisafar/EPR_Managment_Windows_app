import 'package:equatable/equatable.dart';
import 'package:eprwindowsapp/features/customer/data/models/customer_model.dart';
import 'package:eprwindowsapp/features/inventory/data/models/product_model.dart';
import 'package:eprwindowsapp/features/invoice/data/models/invoice_item_model.dart';

enum InvoiceStatus { initial, loading, ready, submitting, success, failure }

class InvoiceState extends Equatable {
  final InvoiceStatus status;
  final List<ProductModel> availableProducts;
  final List<CustomerModel> availableCustomers;
  final CustomerModel? selectedCustomer;
  final List<InvoiceItemModel> items;
  final double freightCost;
  final double customsCost;
  final double laborCost;
  final double totalItemsAmount;
  final double totalLandedCost;
  final String? errorMessage;

  const InvoiceState({
    this.status = InvoiceStatus.initial,
    this.availableProducts = const [],
    this.availableCustomers = const [],
    this.selectedCustomer,
    this.items = const [],
    this.freightCost = 0.0,
    this.customsCost = 0.0,
    this.laborCost = 0.0,
    this.totalItemsAmount = 0.0,
    this.totalLandedCost = 0.0,
    this.errorMessage,
  });

  double get grandTotal => totalItemsAmount + totalLandedCost;

  InvoiceState copyWith({
    InvoiceStatus? status,
    List<ProductModel>? availableProducts,
    List<CustomerModel>? availableCustomers,
    CustomerModel? selectedCustomer,
    bool clearSelectedCustomer = false,
    List<InvoiceItemModel>? items,
    double? freightCost,
    double? customsCost,
    double? laborCost,
    double? totalItemsAmount,
    double? totalLandedCost,
    String? errorMessage,
  }) {
    return InvoiceState(
      status: status ?? this.status,
      availableProducts: availableProducts ?? this.availableProducts,
      availableCustomers: availableCustomers ?? this.availableCustomers,
      selectedCustomer: clearSelectedCustomer
          ? null
          : (selectedCustomer ?? this.selectedCustomer),
      items: items ?? this.items,
      freightCost: freightCost ?? this.freightCost,
      customsCost: customsCost ?? this.customsCost,
      laborCost: laborCost ?? this.laborCost,
      totalItemsAmount: totalItemsAmount ?? this.totalItemsAmount,
      totalLandedCost: totalLandedCost ?? this.totalLandedCost,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        availableProducts,
        availableCustomers,
        selectedCustomer,
        items,
        freightCost,
        customsCost,
        laborCost,
        totalItemsAmount,
        totalLandedCost,
        errorMessage,
      ];
}
