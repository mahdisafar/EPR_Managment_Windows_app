import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:eprwindowsapp/config/enum.dart';
import 'package:eprwindowsapp/core/domain/repositories/account_repository.dart';
import 'package:eprwindowsapp/core/domain/repositories/transaction_repository.dart';
import 'package:eprwindowsapp/core/error/failures.dart';
import 'package:eprwindowsapp/core/models/transaction_model.dart';
import 'package:eprwindowsapp/core/utils/currency_converter.dart';
import '../../data/models/shipment_expense_model.dart';
import '../repositories/shipment_repository.dart';

@lazySingleton
class AddShipmentExpenseUseCase {
  final ShipmentRepository repository;
  final AccountRepository accountRepository;
  final TransactionRepository transactionRepository;

  AddShipmentExpenseUseCase(
    this.repository, {
    required this.accountRepository,
    required this.transactionRepository,
  });

  Future<Either<Failure, Unit>> call(ShipmentExpenseModel expense) async {
    var e = expense;
    if (e.currency != CurrencyType.toman && (e.exchangeRate ?? 0) > 0) {
      e = e.copyWith(
        originalAmount: e.originalAmount ?? e.amount,
        amount: CurrencyConverter.totoman(
          amount: e.originalAmount ?? e.amount,
          currency: e.currency,
          exchangeRate: e.exchangeRate!,
        ),
      );
    }

    if (e.sourceAccount.isNotEmpty) {
      final accountResult =
          await accountRepository.getAccountById(e.sourceAccount);
      final account = accountResult.fold(
        (f) => throw Exception(f.message),
        (a) => a,
      );
      if (account == null) {
        return const Left(ValidationFailure('حساب پرداخت‌کننده یافت نشد.'));
      }

      final updateResult = await accountRepository.updateAccountBalance(
        e.sourceAccount,
        account.balance - e.amount,
      );
      final updateFailed = updateResult.fold((f) => f.message, (_) => null);
      if (updateFailed != null) {
        return Left(DatabaseFailure(updateFailed));
      }
    }

    final addResult = await repository.addShipmentExpense(e);
    final addFailed = addResult.fold((f) => f.message, (_) => null);
    if (addFailed != null) {
      return Left(DatabaseFailure(addFailed));
    }

    final transaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'مصرف محموله: ${e.expenseType.name}',
      details: e.details,
      amount: e.amount,
      currency: e.currency,
      originalAmount: e.originalAmount,
      exchangeRate: e.exchangeRate,
      type: TransactionType.expense,
      referenceType: ReferenceType.shipment,
      referenceId: e.shipmentId,
      documentNumber: e.receiptNumber,
      sourceAccount: e.sourceAccount.isEmpty ? null : e.sourceAccount,
      paidToOrFrom: e.paidTo,
      date: e.date,
    );
    await transactionRepository.addTransaction(transaction);

    return const Right(unit);
  }
}
