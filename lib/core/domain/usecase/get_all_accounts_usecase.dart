import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../error/failures.dart';
import '../../models/account_model.dart';
import '../repositories/account_repository.dart';

@lazySingleton
class GetAllAccountsUseCase {
  final AccountRepository repository;

  GetAllAccountsUseCase(this.repository);

  Future<Either<Failure, List<AccountModel>>> call() async {
    return await repository.getAllAccounts();
  }
}
