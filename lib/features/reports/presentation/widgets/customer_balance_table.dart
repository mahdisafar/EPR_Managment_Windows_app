import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../bloc/reports_bloc.dart';

class CustomerBalanceTable extends StatelessWidget {
  final List<CustomerBalanceRow> rows;

  const CustomerBalanceTable({super.key, required this.rows});

  static const TextStyle _h = TextStyle(
      fontWeight: FontWeight.bold, fontFamily: 'IranYekan', fontSize: 11);

  @override
  Widget build(BuildContext context) {
    final f = intl.NumberFormat('#,##0.##', 'fa_IR');

    if (rows.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
            child: Text('مشتری‌ای یافت نشد.',
                style: TextStyle(fontFamily: 'IranYekan', color: Colors.grey))),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 470,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
          headingRowHeight: 40,
          dataRowMinHeight: 44,
          dataRowMaxHeight: 44,
          columnSpacing: 12,
          dividerThickness: 0.5,
          columns: const [
            DataColumn(label: Text('کد', style: _h)),
            DataColumn(label: Text('مشتری', style: _h)),
            DataColumn(label: Text('خرید', style: _h)),
            DataColumn(label: Text('پرداخت', style: _h)),
            DataColumn(label: Text('مانده', style: _h)),
          ],
          rows: rows.take(8).map((c) {
            final debtor = c.balance > 0;
            return DataRow(cells: [
              DataCell(Text(c.code,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'IranYekan'))),
              DataCell(Text(c.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(fontSize: 12, fontFamily: 'IranYekan'))),
              DataCell(Text(f.format(c.totalPurchases),
                  style:
                      const TextStyle(fontSize: 12, fontFamily: 'IranYekan'))),
              DataCell(Text(f.format(c.totalPayments),
                  style:
                      const TextStyle(fontSize: 12, fontFamily: 'IranYekan'))),
              DataCell(Row(children: [
                Text(f.format(c.balance.abs()),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: debtor
                            ? Colors.red.shade700
                            : Colors.green.shade700,
                        fontFamily: 'IranYekan')),
                const SizedBox(width: 4),
                Text(debtor ? 'بدهکار' : 'بستانکار',
                    style: TextStyle(
                        fontSize: 9,
                        color: debtor
                            ? Colors.red.shade400
                            : Colors.green.shade600,
                        fontFamily: 'IranYekan')),
              ])),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
