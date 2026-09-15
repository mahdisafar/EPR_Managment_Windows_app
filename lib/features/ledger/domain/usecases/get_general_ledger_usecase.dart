// lib/features/ledger/domain/usecases/get_general_ledger_usecase.dart

import '../../../../core/domain/repositories/transaction_repository.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/models/transaction_model.dart';

@lazySingleton
class GetGeneralLedgerUseCase {
  final TransactionRepository repository;

  GetGeneralLedgerUseCase(this.repository);

  Future<List<TransactionModel>> call() async {
    return await repository.getAllTransactions();
  }
}
