part of 'invoices_list_bloc.dart';

abstract class InvoicesListState extends Equatable {
  const InvoicesListState();

  @override
  List<Object> get props => [];
}

class InvoicesListInitial extends InvoicesListState {}

class InvoicesListLoading extends InvoicesListState {}

class InvoicesListLoaded extends InvoicesListState {
  final List<InvoiceModel> allInvoices;
  final List<InvoiceModel> filteredInvoices;
  final Map<String, String> customerNames;
  final List<ProductModel> products;
  final String query;
  final String typeFilter;

  const InvoicesListLoaded({
    required this.allInvoices,
    required this.filteredInvoices,
    required this.customerNames,
    this.products = const [],
    this.query = '',
    this.typeFilter = 'all',
  });

  double get totalFiltered =>
      filteredInvoices.fold(0.0, (sum, inv) => sum + inv.totalAmount);

  @override
  List<Object> get props => [
        allInvoices,
        filteredInvoices,
        customerNames,
        products,
        query,
        typeFilter
      ];
}

class InvoicesListError extends InvoicesListState {
  final String message;

  const InvoicesListError(this.message);

  @override
  List<Object> get props => [message];
}
