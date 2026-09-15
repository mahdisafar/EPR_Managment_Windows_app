import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:eprwindowsapp/features/inventory/data/models/product_model.dart';
import 'unit_selector_dropdown.dart';

class ProductDataTable extends StatelessWidget {
  final List<ProductModel> products;

  const ProductDataTable({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final formatter = intl.NumberFormat('#,##0.##', 'fa_IR');

    if (products.isEmpty) {
      return const Center(
        child: Text(
          'هیچ کالایی در انبار ثبت نشده است.',
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
                label: Text('نام کالا',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
            DataColumn(
                label: Text('واحد',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
            DataColumn(
                label: Text('موجودی فعلی',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
            DataColumn(
                label: Text('قیمت خرید (toman)',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
            DataColumn(
                label: Text('فی تمام‌شده (toman)',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
            DataColumn(
                label: Text('ارزش موجودی (toman)',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
          ],
          rows: products.map((product) {
            final isLowStock = product.currentStock <= 0;
            return DataRow(
              cells: [
                DataCell(Text(product.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontFamily: 'IranYekan'))),
                DataCell(Text(UnitSelectorDropdown.labelOf(product.unit),
                    style: const TextStyle(fontFamily: 'IranYekan'))),
                DataCell(Text(
                  formatter.format(product.currentStock),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isLowStock ? Colors.red.shade700 : Colors.black87,
                    fontFamily: 'IranYekan',
                  ),
                )),
                DataCell(Text(formatter.format(product.purchasePrice),
                    style: const TextStyle(fontFamily: 'IranYekan'))),
                DataCell(Text(
                  formatter.format(product.landedCost),
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade800,
                      fontFamily: 'IranYekan'),
                )),
                DataCell(Text(
                  formatter.format(product.currentStock * product.landedCost),
                  style: const TextStyle(fontFamily: 'IranYekan'),
                )),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
