import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/personal_expense_repository.dart';
import '../datasources/personal_expense_local_data_source.dart';
import '../models/personal_expense_model.dart';

@LazySingleton(as: PersonalExpenseRepository)
class PersonalExpenseRepositoryImpl implements PersonalExpenseRepository {
  final PersonalExpenseLocalDataSource localDataSource;

  PersonalExpenseRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Unit>> addExpense(PersonalExpenseModel expense) async {
    try {
      await localDataSource.insertExpense(expense);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure('خطا در ثبت مصرف شخصی: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PersonalExpenseModel>>> getAllExpenses() async {
    try {
      final expenses = await localDataSource.getAllExpenses();
      return Right(expenses);
    } catch (e) {
      return Left(DatabaseFailure('خطا در دریافت مصارف شخصی: $e'));
    }
  }
}
