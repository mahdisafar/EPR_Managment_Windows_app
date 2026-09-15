// lib/core/data/repositories/transaction_repository_impl.dart

import 'package:dartz/dartz.dart';

import '../../data/datasources/transaction_local_data_source.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../error/failures.dart' show DatabaseFailure, Failure;
import '../../models/transaction_model.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await localDataSource.insertTransaction(transaction);
    } catch (e) {
      throw Exception('خطا در ثبت معامله در دیتابیس: $e');
    }
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      return await localDataSource.getAllTransactions();
    } catch (e) {
      throw Exception('خطا در دریافت لیست معاملات روزنامه‌چه: $e');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      return await localDataSource.getTransactionsByDateRange(
          startDate, endDate);
    } catch (e) {
      throw Exception('خطا در دریافت معاملات در بازه زمانی: $e');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByReference(
      String referenceType, String referenceId) async {
    try {
      return await localDataSource.getTransactionsByReference(
          referenceType, referenceId);
    } catch (e) {
      throw Exception('خطا در دریافت معاملات مربوط به $referenceType: $e');
    }
  }

  @override
  Future<Map<String, double>> getFinancialSummary(
      {DateTime? startDate, DateTime? endDate}) async {
    try {
      return await localDataSource.getFinancialSummary(
          startDate: startDate, endDate: endDate);
    } catch (e) {
      throw Exception('خطا در محاسبه خلاصه آمار مالی: $e');
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTransaction(String id) async {
    try {
      await localDataSource.deleteTransaction(id);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure('خطا در حذف سند: $e'));
    }
  }
}
