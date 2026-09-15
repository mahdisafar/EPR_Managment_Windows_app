import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:eprwindowsapp/config/enum.dart';
import '../../data/models/invoice_model.dart';

class InvoiceListTable extends StatelessWidget {
  final List<InvoiceModel> invoices;
  final Map<String, String> customerNames;
  final Function(InvoiceModel invoice) onPrint;

  const InvoiceListTable({
    super.key,
    required this.invoices,
    this.customerNames = const {},
    required this.onPrint,
  });

  static const TextStyle _headerStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'IranYekan',
    fontSize: 12,
  );

  @override
  Widget build(BuildContext context) {
    final formatter = intl.NumberFormat('#,##0.##', 'fa_IR');
    final dateFormatter = intl.DateFormat('yyyy/MM/dd', 'fa_IR');

    if (invoices.isEmpty) {
      return const Center(
        child: Text('هیچ فاکتوری یافت نشد.',
            style: TextStyle(fontFamily: 'IranYekan', color: Colors.grey)),
      );
    }

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
          headingRowHeight: 48,
          dividerThickness: 0.5,
          columns: const [
            DataColumn(label: Text('شماره فاکتور', style: _headerStyle)),
            DataColumn(label: Text('نوع', style: _headerStyle)),
            DataColumn(label: Text('طرف حساب', style: _headerStyle)),
            DataColumn(label: Text('تاریخ', style: _headerStyle)),
            DataColumn(label: Text('اقلام', style: _headerStyle)),
            DataColumn(label: Text('مبلغ کل (toman)', style: _headerStyle)),
            DataColumn(label: Text('چاپ', style: _headerStyle)),
          ],
          rows: invoices.map((inv) {
            final isSale = inv.type == InvoiceType.sale;
            return DataRow(cells: [
              DataCell(Text(inv.invoiceNumber,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontFamily: 'IranYekan'))),
              DataCell(Chip(
                label: Text(isSale ? 'فروش' : 'خرید',
                    style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontFamily: 'IranYekan')),
                backgroundColor: isSale ? Colors.green : Colors.blue,
                visualDensity: VisualDensity.compact,
              )),
              DataCell(Text(
                isSale
                    ? (customerNames[inv.customerId] ?? '---')
                    : (inv.details?.trim().isNotEmpty == true
                        ? inv.details!.trim()
                        : '---'),
                style: const TextStyle(fontFamily: 'IranYekan'),
              )),
              DataCell(Text(dateFormatter.format(inv.date),
                  style: const TextStyle(fontFamily: 'IranYekan'))),
              DataCell(Text(formatter.format(inv.items.length),
                  style: const TextStyle(fontFamily: 'IranYekan'))),
              DataCell(Text(
                formatter.format(inv.totalAmount),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSale ? Colors.green.shade800 : Colors.red.shade700,
                  fontFamily: 'IranYekan',
                ),
              )),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.print_outlined,
                      size: 18, color: Color(0xFF1E3A8A)),
                  tooltip: 'چاپ / پیش‌نمایش PDF',
                  onPressed: () => onPrint(inv),
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
