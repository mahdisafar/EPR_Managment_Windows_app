import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/personal_expense_model.dart';

abstract class PersonalExpenseRepository {
  Future<Either<Failure, Unit>> addExpense(PersonalExpenseModel expense);
  Future<Either<Failure, List<PersonalExpenseModel>>> getAllExpenses();
}
