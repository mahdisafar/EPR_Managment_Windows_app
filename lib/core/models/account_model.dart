import 'package:eprwindowsapp/core/database/table_constants.dart';
import 'package:eprwindowsapp/config/enum.dart';
import 'package:equatable/equatable.dart';

class AccountModel extends Equatable {
  final String id;
  final String accountName;
  final AccountType accountType;
  final double balance;
  final CurrencyType currency;

  const AccountModel({
    required this.id,
    required this.accountName,
    required this.accountType,
    this.balance = 0.0,
    this.currency = CurrencyType.toman,
  });

  AccountModel copyWith({
    String? id,
    String? accountName,
    AccountType? accountType,
    double? balance,
    CurrencyType? currency,
  }) {
    return AccountModel(
      id: id ?? this.id,
      accountName: accountName ?? this.accountName,
      accountType: accountType ?? this.accountType,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      TableConstants.columnId: id,
      TableConstants.colAccountName: accountName,
      TableConstants.colAccountType: accountType.name,
      TableConstants.colBalance: balance,
      TableConstants.colCurrency: currency.name,
    };
  }

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      id: map[TableConstants.columnId] as String,
      accountName: map[TableConstants.colAccountName] as String,
      accountType: AccountType.values.byName(
        map[TableConstants.colAccountType] as String? ?? 'cash',
      ),
      balance: (map[TableConstants.colBalance] as num).toDouble(),
      currency: CurrencyType.values.byName(
        map[TableConstants.colCurrency] as String? ?? 'toman',
      ),
    );
  }

  @override
  List<Object?> get props => [
        id,
        accountName,
        accountType,
        balance,
        currency,
      ];
}
