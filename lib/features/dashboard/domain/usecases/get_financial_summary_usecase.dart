// lib/features/dashboard/domain/usecases/get_financial_summary_usecase.dart

import '../../../../core/domain/repositories/transaction_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetFinancialSummaryUseCase {
  final TransactionRepository repository;

  GetFinancialSummaryUseCase(this.repository);

  Future<Map<String, double>> call(
      {DateTime? startDate, DateTime? endDate}) async {
    return await repository.getFinancialSummary(
      startDate: startDate,
      endDate: endDate,
    );
  }
}
