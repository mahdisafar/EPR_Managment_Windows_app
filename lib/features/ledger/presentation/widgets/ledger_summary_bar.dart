import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class LedgerSummaryBar extends StatelessWidget {
  final int transactionCount;
  final double totalCredit;
  final double totalDebit;

  const LedgerSummaryBar({
    super.key,
    required this.transactionCount,
    required this.totalCredit,
    required this.totalDebit,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = intl.NumberFormat("#,##0.##", "fa_IR");

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryItem(
            title: 'تعداد تراکنش‌ها',
            value: '$transactionCount فقره',
            color: Colors.blue,
          ),
          const SizedBox(height: 30, child: VerticalDivider()),
          _SummaryItem(
            title: 'مجموع ورودی / بستانکار',
            value: '${currencyFormatter.format(totalCredit)} toman',
            color: Colors.green,
          ),
          const SizedBox(height: 30, child: VerticalDivider()),
          _SummaryItem(
            title: 'مجموع خروجی / بدهکار',
            value: '${currencyFormatter.format(totalDebit)} toman',
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _SummaryItem({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontFamily: 'IranYekan',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'IranYekan',
          ),
        ),
      ],
    );
  }
}
