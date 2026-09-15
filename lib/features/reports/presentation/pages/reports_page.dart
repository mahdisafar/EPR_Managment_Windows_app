import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eprwindowsapp/core/widgets/excel_export_button.dart';
import 'package:eprwindowsapp/features/dashboard/presentation/widgets/date_filter_selector.dart';
import 'package:eprwindowsapp/features/dashboard/presentation/widgets/summary_card.dart';
import '../bloc/reports_bloc.dart';
import '../widgets/customer_balance_table.dart';
import '../widgets/profit_loss_table.dart';
import '../widgets/shipment_cost_summary_table.dart';
import 'package:eprwindowsapp/features/dashboard/presentation/widgets/income_expense_chart.dart'
    show IncomeExpenseChart;
import 'package:eprwindowsapp/features/dashboard/presentation/bloc/dashboard_bloc.dart'
    show MonthlyFinanceData, DateFilterType;

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ReportsBloc>().add(const FetchProfitLossReportEvent());
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
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('گزارش‌ها',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'IranYekan')),
                      SizedBox(height: 4),
                      Text('گزارش کامل مالی: سود و زیان، مشتریان و محموله‌ها',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontFamily: 'IranYekan')),
                    ],
                  ),
                  Row(children: [
                    BlocBuilder<ReportsBloc, ReportsState>(
                      builder: (context, state) {
                        final current = state is ReportsLoaded
                            ? state.selectedFilter
                            : DateFilterType.thisMonth;
                        return DateFilterSelector(
                          selectedFilter: current,
                          onFilterSelected: (filter) {
                            context.read<ReportsBloc>().add(
                                FetchProfitLossReportEvent(filter: filter));
                          },
                          onCustomRangeSelected: (start, end) {
                            context.read<ReportsBloc>().add(
                                  FetchProfitLossReportEvent(
                                    filter: DateFilterType.custom,
                                    customStartDate: start,
                                    customEndDate: end,
                                  ),
                                );
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    ExcelExportButton(
                      fileName: 'گزارش_سود_و_زیان',
                      headers: ['شرح', 'مبلغ (toman)'],
                      rowsBuilder: () {
                        final s = context.read<ReportsBloc>().state;
                        if (s is! ReportsLoaded) return [];
                        final r = s.report;
                        return [
                          ['درآمد فروش', r.totalSalesRevenue],
                          ['بهای تمام‌شده کالا', r.totalCostOfGoodsSold],
                          ['سود ناخالص', r.grossProfit],
                          ['مصارف عملیاتی', r.totalOperatingExpenses],
                          [
                            r.netProfitOrLoss >= 0 ? 'سود خالص' : 'زیان خالص',
                            r.netProfitOrLoss
                          ],
                        ];
                      },
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 20),

              Expanded(
                child: BlocBuilder<ReportsBloc, ReportsState>(
                  builder: (context, state) {
                    if (state is ReportsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is ReportsError) {
                      return Center(
                          child: Text(state.message,
                              style: const TextStyle(
                                  color: Colors.red, fontFamily: 'IranYekan')));
                    }
                    if (state is! ReportsLoaded) {
                      return const SizedBox.shrink();
                    }

                    final report = state.report;

                    return ListView(
                      children: [
                        LayoutBuilder(builder: (context, c) {
                          final n = c.maxWidth > 1200
                              ? 4
                              : (c.maxWidth > 800 ? 2 : 1);
                          return GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: n,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 2.1,
                            children: [
                              SummaryCard(
                                  title: 'درآمد فروش',
                                  amount: report.totalSalesRevenue,
                                  currency: 'toman',
                                  icon: Icons.payments_outlined,
                                  color: Colors.green),
                              SummaryCard(
                                  title: 'بهای تمام‌شده کالا',
                                  amount: report.totalCostOfGoodsSold,
                                  currency: 'toman',
                                  icon: Icons.inventory_2_outlined,
                                  color: Colors.red),
                              SummaryCard(
                                  title: 'سود ناخالص',
                                  amount: report.grossProfit,
                                  currency: 'toman',
                                  icon: Icons.trending_up,
                                  color: Colors.blue),
                              SummaryCard(
                                  title: report.netProfitOrLoss >= 0
                                      ? 'سود خالص'
                                      : 'زیان خالص',
                                  amount: report.netProfitOrLoss,
                                  currency: 'toman',
                                  icon: report.netProfitOrLoss >= 0
                                      ? Icons.emoji_emotions_outlined
                                      : Icons.sentiment_dissatisfied_outlined,
                                  color: report.netProfitOrLoss >= 0
                                      ? Colors.teal
                                      : Colors.deepOrange),
                            ],
                          );
                        }),
                        const SizedBox(height: 16),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Theme.of(context).dividerColor),
                                ),
                                child: IncomeExpenseChart(
                                  monthlyData: [
                                    for (final m in state.monthlyData)
                                      MonthlyFinanceData(
                                        month: m.month,
                                        income: m.income,
                                        expense: m.expense,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Theme.of(context).dividerColor),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('مانده حساب مشتریان',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'IranYekan')),
                                    const SizedBox(height: 8),
                                    CustomerBalanceTable(
                                        rows: state.customerBalances),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Theme.of(context).dividerColor),
                          ),
                          child: ProfitLossTable(report: report),
                        ),
                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Theme.of(context).dividerColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('خلاصه هزینه محموله‌ها',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'IranYekan')),
                              const SizedBox(height: 8),
                              ShipmentCostSummaryTable(
                                  rows: state.shipmentSummaries),
                            ],
                          ),
                        ),
                      ],
                    );
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
