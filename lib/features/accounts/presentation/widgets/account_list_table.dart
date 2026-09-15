import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:eprwindowsapp/core/models/account_model.dart';
import 'package:eprwindowsapp/config/enum.dart';

class AccountListTable extends StatelessWidget {
  final List<AccountModel> accounts;

  const AccountListTable({super.key, required this.accounts});

  static String typeLabel(AccountType type) {
    switch (type) {
      case AccountType.cash:
        return 'صندوق';
      case AccountType.bank:
        return 'بانک';
      case AccountType.payableReceivable:
        return 'باقیات';
    }
  }

  static String currencyLabel(CurrencyType c) {
    switch (c) {
      case CurrencyType.toman:
        return 'tomana';
      case CurrencyType.usd:
        return 'USD';
      case CurrencyType.pkr:
        return 'PKR';
      case CurrencyType.irr:
        return 'IRR';
      case CurrencyType.eur:
        return 'Euro';
    }
  }

  static const TextStyle _headerStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'IranYekan',
    fontSize: 12,
  );

  @override
  Widget build(BuildContext context) {
    final formatter = intl.NumberFormat('#,##0.##', 'fa_IR');

    if (accounts.isEmpty) {
      return const Center(
        child: Text('هیچ حسابی ثبت نشده است.',
            style: TextStyle(fontFamily: 'IranYekan', color: Colors.grey)),
      );
    }

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
          headingRowHeight: 48,
          columns: const [
            DataColumn(label: Text('نام حساب', style: _headerStyle)),
            DataColumn(label: Text('نوع حساب', style: _headerStyle)),
            DataColumn(label: Text('بیلانس فعلی', style: _headerStyle)),
            DataColumn(label: Text('واحد پول', style: _headerStyle)),
          ],
          rows: accounts.map((account) {
            final isNegative = account.balance < 0;
            return DataRow(cells: [
              DataCell(Text(account.accountName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontFamily: 'IranYekan'))),
              DataCell(Chip(
                label: Text(typeLabel(account.accountType),
                    style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontFamily: 'IranYekan')),
                backgroundColor: account.accountType == AccountType.cash
                    ? Colors.green
                    : (account.accountType == AccountType.bank
                        ? Colors.blue
                        : Colors.orange),
                visualDensity: VisualDensity.compact,
              )),
              DataCell(Text(
                formatter.format(account.balance),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isNegative ? Colors.red.shade700 : Colors.black87,
                  fontFamily: 'IranYekan',
                ),
              )),
              DataCell(Text(currencyLabel(account.currency),
                  style: const TextStyle(fontFamily: 'IranYekan'))),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
