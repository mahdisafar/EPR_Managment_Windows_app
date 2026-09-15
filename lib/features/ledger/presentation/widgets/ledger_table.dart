import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../core/models/transaction_model.dart';
import 'package:eprwindowsapp/config/enum.dart';

class LedgerTable extends StatelessWidget {
  final List<TransactionModel> transactions;
  final Map<String, double> runningBalances;

  const LedgerTable({
    super.key,
    required this.transactions,
    this.runningBalances = const {},
  });

  static String referenceLabel(ReferenceType type) {
    switch (type) {
      case ReferenceType.general:
        return 'عمومی';
      case ReferenceType.customer:
        return 'مشتری';
      case ReferenceType.shipment:
        return 'محموله';
      case ReferenceType.inventory:
        return 'انبار / فاکتور';
      case ReferenceType.customerPayment:
        return 'رسید مشتری';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = intl.NumberFormat("#,##0.##", "fa_IR");

    if (transactions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'هیچ تراکنشی یافت نشد.',
            style: TextStyle(fontFamily: 'IranYekan', color: Colors.grey),
          ),
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
          dividerThickness: 0.5,
          columns: const [
            DataColumn(
                label: Text('تاریخ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IranYekan',
                        fontSize: 12))),
            DataColumn(
                label: Text('سند',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IranYekan',
                        fontSize: 12))),
            DataColumn(
                label: Text('شرح',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IranYekan',
                        fontSize: 12))),
            DataColumn(
                label: Text('مرجع',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IranYekan',
                        fontSize: 12))),
            DataColumn(
                label: Text('آمد',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IranYekan',
                        fontSize: 12))),
            DataColumn(
                label: Text('رفت',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IranYekan',
                        fontSize: 12))),
            DataColumn(
                label: Text('مانده',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IranYekan',
                        fontSize: 12))),
          ],
          rows: transactions.map((tx) {
            final isExpense = tx.type == TransactionType.expense;
            final running = runningBalances[tx.id];

            return DataRow(
              cells: [
                DataCell(Text(
                  intl.DateFormat('yyyy/MM/dd').format(tx.date),
                  style: const TextStyle(fontSize: 12, fontFamily: 'IranYekan'),
                )),
                DataCell(Text(
                  tx.documentNumber ?? '---',
                  style: const TextStyle(fontSize: 12, fontFamily: 'IranYekan'),
                )),
                DataCell(Text(
                  tx.title,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'IranYekan'),
                )),
                DataCell(Chip(
                  label: Text(
                    referenceLabel(tx.referenceType),
                    style:
                        const TextStyle(fontSize: 10, fontFamily: 'IranYekan'),
                  ),
                  backgroundColor: Colors.grey.shade100,
                  visualDensity: VisualDensity.compact,
                )),
                DataCell(isExpense
                    ? const Text('—',
                        style: TextStyle(
                            color: Colors.grey, fontFamily: 'IranYekan'))
                    : Text(
                        currencyFormatter.format(tx.amount),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                          fontFamily: 'IranYekan',
                        ),
                      )),
                DataCell(!isExpense
                    ? const Text('—',
                        style: TextStyle(
                            color: Colors.grey, fontFamily: 'IranYekan'))
                    : Text(
                        currencyFormatter.format(tx.amount),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                          fontFamily: 'IranYekan',
                        ),
                      )),
                DataCell(Text(
                  running != null ? currencyFormatter.format(running) : '---',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IranYekan',
                    color: (running ?? 0) >= 0
                        ? Colors.blue.shade900
                        : Colors.red.shade900,
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
