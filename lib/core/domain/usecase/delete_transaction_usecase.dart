import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../error/failures.dart';
import '../repositories/transaction_repository.dart';

@lazySingleton
class DeleteTransactionUseCase {
  final TransactionRepository repository;

  DeleteTransactionUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String transactionId) async {
    return await repository.deleteTransaction(transactionId);
  }
}
