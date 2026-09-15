import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:eprwindowsapp/core/domain/usecase/get_all_accounts_usecase.dart';
import 'package:eprwindowsapp/core/models/account_model.dart';
import '../../data/models/personal_expense_model.dart';
import '../../domain/usecases/add_personal_expense_usecase.dart';
import '../../domain/usecases/get_personal_expenses_usecase.dart';

part 'personal_expenses_event.dart';
part 'personal_expenses_state.dart';

@injectable
class PersonalExpensesBloc
    extends Bloc<PersonalExpensesEvent, PersonalExpensesState> {
  final GetPersonalExpensesUseCase getPersonalExpensesUseCase;
  final AddPersonalExpenseUseCase addPersonalExpenseUseCase;
  final GetAllAccountsUseCase getAllAccountsUseCase;

  PersonalExpensesBloc({
    required this.getPersonalExpensesUseCase,
    required this.addPersonalExpenseUseCase,
    required this.getAllAccountsUseCase,
  }) : super(PersonalExpensesInitial()) {
    on<LoadPersonalExpensesEvent>(_onLoad);
    on<SearchPersonalExpensesEvent>(_onSearch);
    on<AddPersonalExpenseEvent>(_onAdd);
  }

  Future<void> _onLoad(
    LoadPersonalExpensesEvent event,
    Emitter<PersonalExpensesState> emit,
  ) async {
    emit(PersonalExpensesLoading());

    final expensesResult = await getPersonalExpensesUseCase();
    final accountsResult = await getAllAccountsUseCase();

    accountsResult.fold(
      (failure) => emit(PersonalExpensesError(failure.message)),
      (accounts) => expensesResult.fold(
        (failure) => emit(PersonalExpensesError(failure.message)),
        (expenses) => emit(PersonalExpensesLoaded(
          allExpenses: expenses,
          filteredExpenses: expenses,
          accounts: accounts,
        )),
      ),
    );
  }

  void _onSearch(
    SearchPersonalExpensesEvent event,
    Emitter<PersonalExpensesState> emit,
  ) {
    if (state is! PersonalExpensesLoaded) return;
    final current = state as PersonalExpensesLoaded;

    final query = event.query.trim().toLowerCase();
    final filtered = query.isEmpty
        ? current.allExpenses
        : current.allExpenses.where((e) {
            return e.itemName.toLowerCase().contains(query) ||
                e.category.toLowerCase().contains(query);
          }).toList();

    emit(PersonalExpensesLoaded(
      allExpenses: current.allExpenses,
      filteredExpenses: filtered,
      accounts: current.accounts,
      query: event.query,
    ));
  }

  Future<void> _onAdd(
    AddPersonalExpenseEvent event,
    Emitter<PersonalExpensesState> emit,
  ) async {
    final result = await addPersonalExpenseUseCase.execute(
      expense: event.expense,
    );

    await result.fold(
      (failure) async => emit(PersonalExpensesError(failure.message)),
      (_) async => add(LoadPersonalExpensesEvent()),
    );
  }
}
