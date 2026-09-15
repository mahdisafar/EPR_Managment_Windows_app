import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class CustomerSummaryCards extends StatelessWidget {
  final int totalCount;
  final double totalReceivables;
  final double totalPayables;

  const CustomerSummaryCards({
    super.key,
    required this.totalCount,
    required this.totalReceivables,
    required this.totalPayables,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = intl.NumberFormat("#,##0.##", "fa_IR");

    return Row(
      children: [
        Expanded(
          child: _buildCard(
            title: 'تعداد کل مشتریان',
            value: '$totalCount نفر',
            icon: Icons.people_alt_outlined,
            color: Colors.blue.shade700,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildCard(
            title: 'کل طلبکارات (باقیات مشتریان)',
            value: '${currencyFormatter.format(totalReceivables)} toman',
            icon: Icons.arrow_downward_rounded,
            color: Colors.red.shade600,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildCard(
            title: 'کل پیش‌پرداخت‌ها (بدهکاری ما)',
            value: '${currencyFormatter.format(totalPayables)} toman',
            icon: Icons.arrow_upward_rounded,
            color: Colors.green.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
          ),
        ],
      ),
    );
  }
}
