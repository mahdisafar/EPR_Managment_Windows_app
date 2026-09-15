part of 'ledger_bloc.dart';

abstract class LedgerEvent extends Equatable {
  const LedgerEvent();

  @override
  List<Object?> get props => [];
}

class FetchLedgerTransactionsEvent extends LedgerEvent {
  final String? searchQuery;
  final String? typeFilter; // income, expense, transfer, etc.
  final DateTime? startDate;
  final DateTime? endDate;

  const FetchLedgerTransactionsEvent({
    this.searchQuery,
    this.typeFilter,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [searchQuery, typeFilter, startDate, endDate];
}

class DeleteLedgerTransactionEvent extends LedgerEvent {
  final String transactionId;

  const DeleteLedgerTransactionEvent(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}
