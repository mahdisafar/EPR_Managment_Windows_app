import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/account_model.dart';
import '../../../../core/domain/repositories/account_repository.dart';

@lazySingleton
class AddAccountUseCase {
  final AccountRepository repository;

  AddAccountUseCase(this.repository);

  Future<Either<Failure, Unit>> execute({required AccountModel account}) async {
    if (account.accountName.trim().isEmpty) {
      return const Left(ValidationFailure('نام حساب نمی‌تواند خالی باشد.'));
    }
    return await repository.addAccount(account);
  }
}
