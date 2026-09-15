part of 'invoices_list_bloc.dart';

abstract class InvoicesListEvent extends Equatable {
  const InvoicesListEvent();

  @override
  List<Object> get props => [];
}

class LoadInvoicesListEvent extends InvoicesListEvent {}

class SearchInvoicesListEvent extends InvoicesListEvent {
  final String query;

  const SearchInvoicesListEvent(this.query);

  @override
  List<Object> get props => [query];
}

class FilterInvoicesByTypeEvent extends InvoicesListEvent {
  final String typeFilter; // 'all' | 'sale' | 'purchase'

  const FilterInvoicesByTypeEvent(this.typeFilter);

  @override
  List<Object> get props => [typeFilter];
}
