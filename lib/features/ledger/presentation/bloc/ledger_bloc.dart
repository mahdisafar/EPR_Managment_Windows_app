import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/models/transaction_model.dart';
import 'package:eprwindowsapp/config/enum.dart';
import '../../domain/usecases/get_general_ledger_usecase.dart';

part 'ledger_event.dart';
part 'ledger_state.dart';

@injectable
class LedgerBloc extends Bloc<LedgerEvent, LedgerState> {
  final GetGeneralLedgerUseCase getGeneralLedgerUseCase;

  LedgerBloc({
    required this.getGeneralLedgerUseCase,
  }) : super(LedgerInitialState()) {
    on<FetchLedgerTransactionsEvent>(_onFetchTransactions);
  }

  Future<void> _onFetchTransactions(
    FetchLedgerTransactionsEvent event,
    Emitter<LedgerState> emit,
  ) async {
    emit(LedgerLoadingState());

    try {
      final transactions = await getGeneralLedgerUseCase();

      List<TransactionModel> filtered = List.from(transactions);

      if (event.searchQuery != null && event.searchQuery!.trim().isNotEmpty) {
        final query = event.searchQuery!.toLowerCase();
        filtered = filtered.where((tx) {
          final titleMatch = tx.title.toLowerCase().contains(query);
          final docMatch =
              tx.documentNumber?.toLowerCase().contains(query) ?? false;
          final detailsMatch =
              tx.details?.toLowerCase().contains(query) ?? false;
          return titleMatch || docMatch || detailsMatch;
        }).toList();
      }

      if (event.typeFilter != null && event.typeFilter != 'all') {
        filtered =
            filtered.where((tx) => tx.type.name == event.typeFilter).toList();
      }

      double totalCredit = 0.0;
      double totalDebit = 0.0;
      for (var tx in filtered) {
        if (tx.type == TransactionType.expense) {
          totalDebit += tx.amount;
        } else {
          totalCredit += tx.amount;
        }
      }

      final sortedAsc = List<TransactionModel>.from(filtered)
        ..sort((a, b) => a.date.compareTo(b.date));
      final runningBalances = <String, double>{};
      double balance = 0.0;
      for (var tx in sortedAsc) {
        if (tx.type == TransactionType.expense) {
          balance -= tx.amount;
        } else {
          balance += tx.amount;
        }
        runningBalances[tx.id] = balance;
      }

      emit(LedgerLoadedState(
        allTransactions: transactions,
        filteredTransactions: filtered,
        runningBalances: runningBalances,
        totalCredit: totalCredit,
        totalDebit: totalDebit,
        searchQuery: event.searchQuery ?? '',
        selectedType: event.typeFilter ?? 'all',
      ));
    } catch (e) {
      emit(LedgerErrorState("خطا در بارگذاری دفتر روزنامه: ${e.toString()}"));
    }
  }
}
