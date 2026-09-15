import 'package:injectable/injectable.dart';
import '../../models/transaction_model.dart';
import '../repositories/transaction_repository.dart';

@lazySingleton
class GetAllTransactionsUseCase {
  final TransactionRepository repository;

  GetAllTransactionsUseCase(this.repository);

  Future<List<TransactionModel>> call() async {
    return await repository.getAllTransactions();
  }
}
