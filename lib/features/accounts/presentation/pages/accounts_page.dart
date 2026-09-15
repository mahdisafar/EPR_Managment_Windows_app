import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eprwindowsapp/config/enum.dart';
import '../bloc/accounts_bloc.dart';
import '../widgets/account_list_table.dart';
import '../widgets/add_account_dialog.dart';
import '../widgets/record_transaction_dialog.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AccountsBloc>().add(LoadAccountsEvent());
  }

  void _openAddAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AddAccountDialog(
        onSubmit: (account) {
          context.read<AccountsBloc>().add(AddAccountEvent(account));
        },
      ),
    );
  }

  void _openRecordDialog(BuildContext context, bool isReceipt) {
    final state = context.read<AccountsBloc>().state;
    if (state is! AccountsLoaded) return;

    showDialog(
      context: context,
      builder: (dialogContext) => RecordTransactionDialog(
        isReceipt: isReceipt,
        accounts: state.accounts,
        customers: state.customers,
        onSubmit: ({
          required accountId,
          required amount,
          required title,
          details,
          required documentNumber,
          customerId,
          required currency,
          required exchangeRate,
        }) {
          context.read<AccountsBloc>().add(RecordAccountTransactionEvent(
                accountId: accountId,
                amount: amount,
                type: isReceipt
                    ? TransactionType.income
                    : TransactionType.expense,
                title: title,
                details: details,
                documentNumber: documentNumber,
                customerId: customerId,
                currency: currency,
                exchangeRate: exchangeRate,
              ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('مدیریت حساب‌ها',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'IranYekan')),
                      SizedBox(height: 4),
                      Text('صندوق، بانک و باقیات — ثبت رسید و برداشت',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontFamily: 'IranYekan')),
                    ],
                  ),
                  Row(children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      onPressed: () => _openRecordDialog(context, true),
                      icon: const Icon(Icons.download, size: 18),
                      label: const Text('ثبت رسید',
                          style: TextStyle(fontFamily: 'IranYekan')),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      onPressed: () => _openRecordDialog(context, false),
                      icon: const Icon(Icons.upload, size: 18),
                      label: const Text('ثبت برداشت',
                          style: TextStyle(fontFamily: 'IranYekan')),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      onPressed: () => _openAddAccountDialog(context),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('حساب جدید',
                          style: TextStyle(fontFamily: 'IranYekan')),
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 20),

              // Total Balance Bar
              BlocBuilder<AccountsBloc, AccountsState>(
                builder: (context, state) {
                  if (state is AccountsLoaded) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Theme.of(context).dividerColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('مجموع بیلانس همه حساب‌ها:',
                              style: TextStyle(
                                  fontFamily: 'IranYekan', color: Colors.grey)),
                          Text(
                            '${state.totalBalance.toStringAsFixed(0)}   toman',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: state.totalBalance >= 0
                                  ? Colors.green.shade800
                                  : Colors.red.shade800,
                              fontFamily: 'IranYekan',
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 16),

              // Table
              Expanded(
                child: BlocConsumer<AccountsBloc, AccountsState>(
                  listener: (context, state) {
                    if (state is AccountsError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message,
                              style: const TextStyle(fontFamily: 'IranYekan')),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is AccountsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is AccountsLoaded) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Theme.of(context).dividerColor),
                        ),
                        child: AccountListTable(accounts: state.accounts),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
