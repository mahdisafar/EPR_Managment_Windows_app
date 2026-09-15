import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/personal_expense_model.dart';
import '../repositories/personal_expense_repository.dart';

@lazySingleton
class GetPersonalExpensesUseCase {
  final PersonalExpenseRepository repository;

  GetPersonalExpensesUseCase(this.repository);

  Future<Either<Failure, List<PersonalExpenseModel>>> call() async {
    return await repository.getAllExpenses();
  }
}
