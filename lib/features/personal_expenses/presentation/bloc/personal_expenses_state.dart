part of 'personal_expenses_bloc.dart';

abstract class PersonalExpensesState extends Equatable {
  const PersonalExpensesState();

  @override
  List<Object> get props => [];
}

class PersonalExpensesInitial extends PersonalExpensesState {}

class PersonalExpensesLoading extends PersonalExpensesState {}

class PersonalExpensesLoaded extends PersonalExpensesState {
  final List<PersonalExpenseModel> allExpenses;
  final List<PersonalExpenseModel> filteredExpenses;
  final List<AccountModel> accounts;
  final String query;

  const PersonalExpensesLoaded({
    required this.allExpenses,
    required this.filteredExpenses,
    required this.accounts,
    this.query = '',
  });

  double get totalFiltered =>
      filteredExpenses.fold(0.0, (sum, e) => sum + e.totalAmount);

  @override
  List<Object> get props => [allExpenses, filteredExpenses, accounts, query];
}

class PersonalExpensesError extends PersonalExpensesState {
  final String message;

  const PersonalExpensesError(this.message);

  @override
  List<Object> get props => [message];
}
