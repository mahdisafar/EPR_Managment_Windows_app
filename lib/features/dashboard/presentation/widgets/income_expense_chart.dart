import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shamsi_date/shamsi_date.dart';
import '../bloc/dashboard_bloc.dart';

class IncomeExpenseChart extends StatelessWidget {
  final List<MonthlyFinanceData> monthlyData;

  const IncomeExpenseChart({super.key, required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    final formatter = intl.NumberFormat('#,##0', 'fa_IR');
    double maxVal = 0;
    for (final d in monthlyData) {
      if (d.income > maxVal) maxVal = d.income;
      if (d.expense > maxVal) maxVal = d.expense;
    }

    String monthName(DateTime d) =>
        Jalali.fromDateTime(d).formatter.mN;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('درآمد در برابر هزینه (۶ ماه اخیر)',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IranYekan')),
            Row(children: [
              _legend(Colors.green, 'درآمد'),
              const SizedBox(width: 16),
              _legend(Colors.red.shade400, 'هزینه'),
            ]),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 260,
          child: BarChart(
            BarChartData(
              maxY: maxVal == 0 ? 100 : maxVal * 1.2,
              barGroups: List.generate(monthlyData.length, (i) {
                final d = monthlyData[i];
                return BarChartGroupData(
                  x: i,
                  barsSpace: 6,
                  barRods: [
                    BarChartRodData(
                      toY: d.income,
                      color: Colors.green,
                      width: 14,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                    BarChartRodData(
                      toY: d.expense,
                      color: Colors.red.shade400,
                      width: 14,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                );
              }),
              titlesData: FlTitlesData(
                show: true,
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= monthlyData.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          monthName(monthlyData[i].month),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            fontFamily: 'IranYekan',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxVal == 0 ? 50 : maxVal / 4,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: Colors.grey.shade200,
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final d = monthlyData[group.x];
                    return BarTooltipItem(
                      '${monthName(d.month)}\n',
                      const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'IranYekan',
                          color: Colors.white),
                      children: [
                        TextSpan(
                          text:
                              '${rodIndex == 0 ? 'درآمد' : 'هزینه'}: ${formatter.format(rod.toY)} toman',
                          style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'IranYekan',
                              color: Colors.white),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _legend(Color color, String label) {
    return Row(children: [
      Container(
        width: 12,
        height: 12,
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
      ),
      const SizedBox(width: 6),
      Text(label,
          style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontFamily: 'IranYekan')),
    ]);
  }
}
