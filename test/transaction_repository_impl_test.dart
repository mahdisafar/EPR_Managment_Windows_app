// test/core/data/repositories/transaction_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:eprwindowsapp/core/data/datasources/transaction_local_data_source.dart';
import 'package:eprwindowsapp/core/data/repositories/transaction_repository_impl.dart';
import 'package:eprwindowsapp/core/models/transaction_model.dart';
import 'package:eprwindowsapp/config/enum.dart';

class MockTransactionLocalDataSource extends Mock
    implements TransactionLocalDataSource {}

void main() {
  late TransactionRepositoryImpl repository;
  late MockTransactionLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockTransactionLocalDataSource();
    repository = TransactionRepositoryImpl(localDataSource: mockDataSource);
  });

  final tDate = DateTime(2026, 9, 10);
  final tTransaction = TransactionModel(
    id: 'tx_101',
    title: 'فروش پسته به مشتری',
    amount: 15000.0,
    type: TransactionType.income,
    referenceType: ReferenceType.customer,
    referenceId: 'cust_001',
    date: tDate,
  );

  group('getAllTransactions', () {
    test('باید لیست تمام معاملات را از داتاسورس محلی دریافت و برگرداند',
        () async {
      // Arrange
      when(() => mockDataSource.getAllTransactions())
          .thenAnswer((_) async => [tTransaction]);

      // Act
      final result = await repository.getAllTransactions();

      // Assert
      expect(result, equals([tTransaction]));
      verify(() => mockDataSource.getAllTransactions()).called(1);
    });
  });

  group('addTransaction', () {
    test('باید متد insertTransaction را روی داتاسورس صدا بزند', () async {
      // Arrange
      when(() => mockDataSource.insertTransaction(tTransaction))
          .thenAnswer((_) async => Future.value());

      // Act
      await repository.addTransaction(tTransaction);

      // Assert
      verify(() => mockDataSource.insertTransaction(tTransaction)).called(1);
    });
  });

  group('getFinancialSummary', () {
    test('باید آمار مالی صحیح را از داتاسورس برگرداند', () async {
      // Arrange
      final tSummary = {
        'totalIncome': 50000.0,
        'totalExpense': 20000.0,
        'netBalance': 30000.0,
      };
      when(() => mockDataSource.getFinancialSummary(
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          )).thenAnswer((_) async => tSummary);

      // Act
      final result = await repository.getFinancialSummary();

      // Assert
      expect(result, equals(tSummary));
      expect(result['netBalance'], equals(30000.0));
      verify(() => mockDataSource.getFinancialSummary()).called(1);
    });
  });
}
