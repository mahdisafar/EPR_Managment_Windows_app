// lib/core/domain/repositories/transaction_repository.dart

import 'package:dartz/dartz.dart' show Either, Unit;

import '../../error/failures.dart';
import '../../models/transaction_model.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(TransactionModel transaction);

  Future<List<TransactionModel>> getAllTransactions();

  Future<List<TransactionModel>> getTransactionsByDateRange(
      DateTime startDate, DateTime endDate);

  Future<List<TransactionModel>> getTransactionsByReference(
      String referenceType, String referenceId);

  Future<Map<String, double>> getFinancialSummary(
      {DateTime? startDate, DateTime? endDate});
}
