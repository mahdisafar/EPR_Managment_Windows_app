part of 'customer_statement_bloc.dart';

abstract class CustomerStatementState extends Equatable {
  const CustomerStatementState();

  @override
  List<Object?> get props => [];
}

class CustomerStatementInitialState extends CustomerStatementState {}

class CustomerStatementLoadingState extends CustomerStatementState {}

class CustomerStatementLoadedState extends CustomerStatementState {
  final List<CustomerStatementDTO> statements;

  const CustomerStatementLoadedState(this.statements);

  @override
  List<Object?> get props => [statements];
}

class CustomerStatementErrorState extends CustomerStatementState {
  final String message;

  const CustomerStatementErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class PaymentRecordedSuccessState extends CustomerStatementState {
  final String message;

  const PaymentRecordedSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}
