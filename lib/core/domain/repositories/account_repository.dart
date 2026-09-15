import 'package:dartz/dartz.dart';
import '../../error/failures.dart';
import '../../models/account_model.dart';

abstract class AccountRepository {
  Future<Either<Failure, Unit>> addAccount(AccountModel account);
  Future<Either<Failure, AccountModel?>> getAccountById(String id);
  Future<Either<Failure, List<AccountModel>>> getAllAccounts();
  Future<Either<Failure, Unit>> updateAccountBalance(
      String accountId, double newBalance);
}
