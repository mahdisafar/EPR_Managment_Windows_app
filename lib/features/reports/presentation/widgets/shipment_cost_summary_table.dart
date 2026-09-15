import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../bloc/reports_bloc.dart';

class ShipmentCostSummaryTable extends StatelessWidget {
  final List<ShipmentSummaryRow> rows;

  const ShipmentCostSummaryTable({super.key, required this.rows});

  static const TextStyle _h = TextStyle(
      fontWeight: FontWeight.bold, fontFamily: 'IranYekan', fontSize: 11);

  @override
  Widget build(BuildContext context) {
    final f = intl.NumberFormat('#,##0.##', 'fa_IR');

    if (rows.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
            child: Text('محموله‌ای یافت نشد.',
                style: TextStyle(fontFamily: 'IranYekan', color: Colors.grey))),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 620,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
          headingRowHeight: 40,
          dataRowMinHeight: 44,
          dataRowMaxHeight: 44,
          columnSpacing: 12,
          dividerThickness: 0.5,
          columns: const [
            DataColumn(label: Text('شماره', style: _h)),
            DataColumn(label: Text('مسیر', style: _h)),
            DataColumn(label: Text('وضعیت', style: _h)),
            DataColumn(label: Text('ارزش کالا', style: _h)),
            DataColumn(label: Text('جمع مصارف', style: _h)),
          ],
          rows: rows.map((s) {
            return DataRow(cells: [
              DataCell(Text(s.number,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'IranYekan'))),
              DataCell(Text(s.route,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(fontSize: 12, fontFamily: 'IranYekan'))),
              DataCell(Text(s.statusLabel,
                  style:
                      const TextStyle(fontSize: 12, fontFamily: 'IranYekan'))),
              DataCell(Text(f.format(s.cargoValue),
                  style:
                      const TextStyle(fontSize: 12, fontFamily: 'IranYekan'))),
              DataCell(Text(f.format(s.totalExpenses),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: s.totalExpenses > 0
                          ? Colors.red.shade700
                          : Colors.grey,
                      fontFamily: 'IranYekan'))),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
