part of 'accounts_bloc.dart';

abstract class AccountsEvent extends Equatable {
  const AccountsEvent();

  @override
  List<Object> get props => [];
}

class LoadAccountsEvent extends AccountsEvent {}

class AddAccountEvent extends AccountsEvent {
  final AccountModel account;

  const AddAccountEvent(this.account);

  @override
  List<Object> get props => [account];
}

class RecordAccountTransactionEvent extends AccountsEvent {
  final String accountId;
  final double amount;
  final TransactionType type;
  final String title;
  final String? details;
  final String documentNumber;
  final String? customerId;
  final CurrencyType currency;
  final double exchangeRate;

  const RecordAccountTransactionEvent({
    required this.accountId,
    required this.amount,
    required this.type,
    required this.title,
    this.details,
    required this.documentNumber,
    this.customerId,
    this.currency = CurrencyType.toman,
    this.exchangeRate = 1.0,
  });

  @override
  List<Object> get props =>
      [accountId, amount, type, title, documentNumber, currency, exchangeRate];
}
