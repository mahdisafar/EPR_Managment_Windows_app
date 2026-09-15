import 'package:eprwindowsapp/features/ledger/presentation/widgets/ledger_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/excel_export_button.dart';
import '../bloc/ledger_bloc.dart';
import '../widgets/ledger_summary_bar.dart' show LedgerSummaryBar;
import '../widgets/ledger_table.dart';

class LedgerPage extends StatefulWidget {
  const LedgerPage({super.key});

  @override
  State<LedgerPage> createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage> {
  @override
  void initState() {
    super.initState();
    context.read<LedgerBloc>().add(const FetchLedgerTransactionsEvent());
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
              // Header & Search Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'دفتر روزنامه (Ledger)',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'IranYekan',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'مشاهده و مرور کلیه ریز تراکنش‌ها و اسناد مالی ثبت شده',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontFamily: 'IranYekan',
                        ),
                      ),
                    ],
                  ),
                  LedgerSearchBar(
                    onSearch: (query) => context.read<LedgerBloc>().add(
                          FetchLedgerTransactionsEvent(searchQuery: query),
                        ),
                  ),
                  SizedBox(height: 4),
                  ExcelExportButton(
                    fileName: 'دفتر_روزانه',
                    headers: [
                      'تاریخ',
                      'شماره سند',
                      'عنوان',
                      'مرجع',
                      'مبلغ',
                      'توضیحات'
                    ],
                    rowsBuilder: () {
                      final s = context.read<LedgerBloc>().state;
                      if (s is! LedgerLoadedState) return [];
                      return s.filteredTransactions
                          .map((tx) => [
                                tx.date.toIso8601String(),
                                tx.documentNumber ?? '',
                                tx.title,
                                tx.referenceType.name,
                                tx.amount,
                                tx.details ?? '',
                              ])
                          .toList();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Body
              Expanded(
                child: BlocBuilder<LedgerBloc, LedgerState>(
                  builder: (context, state) {
                    if (state is LedgerLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is LedgerErrorState) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(
                            color: Colors.red,
                            fontFamily: 'IranYekan',
                          ),
                        ),
                      );
                    }

                    if (state is LedgerLoadedState) {
                      return Column(
                        children: [
                          LedgerSummaryBar(
                            transactionCount: state.filteredTransactions.length,
                            totalCredit: state.totalCredit,
                            totalDebit: state.totalDebit,
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: LedgerTable(
                              transactions: state.filteredTransactions,
                              runningBalances: state.runningBalances,
                            ),
                          ),
                        ],
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
