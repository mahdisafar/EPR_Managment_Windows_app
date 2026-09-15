part of 'ledger_bloc.dart';

abstract class LedgerState extends Equatable {
  const LedgerState();

  @override
  List<Object?> get props => [];
}

class LedgerInitialState extends LedgerState {}

class LedgerLoadingState extends LedgerState {}

class LedgerLoadedState extends LedgerState {
  final List<TransactionModel> allTransactions;
  final List<TransactionModel> filteredTransactions;
  final Map<String, double>
      runningBalances;
  final double totalDebit;
  final double totalCredit;
  final String searchQuery;
  final String selectedType;

  const LedgerLoadedState({
    required this.allTransactions,
    required this.filteredTransactions,
    required this.runningBalances,
    required this.totalDebit,
    required this.totalCredit,
    this.searchQuery = '',
    this.selectedType = 'all',
  });

  @override
  List<Object?> get props => [
        allTransactions,
        filteredTransactions,
        runningBalances,
        totalDebit,
        totalCredit,
        searchQuery,
        selectedType,
      ];
}

class LedgerErrorState extends LedgerState {
  final String message;

  const LedgerErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
