import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../../data/models/personal_expense_model.dart';

class PersonalExpenseTable extends StatelessWidget {
  final List<PersonalExpenseModel> expenses;

  const PersonalExpenseTable({super.key, required this.expenses});

  static const TextStyle _headerStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'IranYekan',
    fontSize: 12,
  );

  @override
  Widget build(BuildContext context) {
    final formatter = intl.NumberFormat('#,##0.##', 'fa_IR');
    final dateFormatter = intl.DateFormat('yyyy/MM/dd', 'fa_IR');

    if (expenses.isEmpty) {
      return const Center(
        child: Text('هیچ مصرف شخصی ثبت نشده است.',
            style: TextStyle(fontFamily: 'IranYekan', color: Colors.grey)),
      );
    }

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
          headingRowHeight: 48,
          columns: const [
            DataColumn(label: Text('نام مورد', style: _headerStyle)),
            DataColumn(label: Text('دسته', style: _headerStyle)),
            DataColumn(label: Text('تعداد', style: _headerStyle)),
            DataColumn(label: Text('فی', style: _headerStyle)),
            DataColumn(label: Text('جمع (toman)', style: _headerStyle)),
            DataColumn(label: Text('تاریخ', style: _headerStyle)),
            DataColumn(label: Text('از حساب', style: _headerStyle)),
            DataColumn(label: Text('یادداشت', style: _headerStyle)),
          ],
          rows: expenses.map((e) {
            return DataRow(cells: [
              DataCell(Text(e.itemName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontFamily: 'IranYekan'))),
              DataCell(Text(e.category,
                  style: const TextStyle(fontFamily: 'IranYekan'))),
              DataCell(Text(formatter.format(e.quantity),
                  style: const TextStyle(fontFamily: 'IranYekan'))),
              DataCell(Text(formatter.format(e.unitPrice),
                  style: const TextStyle(fontFamily: 'IranYekan'))),
              DataCell(Text(
                formatter.format(e.totalAmount),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                  fontFamily: 'IranYekan',
                ),
              )),
              DataCell(Text(dateFormatter.format(e.date),
                  style: const TextStyle(fontFamily: 'IranYekan'))),
              DataCell(Text(e.accountName ?? '---',
                  style: const TextStyle(fontFamily: 'IranYekan'))),
              DataCell(Text(e.notes ?? '---',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.grey.shade600, fontFamily: 'IranYekan'))),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
