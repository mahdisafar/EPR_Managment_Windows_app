part of 'customer_bloc.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object?> get props => [];
}

class CustomerInitialState extends CustomerState {}

class CustomerLoadingState extends CustomerState {}

class CustomerLoadedState extends CustomerState {
  final List<CustomerModel> customers;
  final List<CustomerModel> filteredCustomers;
  final String searchQuery;
  final double totalReceivables;
  final double totalPayables;

  const CustomerLoadedState({
    required this.customers,
    required this.filteredCustomers,
    this.searchQuery = '',
    required this.totalReceivables,
    required this.totalPayables,
  });

  @override
  List<Object?> get props => [
        customers,
        filteredCustomers,
        searchQuery,
        totalReceivables,
        totalPayables,
      ];
}

class CustomerErrorState extends CustomerState {
  final String message;

  const CustomerErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class CustomerSuccessState extends CustomerState {
  final String message;

  const CustomerSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}
