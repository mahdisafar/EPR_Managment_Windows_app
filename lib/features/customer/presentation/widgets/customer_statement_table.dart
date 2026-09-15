import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../../data/models/customer_statement_dto.dart';

class CustomerStatementTable extends StatelessWidget {
  final List<CustomerStatementDTO> statements;

  const CustomerStatementTable({
    super.key,
    required this.statements,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = intl.NumberFormat("#,##0.##", "fa_IR");

    if (statements.isEmpty) {
      return const Center(
        child: Text(
          'هیچ تراکنشی برای این مشتری ثبت نشده است.',
          style: TextStyle(fontFamily: 'IranYekan', color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
          dataRowMinHeight: 52,
          dataRowMaxHeight: 52,
          columns: const [
            DataColumn(
                label: Text('تاریخ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
            DataColumn(
                label: Text('شرح / تفصیلات',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
            DataColumn(
                label: Text('تعداد',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
            DataColumn(
                label: Text('فی قیمت',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
            DataColumn(
                label: Text('جمله فاکتور (toman)',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
            DataColumn(
                label: Text('رسیدات نقد (toman)',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
            DataColumn(
                label: Text('بیلانس لحظه‌ای (toman)',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
          ],
          rows: statements.map((item) {
            final formattedDate =
                intl.DateFormat('yyyy/MM/dd').format(item.date);

            return DataRow(
              cells: [
                DataCell(Text(
                  formattedDate,
                  style: const TextStyle(fontFamily: 'IranYekan'),
                )),
                DataCell(Text(
                  item.details,
                  style: const TextStyle(
                      fontFamily: 'IranYekan', fontWeight: FontWeight.w500),
                )),
                DataCell(Text(
                  item.quantity != null
                      ? currencyFormatter.format(item.quantity)
                      : '---',
                  style: const TextStyle(fontFamily: 'IranYekan'),
                )),
                DataCell(Text(
                  item.price != null
                      ? currencyFormatter.format(item.price)
                      : '---',
                  style: const TextStyle(fontFamily: 'IranYekan'),
                )),
                DataCell(Text(
                  item.totalAmount > 0
                      ? currencyFormatter.format(item.totalAmount)
                      : '---',
                  style: TextStyle(
                    fontFamily: 'IranYekan',
                    fontWeight: FontWeight.bold,
                    color: item.totalAmount > 0
                        ? Colors.red.shade700
                        : Colors.black87,
                  ),
                )),
                DataCell(Text(
                  item.receipts > 0
                      ? currencyFormatter.format(item.receipts)
                      : '---',
                  style: TextStyle(
                    fontFamily: 'IranYekan',
                    fontWeight: FontWeight.bold,
                    color: item.receipts > 0
                        ? Colors.green.shade700
                        : Colors.black87,
                  ),
                )),
                DataCell(Text(
                  currencyFormatter.format(item.runningBalance),
                  style: const TextStyle(
                    fontFamily: 'IranYekan',
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
