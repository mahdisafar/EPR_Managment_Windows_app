import '../../../config/enum.dart';
import '../../../features/customer/domain/repositories/customer_repository.dart';
import '../../models/transaction_model.dart';
import '../repositories/account_repository.dart';
import '../repositories/transaction_repository.dart';
import 'package:eprwindowsapp/core/utils/currency_converter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RecordAccountTransactionUseCase {
  final AccountRepository accountRepository;
  final CustomerRepository customerRepository;
  final TransactionRepository transactionRepository;

  RecordAccountTransactionUseCase({
    required this.accountRepository,
    required this.customerRepository,
    required this.transactionRepository,
  });

  Future<void> execute({
    required String accountId,
    required double amount,
    required TransactionType type,
    required String title,
    String? details,
    required String documentNumber,
    String? customerId,
    CurrencyType currency = CurrencyType.toman,
    double exchangeRate = 1.0,
  }) async {
    final tomanAmount = CurrencyConverter.totoman(
      amount: amount,
      currency: currency,
      exchangeRate: exchangeRate,
    );

    final accountResult = await accountRepository.getAccountById(accountId);
    final account = accountResult.fold(
      (failure) => throw Exception(failure.message),
      (a) => a,
    );
    if (account == null) throw Exception('حساب مورد نظر یافت نشد.');

    final double newAccountBalance =
        (type == TransactionType.income || type == TransactionType.debit)
            ? account.balance + tomanAmount
            : account.balance - tomanAmount;

    final updateResult = await accountRepository.updateAccountBalance(
        accountId, newAccountBalance);
    updateResult.fold(
      (failure) => throw Exception(failure.message),
      (_) {},
    );

    if (customerId != null && customerId.isNotEmpty) {
      final customer = await customerRepository.getCustomerById(customerId);
      if (customer != null) {
        final double newCustomerBalance =
            (type == TransactionType.income || type == TransactionType.debit)
                ? customer.balance - tomanAmount
                : customer.balance + tomanAmount;
        await customerRepository.updateCustomerBalance(
            customerId, newCustomerBalance);
      }
    }

    final transaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      details: details,
      amount: tomanAmount,
      currency: currency,
      originalAmount: currency == CurrencyType.toman ? null : amount,
      exchangeRate: currency == CurrencyType.toman ? null : exchangeRate,
      type: type,
      referenceType: customerId != null && customerId.isNotEmpty
          ? ReferenceType.customer
          : ReferenceType.general,
      referenceId: customerId,
      documentNumber: documentNumber,
      sourceAccount: accountId,
      paidToOrFrom: customerId,
      date: DateTime.now(),
    );
    await transactionRepository.addTransaction(transaction);
  }
}
