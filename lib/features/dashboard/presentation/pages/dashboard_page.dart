import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/date_filter_selector.dart';
import '../widgets/income_expense_chart.dart';
import '../widgets/quick_actions_bar.dart';
import '../widgets/summary_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const FetchDashboardSummaryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('داشبورد مدیریتی',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'IranYekan')),
                            SizedBox(height: 4),
                            Text('خلاصه وضعیت مالی و آمار کلی سیستم',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    fontFamily: 'IranYekan')),
                          ],
                        ),
                        BlocBuilder<DashboardBloc, DashboardState>(
                          builder: (context, state) {
                            final currentFilter = state is DashboardLoadedState
                                ? state.selectedFilter
                                : DateFilterType.thisMonth;
                            return DateFilterSelector(
                              selectedFilter: currentFilter,
                              onFilterSelected: (filter) {
                                context.read<DashboardBloc>().add(
                                    FetchDashboardSummaryEvent(filter: filter));
                              },
                              onCustomRangeSelected: (start, end) {
                                context.read<DashboardBloc>().add(
                                      FetchDashboardSummaryEvent(
                                        filter: DateFilterType.custom,
                                        customStartDate: start,
                                        customEndDate: end,
                                      ),
                                    );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  if (state is DashboardLoadingState) {
                    return const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()));
                  }

                  if (state is DashboardErrorState) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(state.message,
                            style: const TextStyle(
                                color: Colors.red, fontFamily: 'IranYekan')),
                      ),
                    );
                  }

                  if (state is DashboardLoadedState) {
                    final summary = state.summary;

                    return SliverList(
                      delegate: SliverChildListDelegate([
                        LayoutBuilder(builder: (context, constraints) {
                          final crossAxisCount = constraints.maxWidth > 1200
                              ? 4
                              : (constraints.maxWidth > 800 ? 2 : 1);
                          return GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 2.1,
                            children: [
                              SummaryCard(
                                title: 'مجموع درآمدها (ورودی)',
                                amount: summary['total_income'] ?? 0.0,
                                currency: 'toman',
                                icon: Icons.arrow_downward,
                                color: Colors.green,
                              ),
                              SummaryCard(
                                title: 'مجموع مصارف (خروجی)',
                                amount: summary['total_expense'] ?? 0.0,
                                currency: 'toman',
                                icon: Icons.arrow_upward,
                                color: Colors.red,
                              ),
                              SummaryCard(
                                title: 'کل طلبات (باقیات مشتریان)',
                                amount: summary['total_receivable'] ?? 0.0,
                                currency: 'toman',
                                icon: Icons.account_balance_wallet_outlined,
                                color: Colors.orange,
                              ),
                              SummaryCard(
                                title: 'سود خالص برآوردی',
                                amount: summary['net_profit'] ?? 0.0,
                                currency: 'toman',
                                icon: Icons.show_chart,
                                color: Colors.blue,
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Theme.of(context).dividerColor),
                          ),
                          child: IncomeExpenseChart(
                              monthlyData: state.monthlyData),
                        ),
                        const SizedBox(height: 16),

                        const QuickActionsBar(),
                      ]),
                    );
                  }

                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
