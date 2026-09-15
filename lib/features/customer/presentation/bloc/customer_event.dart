part of 'customer_bloc.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomersEvent extends CustomerEvent {
  final String? searchQuery;

  const LoadCustomersEvent({this.searchQuery});

  @override
  List<Object?> get props => [searchQuery];
}

class AddCustomerEvent extends CustomerEvent {
  final CustomerModel customer;

  const AddCustomerEvent(this.customer);

  @override
  List<Object?> get props => [customer];
}
