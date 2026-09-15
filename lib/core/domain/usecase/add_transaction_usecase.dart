// lib/core/domain/usecases/add_transaction_usecase.dart

import '../repositories/transaction_repository.dart';
import '../../models/transaction_model.dart';

import 'package:injectable/injectable.dart';

@lazySingleton
class AddTransactionUseCase {
  final TransactionRepository repository;

  AddTransactionUseCase(this.repository);

  Future<void> call(TransactionModel transaction) async {
    return await repository.addTransaction(transaction);
  }
}
