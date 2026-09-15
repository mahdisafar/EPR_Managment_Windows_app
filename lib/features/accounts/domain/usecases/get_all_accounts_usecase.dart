import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/account_model.dart';
import '../../../../core/domain/repositories/account_repository.dart';

@lazySingleton
class GetAllAccountsUseCase {
  final AccountRepository repository;

  GetAllAccountsUseCase(this.repository);

  Future<Either<Failure, List<AccountModel>>> call() async {
    return await repository.getAllAccounts();
  }
}
