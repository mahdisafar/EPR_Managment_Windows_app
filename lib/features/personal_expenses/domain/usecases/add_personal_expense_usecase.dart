import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:eprwindowsapp/core/domain/repositories/account_repository.dart';
import 'package:eprwindowsapp/core/domain/repositories/transaction_repository.dart';
import 'package:eprwindowsapp/core/error/failures.dart';

import 'package:eprwindowsapp/core/models/transaction_model.dart';
import 'package:eprwindowsapp/core/utils/currency_converter.dart';
import '../../../../config/enum.dart';
import '../../data/models/personal_expense_model.dart';
import '../repositories/personal_expense_repository.dart';

@lazySingleton
class AddPersonalExpenseUseCase {
  final PersonalExpenseRepository personalExpenseRepository;
  final AccountRepository accountRepository;
  final TransactionRepository transactionRepository;

  AddPersonalExpenseUseCase({
    required this.personalExpenseRepository,
    required this.accountRepository,
    required this.transactionRepository,
  });

  Future<Either<Failure, Unit>> execute({
    required PersonalExpenseModel expense,
  }) async {
    final original = expense.originalAmount ?? expense.totalAmount;
    final tomanTotal = CurrencyConverter.totoman(
      amount: original,
      currency: expense.currency,
      exchangeRate: expense.exchangeRate ?? 1.0,
    );
    final e =
        expense.copyWith(originalAmount: original, totalAmount: tomanTotal);

    if (e.itemName.trim().isEmpty) {
      return const Left(ValidationFailure('نام مورد نمی‌تواند خالی باشد.'));
    }
    if (original <= 0) {
      return const Left(ValidationFailure('مبلغ کل باید بزرگ‌تر از صفر باشد.'));
    }
    if (e.accountId == null || e.accountId!.isEmpty) {
      return const Left(ValidationFailure('انتخاب حساب مبدأ الزامی است.'));
    }

    final accountResult = await accountRepository.getAccountById(e.accountId!);
    final account = accountResult.fold(
      (f) => throw Exception(f.message),
      (a) => a,
    );
    if (account == null) {
      return const Left(ValidationFailure('حساب مبدأ یافت نشد.'));
    }

    final updateResult = await accountRepository.updateAccountBalance(
      e.accountId!,
      account.balance - tomanTotal,
    );
    final updateFailed = updateResult.fold((f) => f.message, (_) => null);
    if (updateFailed != null) {
      return Left(DatabaseFailure(updateFailed));
    }

    final addResult = await personalExpenseRepository.addExpense(e);
    final addFailed = addResult.fold((f) => f.message, (_) => null);
    if (addFailed != null) {
      return Left(DatabaseFailure(addFailed));
    }

    final transaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'مصرف شخصی: ${e.itemName}',
      details: e.notes,
      amount: tomanTotal,
      currency: e.currency,
      originalAmount: original,
      exchangeRate: e.exchangeRate,
      type: TransactionType.expense,
      referenceType: ReferenceType.general,
      referenceId: e.id,
      documentNumber: e.receiptNumber,
      sourceAccount: e.accountId,
      date: e.date,
    );
    await transactionRepository.addTransaction(transaction);

    return const Right(unit);
  }
}
