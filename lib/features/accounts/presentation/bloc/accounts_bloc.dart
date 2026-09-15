import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:eprwindowsapp/core/domain/usecase/get_all_customers_use_case.dart';
import 'package:eprwindowsapp/core/domain/usecase/record_account_transaction_use_case.dart';
import 'package:eprwindowsapp/core/models/account_model.dart';
import 'package:eprwindowsapp/config/enum.dart';
import 'package:eprwindowsapp/features/customer/data/models/customer_model.dart';
import '../../domain/usecases/add_accountusecase.dart';
import '../../domain/usecases/get_all_accounts_usecase.dart';

part 'accounts_event.dart';
part 'accounts_state.dart';

@injectable
class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  final GetAllAccountsUseCase getAllAccountsUseCase;
  final AddAccountUseCase addAccountUseCase;
  final RecordAccountTransactionUseCase recordAccountTransactionUseCase;
  final GetAllCustomersUseCase getAllCustomersUseCase;

  AccountsBloc({
    required this.getAllAccountsUseCase,
    required this.addAccountUseCase,
    required this.recordAccountTransactionUseCase,
    required this.getAllCustomersUseCase,
  }) : super(AccountsInitial()) {
    on<LoadAccountsEvent>(_onLoad);
    on<AddAccountEvent>(_onAddAccount);
    on<RecordAccountTransactionEvent>(_onRecordTransaction);
  }

  Future<void> _onLoad(
    LoadAccountsEvent event,
    Emitter<AccountsState> emit,
  ) async {
    emit(AccountsLoading());

    final accountsResult = await getAllAccountsUseCase();
    final customers = await getAllCustomersUseCase();

    accountsResult.fold(
      (failure) => emit(AccountsError(failure.message)),
      (accounts) =>
          emit(AccountsLoaded(accounts: accounts, customers: customers)),
    );
  }

  Future<void> _onAddAccount(
    AddAccountEvent event,
    Emitter<AccountsState> emit,
  ) async {
    final result = await addAccountUseCase.execute(account: event.account);

    await result.fold(
      (failure) async => emit(AccountsError(failure.message)),
      (_) async => add(LoadAccountsEvent()),
    );
  }

  Future<void> _onRecordTransaction(
    RecordAccountTransactionEvent event,
    Emitter<AccountsState> emit,
  ) async {
    try {
      await recordAccountTransactionUseCase.execute(
        accountId: event.accountId,
        amount: event.amount,
        type: event.type,
        title: event.title,
        details: event.details,
        documentNumber: event.documentNumber,
        customerId: event.customerId,
        currency: event.currency,
        exchangeRate: event.exchangeRate,
      );
      add(LoadAccountsEvent());
    } catch (e) {
      emit(AccountsError(e.toString()));
    }
  }
}
