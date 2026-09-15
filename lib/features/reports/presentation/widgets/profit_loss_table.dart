import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../../domain/usecases/get_profit_and_loss_use_case.dart';

class ProfitLossTable extends StatelessWidget {
  final ProfitAndLossReport report;

  const ProfitLossTable({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final formatter = intl.NumberFormat('#,##0.##', 'fa_IR');
    final isProfit = report.netProfitOrLoss >= 0;

    final rows = [
      ('درآمد فروش (نسیه و نقد)', report.totalSalesRevenue, Colors.black87),
      (
        'بهای تمام‌شده کالای فروش‌رفته (-)',
        report.totalCostOfGoodsSold,
        Colors.red.shade700
      ),
      ('سود ناخالص', report.grossProfit, Colors.blue.shade800),
      (
        'مصارف عملیاتی بازه (-)',
        report.totalOperatingExpenses,
        Colors.red.shade700
      ),
      (
        isProfit ? 'سود خالص' : 'زیان خالص',
        report.netProfitOrLoss,
        isProfit ? Colors.green.shade800 : Colors.red.shade900
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
        columns: const [
          DataColumn(
              label: Text('شرح',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
          DataColumn(
              label: Text('مبلغ (toman)',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
        ],
        rows: rows.asMap().entries.map((entry) {
          final isLast = entry.key == rows.length - 1;
          return DataRow(
            color:
                isLast ? WidgetStateProperty.all(Colors.grey.shade100) : null,
            cells: [
              DataCell(Text(
                entry.value.$1,
                style: TextStyle(
                  fontFamily: 'IranYekan',
                  fontWeight:
                      (entry.key >= 2) ? FontWeight.bold : FontWeight.normal,
                ),
              )),
              DataCell(Text(
                formatter.format(entry.value.$2),
                style: TextStyle(
                  fontFamily: 'IranYekan',
                  fontWeight: FontWeight.bold,
                  color: entry.value.$3,
                  fontSize: isLast ? 15 : 13,
                ),
              )),
            ],
          );
        }).toList(),
      ),
    );
  }
}
