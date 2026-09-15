part of 'personal_expenses_bloc.dart';

abstract class PersonalExpensesEvent extends Equatable {
  const PersonalExpensesEvent();

  @override
  List<Object> get props => [];
}

class LoadPersonalExpensesEvent extends PersonalExpensesEvent {}

class SearchPersonalExpensesEvent extends PersonalExpensesEvent {
  final String query;

  const SearchPersonalExpensesEvent(this.query);

  @override
  List<Object> get props => [query];
}

class AddPersonalExpenseEvent extends PersonalExpensesEvent {
  final PersonalExpenseModel expense;

  const AddPersonalExpenseEvent(this.expense);

  @override
  List<Object> get props => [expense];
}
